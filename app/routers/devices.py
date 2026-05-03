from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func
from uuid import UUID
from typing import Optional, List
import uuid
from pydantic import BaseModel, Field
from app.db.database import get_db
from app.models.device import Device, Organization
from app.models.camera import Camera, CameraRule
from app.core.security import create_device_token
from app.schemas.device import (
    DeviceHandshakeSchema,
    DeviceProvisionSchema,
    DeviceResponse,
    ProvisionResponseSchema
)
from app.models.capabilities import OrganizationCapability
from app.schemas.capabilities import CapabilityResponse, CapabilityUpdate
from app.core.dependencies import get_current_device_from_token, get_current_active_user
from app.models.user import User

router = APIRouter(prefix="/devices", tags=["Devices (Hardware)"])


@router.get("/", response_model=List[DeviceResponse])
async def list_devices(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db),
):
    """Returns all edge devices for the authenticated user's organization."""
    stmt = select(Device).where(Device.organization_id == current_user.organization_id)
    result = await db.execute(stmt)
    return result.scalars().all()


async def get_device_by_token(device_token: str, db: AsyncSession) -> Device:
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
async def handshake(data: DeviceHandshakeSchema, db: AsyncSession = Depends(get_db)):
    """Authenticates the device and updates its heartbeat. Camera management is now web-only."""
    device = await get_device_by_token(data.device_token_secret, db)
    device.last_heartbeat = func.now()
    device.name = data.hostname
    await db.commit()
    return {"status": "success", "device_id": device.id, "message": "Device heartbeat updated."}

@router.get("/config/{device_id}")
async def get_device_config(device_id: UUID, db: AsyncSession = Depends(get_db)):
    """Retrieves full camera config (rules + display fields) for the Edge desktop."""
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
            "name": camera.name,
            "location": camera.location,
            "rtsp_url": camera.rtsp_url,
            "status": camera.status or "Offline",
            "required_ppe": rules.active_rules,
            "active_rules": rules.active_rules,
            "detection_zones": rules.detection_zones or [],
            "cooldown_sec": rules.violation_cooldown_sec,
            "is_active": rules.is_active,
        })

    return {"device_id": device_id, "cameras": config_list}

class CameraActiveUpdate(BaseModel):
    is_active: bool


@router.patch("/cameras/{camera_id}/active")
async def set_camera_active(
    camera_id: UUID,
    body: CameraActiveUpdate,
    current_device: Device = Depends(get_current_device_from_token),
    db: AsyncSession = Depends(get_db),
):
    """Toggle detection activation for a camera (device token auth)."""
    cam_stmt = select(Camera).where(
        Camera.id == camera_id,
        Camera.device_id == current_device.id,
    )
    camera = (await db.execute(cam_stmt)).scalars().first()
    if not camera:
        raise HTTPException(status_code=404, detail="Camera not found for this device.")

    rule_stmt = select(CameraRule).where(CameraRule.camera_id == camera_id)
    rule = (await db.execute(rule_stmt)).scalars().first()
    if not rule:
        rule = CameraRule(camera_id=camera_id, active_rules={}, is_active=body.is_active)
        db.add(rule)
    else:
        rule.is_active = body.is_active

    await db.commit()
    await db.refresh(rule)

    return {
        "camera_id": camera.id,
        "is_active": rule.is_active,
        "message": "Camera activation updated.",
    }


@router.post("/provision", response_model=ProvisionResponseSchema, status_code=201)
async def provision_new_device(data: DeviceProvisionSchema, db: AsyncSession = Depends(get_db)):
    """Admin endpoint to create Org + Device."""
    new_org = Organization(name=data.organization_name, status="Active")
    db.add(new_org)
    await db.flush()

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

@router.post("/link")
async def link_device(device_token: str, db: AsyncSession = Depends(get_db)):
    """
    Validate device token and return device info + subscription status.
    Called by Edge service on startup to confirm device is registered and active.
    """
    stmt = select(Device).where(Device.device_token_secret == device_token)
    result = await db.execute(stmt)
    device = result.scalars().first()

    if not device:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Invalid device token."
        )

    # Get organization info
    org_stmt = select(Organization).where(Organization.id == device.organization_id)
    org_result = await db.execute(org_stmt)
    organization = org_result.scalars().first()

    # Update last heartbeat
    device.last_heartbeat = func.now()
    await db.commit()

    return {
        "success": True,
        "device_id": device.id,
        "organization_id": device.organization_id,
        "organization_name": organization.name if organization else None,
        "subscription_active": device.subscription_active,
        "message": "Device linked successfully."
    }

# ===== DEVICE CAPABILITIES (Hardware) =====

@router.get("/capabilities", response_model=List[CapabilityResponse])
async def get_device_capabilities(
    current_device: Device = Depends(get_current_device_from_token),
    db: AsyncSession = Depends(get_db)
):
    """
    Fetch all organization capabilities using device token authentication.
    The device's organization_id is used to filter capabilities.
    """
    stmt = select(OrganizationCapability).where(
        OrganizationCapability.organization_id == current_device.organization_id
    )
    result = await db.execute(stmt)
    return result.scalars().all()

@router.patch("/capabilities/{object_code}", response_model=CapabilityResponse)
async def update_device_capability(
    object_code: str,
    capability_data: CapabilityUpdate,
    current_device: Device = Depends(get_current_device_from_token),
    db: AsyncSession = Depends(get_db)
):
    """
    Update a capability's display_name and/or is_ppe fields using device token authentication.
    Only fields provided in the request body will be updated (partial update).
    """
    # Find the capability by organization_id and object_code
    stmt = select(OrganizationCapability).where(
        OrganizationCapability.organization_id == current_device.organization_id,
        OrganizationCapability.object_code == object_code
    )
    result = await db.execute(stmt)
    capability = result.scalars().first()

    if not capability:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Capability with object_code '{object_code}' not found in this organization."
        )

    # Update only the provided fields
    if capability_data.display_name is not None:
        capability.display_name = capability_data.display_name
    if capability_data.is_ppe is not None:
        capability.is_ppe = capability_data.is_ppe

    await db.commit()
    await db.refresh(capability)
    return capability