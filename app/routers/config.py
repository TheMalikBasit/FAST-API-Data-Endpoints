from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.db.database import get_db
from app.models.user import User
from app.models.device import Device
from app.models.camera import Camera, CameraRule
from app.schemas.device import CameraRuleUpdate, CameraRuleResponse
from app.core.dependencies import get_current_active_user

router = APIRouter(prefix="/config", tags=["Configuration"])


@router.post("/rules", response_model=CameraRuleResponse)
async def update_camera_rules(
        rules_data: CameraRuleUpdate,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    # 1. Authorization Check
    if current_user.role not in ["GlobalAdmin", "Supervisor"]:
        raise HTTPException(status_code=403, detail="Not authorized.")

    # 2. Fetch CameraRule (Same logic as before)
    stmt = select(CameraRule).join(Camera).where(
        CameraRule.camera_id == rules_data.camera_id,
        Camera.organization_id == current_user.organization_id
    )
    result = await db.execute(stmt)
    rule = result.scalars().first()

    if not rule:
        raise HTTPException(status_code=404, detail="Camera not found.")

    # 3. DYNAMIC UPDATE
    # We directly save the dictionary the frontend sent.
    # Frontend logic: "User checked Helmet box? Send {'helmet': true}"
    rule.active_rules = rules_data.active_rules

    # 4. Update Name
    camera_stmt = select(Camera).where(Camera.id == rules_data.camera_id)
    cam = (await db.execute(camera_stmt)).scalars().first()
    if cam:
        cam.name = rules_data.name

    await db.commit()
    await db.refresh(rule)

    return CameraRuleResponse(
        camera_id=rule.camera_id,
        name=cam.name,
        active_rules=rule.active_rules
    )