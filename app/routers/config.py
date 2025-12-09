# app/routers/config.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.database import get_db
from app.models.user import User
from app.models.device import Device
from app.schemas.device import DeviceResponse, CameraRuleUpdate, CameraRuleResponse
from app.core.dependencies import get_current_active_user
from sqlalchemy.future import select

router = APIRouter(prefix="/config", tags=["Configuration"])

@router.post("/rules", response_model=CameraRuleResponse)
async def update_camera_rules(
        rules_data: CameraRuleUpdate,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """
    Updates the safety rules and name for an Edge Device (camera).
    Requires GlobalAdmin or Supervisor role.
    """

    # 1. Authorization Check (RBAC)
    if current_user.role not in ["GlobalAdmin", "Supervisor"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only Global Admins or Supervisors can configure camera rules."
        )

    # 2. Multi-Tenancy Check & Device Retrieval
    stmt = select(Device).where(
        Device.id == rules_data.device_id,
        Device.organization_id == current_user.organization_id
    )
    device = (await db.execute(stmt)).scalar_one_or_none()

    if not device:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Device not found or does not belong to your organization."
        )

    # 3. Apply Updates (Simplified rules and name)
    device.name = rules_data.name
    device.require_helmet = rules_data.require_helmet
    device.require_vest = rules_data.require_vest
    device.require_gloves = rules_data.require_gloves
    # NOTE: The edge processor needs to pull these changes later.

    await db.commit()

    return {"device_id": device.id, "message": "Camera rules updated successfully."}