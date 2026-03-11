from fastapi import APIRouter, Depends, HTTPException, status, BackgroundTasks
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.db.database import get_db
from app.models.user import User
from app.models.device import Device
from app.models.camera import Camera, CameraRule
from app.schemas.device import CameraRuleUpdate, CameraRuleResponse
from app.core.dependencies import get_current_active_user
from app.core.activity_logger import log_activity

router = APIRouter(prefix="/config", tags=["Configuration"])


@router.post("/rules", response_model=CameraRuleResponse)
async def update_camera_rules(
        rules_data: CameraRuleUpdate,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db),
        background_tasks: BackgroundTasks = BackgroundTasks(),
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

    # Track changes for logging
    changes = {}

    # 3. DYNAMIC UPDATE
    # We directly save the dictionary the frontend sent.
    if rule.active_rules != rules_data.active_rules:
        changes["active_rules"] = {"old": rule.active_rules, "new": rules_data.active_rules}
    rule.active_rules = rules_data.active_rules

    # 4. Update Name
    camera_stmt = select(Camera).where(Camera.id == rules_data.camera_id)
    cam = (await db.execute(camera_stmt)).scalars().first()
    if cam:
        if cam.name != rules_data.name:
            changes["name"] = {"old": cam.name, "new": rules_data.name}
        cam.name = rules_data.name

    await db.commit()
    await db.refresh(rule)

    # Log only if something actually changed
    if changes:
        background_tasks.add_task(
            log_activity,
            organization_id=current_user.organization_id,
            user_id=current_user.id,
            action="CAMERA_CONFIGURED",
            details={
                "actor_email": current_user.email,
                "actor_name": current_user.username,
                "camera_id": str(rules_data.camera_id),
                "camera_name": cam.name if cam else None,
                "changes": changes,
            },
        )

    return CameraRuleResponse(
        camera_id=rule.camera_id,
        name=cam.name,
        active_rules=rule.active_rules
    )