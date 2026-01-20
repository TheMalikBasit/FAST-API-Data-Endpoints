from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func, delete
from typing import List
from uuid import UUID
import uuid
from app.db.database import get_db
from app.models.device import Device, Organization
from app.models.camera import Camera, CameraRule
from app.models.capabilities import OrganizationCapability
from app.schemas.capabilities import CapabilitySyncRequest
from app.core.security import create_device_token # This contains token generation function
from app.schemas.device import DeviceHandshakeSchema, RTSPStreamSchema, DeviceProvisionSchema, ProvisionResponseSchema, DeviceResponse
from app.models.base import BaseModel
from app.models.camera import CameraRule as CameraRuleModel
from app.core.dependencies import get_current_active_user
from sqlalchemy.future import select
from app.models.user import User

router = APIRouter(prefix="/devices", tags=["Devices"])

# Dependency to check Device Authentication (Still needs working)
async def get_device_by_token(
        device_token: str, db: AsyncSession = Depends(get_db)
) -> Device:
    """Authenticates the device using its secret token."""
    # This Builds the SQLAlchemy select statement (2.0 style)
    stmt = select(Device).where(Device.device_token_secret == device_token)
    result = await db.execute(stmt) # This executes the statement asynchronously
    device = result.scalars().first() # Getting the Device object, if it exists

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
    """
    Handles initial device authentication, heartbeat, and local camera registration.
    """
    # Authenticate the device using the token from the request payload
    device = await get_device_by_token(data.device_token_secret, db)

    # 1. Update Device Heartbeat/Hostname (Health Check)
    device.last_heartbeat = func.now()
    device.name = data.hostname # Updates hostname in case the local name changed

    # 2. Register/Update Cameras
    for camera_data in data.cameras:
        # Check if a camera with this RTSP URL already exists for this device
        camera_stmt = select(Camera).where(
            Camera.device_id == device.id,
            Camera.rtsp_url == str(camera_data.rtsp_url)
        )
        existing_camera = (await db.execute(camera_stmt)).scalars().first()

        if existing_camera:
            # Camera exists (UPDATE METHOD): Update the status and name if needed
            existing_camera.status = "Online"
            await db.commit()
        else:
            # Camera is new (INSERT METHOD): Create the new Camera record
            new_camera = Camera(
                organization_id=device.organization_id,
                device_id=device.id,
                name=camera_data.local_name or str(camera_data.rtsp_url),
                rtsp_url=str(camera_data.rtsp_url),
                local_timezone="UTC",
                status="Online"
            )
            db.add(new_camera)
            await db.flush() # Flush to get the camera.id before committing

            # Create default camera rules immediately
            default_rules = CameraRuleModel(
                camera_id=new_camera.id,
                ppe_helmet_required=False,
                ppe_vest_required=False,
                ppe_glasses_required=False
            )
            db.add(default_rules)

    await db.commit() # Final commit of new cameras and rules

    return {"status": "success", "device_id": device.id, "message": "Cameras synchronized."}

@router.post("/capabilities/sync")
async def sync_capabilities(
        payload: CapabilitySyncRequest,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """
    Called by the Edge ML model to register its detection classes in the Cloud DB.
    """
    org_id = current_user.organization_id

    # 1. This clears the existing capabilities/objects in Cloud DB to ensure the list is fresh
    delete_stmt = delete(OrganizationCapability).where(OrganizationCapability.organization_id == org_id)
    await db.execute(delete_stmt)

    # 2. Insert new capabilities
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
    """Retrieves all configuration (RTSP URL, rules, zones) for a specific device."""

    # 1. Check if device exists
    device_stmt = select(Device).where(Device.id == device_id)
    device_result = await db.execute(device_stmt)
    device = device_result.scalars().first()

    if not device:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Device not found.")

    # 2. Select Cameras and their Rules
    stmt = select(Camera, CameraRule).join(CameraRule).where(Camera.device_id == device_id)
    results = await db.execute(stmt)

    # 3. Process results for Edge Docker
    config_list = []
    for camera, rules in results.all():
        config_list.append({
            "camera_id": camera.id,
            "rtsp_url": camera.rtsp_url,

            # --- FIX APPLIED: Using Dynamic Rules now ---
            # Instead of hardcoded "helmet" objects, we are sending the entire JSON map
            # The Edge PC will check: if rules['required_ppe'].get('helmet'): ...
            "required_ppe": rules.active_rules,
            "detection_zones": rules.detection_zones or [],
            "cooldown_sec": rules.violation_cooldown_sec,
            "is_active": rules.is_active
        })

    return {"device_id": device_id, "cameras": config_list}

# PLACEHOLDER: In the future, this will check if the user is a GlobalAdmin
async def get_current_admin_user():
    """Dependency that ensures the request is coming from an authenticated admin."""
    # TODO: Implement real JWT/session validation and role check later
    # For now, we allow access but acknowledge it's unprotected
    print("WARNING: Provisioning endpoint is unprotected! Implement admin auth immediately.")
    return True

@router.post(
    "/provision",
    response_model=ProvisionResponseSchema,
    status_code=status.HTTP_201_CREATED,
    # This dependency will ensure only admins can use it once implemented
    dependencies=[Depends(get_current_admin_user)]
)
async def provision_new_device(
        data: DeviceProvisionSchema,
        db: AsyncSession = Depends(get_db)
):
    """
    Admin endpoint to provision a new Organization and generate a secure
    device token for the Edge deployment.
    """

    # 1. Create New Organization
    new_org = Organization(name=data.organization_name, status="Active")
    db.add(new_org)
    await db.flush() # Flush to get the new_org.id

    # 2. Generate Secret Token
    # We use a UUID for the device ID, then generate the long-lived token
    new_device_id = UUID(str(uuid.uuid4()))
    secure_token = create_device_token(new_device_id)

    # 3. Create New Device Record
    new_device = Device(
        id=new_device_id,
        organization_id=new_org.id,
        name=data.device_name,
        device_token_secret=secure_token,
    )
    db.add(new_device)

    await db.commit()

    # 4. Return the secure token (MUST be handled securely by the client!)
    return {
        "organization_id": new_org.id,
        "device_id": new_device.id,
        "device_token_secret": secure_token,
        "message": f"Organization '{data.organization_name}' created with device '{data.device_name}'."
    }

@router.get("/list", response_model=List[DeviceResponse])
async def list_organization_devices(
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """Retrieves all devices/cameras belonging to the authenticated user's organization."""

    # Filter devices by the user's organization ID (Multi-Tenancy Enforced)
    stmt = select(Device).where(
        Device.organization_id == current_user.organization_id
    )
    result = await db.execute(stmt)
    devices = result.scalars().all()

    return devices

@router.post("/capabilities/sync")
async def sync_capabilities(
        capabilities: List[dict],  # List of {'object_code': str, 'display_name': str, 'is_ppe': bool}
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """
    Called by the Edge ML model to register its detection classes in the Cloud DB.
    """
    org_id = current_user.organization_id

    # Clear existing capabilities to ensure the list is fresh for the current model version
    delete_stmt = delete(OrganizationCapability).where(OrganizationCapability.organization_id == org_id)
    await db.execute(delete_stmt)

    # Insert new capabilities
    for cap in capabilities:
        new_cap = OrganizationCapability(
            organization_id=org_id,
            object_code=cap['object_code'],
            display_name=cap['display_name'],
            is_ppe=cap.get('is_ppe', False)
        )
        db.add(new_cap)

    await db.commit()
    return {"status": "success", "synced_count": len(capabilities)}