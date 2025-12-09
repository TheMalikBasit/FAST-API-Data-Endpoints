from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List
from uuid import UUID
import uuid
from app.db.database import get_db
from app.models.device import Device, Organization
from app.models.camera import Camera, CameraRule
from app.core.security import create_device_token # Import token generation function
from app.schemas.device import DeviceHandshakeSchema, RTSPStreamSchema, DeviceProvisionSchema, ProvisionResponseSchema, DeviceResponse
from app.models.base import BaseModel # Import Base model to create new rules
from app.models.camera import CameraRule as CameraRuleModel
from app.core.dependencies import get_current_active_user
from sqlalchemy.future import select
router = APIRouter(prefix="/devices", tags=["Devices"])
from app.models.user import User

# Dependency to check Device Authentication (will be expanded later for real token validation)
async def get_device_by_token(
        device_token: str, db: AsyncSession = Depends(get_db)
) -> Device:
    """Authenticates the device using its secret token."""
    # Build the SQLAlchemy select statement (2.0 style)
    stmt = select(Device).where(Device.device_token_secret == device_token)

    # Execute the statement asynchronously
    result = await db.execute(stmt)

    # Get the Device object, if it exists
    device = result.scalars().first()

    if not device:
        # Raise 403 Forbidden if the token is invalid
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

    Performs a single-pass UPSERT (Update/Insert) for cameras based on RTSP URL.
    """

    # Authenticate the device using the token from the request payload
    device = await get_device_by_token(data.device_token_secret, db)

    # 1. Update Device Heartbeat/Hostname (Health Check)
    device.last_heartbeat = func.now()
    device.name = data.hostname # Update hostname in case the local name changed

    # 2. Register/Update Cameras
    for camera_data in data.cameras:
        # Check if a camera with this RTSP URL already exists for this device
        camera_stmt = select(Camera).where(
            Camera.device_id == device.id,
            Camera.rtsp_url == str(camera_data.rtsp_url)
        )
        existing_camera = (await db.execute(camera_stmt)).scalars().first()

        if existing_camera:
            # Camera exists (UPDATE): Update status and name if needed
            existing_camera.status = "Online"
            await db.commit() # Commit update
        else:
            # Camera is new (INSERT): Create the new Camera record
            new_camera = Camera(
                organization_id=device.organization_id,
                device_id=device.id,
                name=camera_data.local_name or str(camera_data.rtsp_url),
                rtsp_url=str(camera_data.rtsp_url),
                local_timezone="UTC", # Default, will be updated by admin later
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

@router.get("/config/{device_id}")
async def get_device_config(
        device_id: UUID,
        db: AsyncSession = Depends(get_db)
):
    """Retrieves all configuration (RTSP URL, rules, zones) for a specific device."""

    # 1. Check if device exists (and we could add user/token check here for security)
    device_stmt = select(Device).where(Device.id == device_id)
    device_result = await db.execute(device_stmt)
    device = device_result.scalars().first()

    if not device:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Device not found.")

    # 2. Select Cameras and their Rules (JOIN)
    # This complex query fetches Cameras and their related CameraRules in one go.
    stmt = select(Camera, CameraRule).join(CameraRule).where(Camera.device_id == device_id)

    results = await db.execute(stmt)

    # Process results into a structured list for the Edge Docker
    config_list = []
    for camera, rules in results.all():
        config_list.append({
            "camera_id": camera.id,
            "rtsp_url": camera.rtsp_url,
            "required_ppe": {
                "helmet": rules.ppe_helmet_required,
                "vest": rules.ppe_vest_required,
                "glasses": rules.ppe_glasses_required,
            },
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