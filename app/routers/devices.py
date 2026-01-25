from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func, delete
from typing import List, Dict, Any
from uuid import UUID
import uuid
from app.db.database import get_db
from app.models.device import Device, Organization
from app.models.camera import Camera, CameraRule
from app.models.capabilities import OrganizationCapability
from app.models.user import User
from app.core.security import create_device_token
from app.core.dependencies import get_current_active_user
from app.schemas.capabilities import CapabilitySyncRequest, CapabilityResponse
from app.schemas.device import (
    DeviceHandshakeSchema,
    DeviceProvisionSchema,
    ProvisionResponseSchema,
    DeviceResponse
)
from app.schemas.camera import CameraResponse, CameraUpdate
from pydantic import BaseModel

router = APIRouter(prefix="/devices", tags=["Devices & Cameras"])

class CapabilitySchema(BaseModel):
    object_code: str
    display_name: str
    is_ppe: bool
    model_config = {"from_attributes": True}

async def get_device_by_token(
        device_token: str, db: AsyncSession = Depends(get_db)
) -> Device:
    """Authenticates the device using its secret token."""
    stmt = select(Device).where(Device.device_token_secret == device_token)
    result = await db.execute(stmt)
    device = result.scalars().first()

    if not device:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Invalid device token or device is inactive."
        )
    return device


@router.post("/handshake")
async def handshake(
        data: DeviceHandshakeSchema,
        db: AsyncSession = Depends(get_db)
):
    """Handles initial device authentication, heartbeat, and local camera registration."""
    device = await get_device_by_token(data.device_token_secret, db)

    # 1. Update Device Heartbeat
    device.last_heartbeat = func.now()
    device.name = data.hostname

    # 2. Register/Update Cameras
    for camera_data in data.cameras:
        camera_stmt = select(Camera).where(
            Camera.device_id == device.id,
            Camera.rtsp_url == str(camera_data.rtsp_url)
        )
        existing_camera = (await db.execute(camera_stmt)).scalars().first()

        if existing_camera:
            existing_camera.status = "Online"
        else:
            new_camera = Camera(
                organization_id=device.organization_id,
                device_id=device.id,
                name=camera_data.local_name or str(camera_data.rtsp_url),
                rtsp_url=str(camera_data.rtsp_url),
                local_timezone="UTC",
                status="Online",
                # Use name as default location to fix graph issues
                location=camera_data.local_name
            )
            db.add(new_camera)
            await db.flush()

            # Create default rule
            default_rules = CameraRule(
                camera_id=new_camera.id,
                active_rules={},  # Start empty
                is_active=True
            )
            db.add(default_rules)

    await db.commit()
    return {"status": "success", "device_id": device.id, "message": "Cameras synchronized."}


@router.post("/capabilities/sync")
async def sync_capabilities(
        payload: CapabilitySyncRequest,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """Called by the Edge ML model to register its detection classes."""
    org_id = current_user.organization_id

    delete_stmt = delete(OrganizationCapability).where(OrganizationCapability.organization_id == org_id)
    await db.execute(delete_stmt)

    for obj in payload.capabilities:
        new_cap = OrganizationCapability(
            organization_id=org_id,
            object_code=obj.object_code,
            display_name=obj.display_name,
            is_ppe=obj.is_ppe
        )
        db.add(new_cap)

    await db.commit()
    return {"status": "success", "synced_count": len(payload.capabilities)}


@router.get("/config/{device_id}")
async def get_device_config(
        device_id: UUID,
        db: AsyncSession = Depends(get_db)
):
    """Retrieves config (RTSP URL, rules) for Edge Docker."""
    device_stmt = select(Device).where(Device.id == device_id)
    device = (await db.execute(device_stmt)).scalars().first()

    if not device:
        raise HTTPException(status_code=404, detail="Device not found.")

    stmt = select(Camera, CameraRule).join(CameraRule).where(Camera.device_id == device_id)
    results = await db.execute(stmt)

    config_list = []
    for camera, rules in results.all():
        config_list.append({
            "camera_id": camera.id,
            "rtsp_url": camera.rtsp_url,
            "required_ppe": rules.active_rules,  # JSONB Rules
            "detection_zones": rules.detection_zones or [],
            "cooldown_sec": rules.violation_cooldown_sec,
            "is_active": rules.is_active
        })

    return {"device_id": device_id, "cameras": config_list}


@router.post("/provision", response_model=ProvisionResponseSchema, status_code=201)
async def provision_new_device(
        data: DeviceProvisionSchema,
        db: AsyncSession = Depends(get_db)
):
    """Admin endpoint to create Org + Device."""
    # Create Org
    new_org = Organization(name=data.organization_name, status="Active")
    db.add(new_org)
    await db.flush()

    # Create Device
    new_device_id = uuid.uuid4()
    secure_token = create_device_token(new_device_id)

    new_device = Device(
        id=new_device_id,
        organization_id=new_org.id,
        name=data.device_name,
        device_token_secret=secure_token,
    )
    db.add(new_device)
    await db.commit()

    return {
        "organization_id": new_org.id,
        "device_id": new_device.id,
        "device_token_secret": secure_token,
        "message": "Provisioned successfully."
    }


# ==========================================
# PART 2: FRONTEND MANAGEMENT API (The New Stuff)
# ==========================================

@router.get("/cameras", response_model=List[CameraResponse])
async def list_cameras(
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """
    Fetches all CAMERAS (not Devices) for the UI Manage Page.
    Includes their active rules.
    """
    stmt = select(Camera, CameraRule.active_rules).outerjoin(
        CameraRule, Camera.id == CameraRule.camera_id
    ).where(
        Camera.organization_id == current_user.organization_id
    )

    result = await db.execute(stmt)
    rows = result.all()

    cameras_data = []
    for cam, rules_json in rows:
        cameras_data.append(CameraResponse(
            id=cam.id,
            name=cam.name,
            location=cam.location,
            rtsp_url=cam.rtsp_url,
            status=cam.status or "Offline",
            active_rules=rules_json if rules_json else {}
        ))

    return cameras_data


@router.put("/cameras/{camera_id}", response_model=CameraResponse)
async def update_camera(
        camera_id: UUID,
        update_data: CameraUpdate,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """Updates camera details and rules from the UI."""
    stmt = select(Camera).where(
        Camera.id == camera_id,
        Camera.organization_id == current_user.organization_id
    )
    camera = (await db.execute(stmt)).scalars().first()

    if not camera:
        raise HTTPException(status_code=404, detail="Camera not found")

    # Update basic fields
    if update_data.name: camera.name = update_data.name
    if update_data.location: camera.location = update_data.location
    if update_data.rtsp_url: camera.rtsp_url = update_data.rtsp_url

    # Update Rules
    final_rules = {}
    if update_data.active_rules is not None:
        stmt_rules = select(CameraRule).where(CameraRule.camera_id == camera.id)
        rule_record = (await db.execute(stmt_rules)).scalars().first()

        if rule_record:
            rule_record.active_rules = update_data.active_rules
            final_rules = rule_record.active_rules
        else:
            new_rule = CameraRule(
                camera_id=camera.id,
                active_rules=update_data.active_rules,
                is_active=True
            )
            db.add(new_rule)
            final_rules = update_data.active_rules
    else:
        # Just fetching existing if not updated
        stmt_rules = select(CameraRule).where(CameraRule.camera_id == camera.id)
        rule_record = (await db.execute(stmt_rules)).scalars().first()
        if rule_record: final_rules = rule_record.active_rules

    await db.commit()
    await db.refresh(camera)

    return CameraResponse(
        id=camera.id,
        name=camera.name,
        location=camera.location,
        rtsp_url=camera.rtsp_url,
        status=camera.status,
        active_rules=final_rules
    )

@router.get("/capabilities", response_model=List[CapabilityResponse])
async def list_capabilities(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    """Fetches the list of detectable objects for the user's organization."""
    stmt = select(OrganizationCapability).where(
        OrganizationCapability.organization_id == current_user.organization_id
    )
    result = await db.execute(stmt)
    return result.scalars().all()