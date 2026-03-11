from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List
from uuid import UUID

from app.db.database import get_db
from app.models.camera import Camera, CameraRule
from app.models.user import User
from app.core.dependencies import get_current_active_user
from app.schemas.camera import CameraResponse, CameraUpdate
from app.core.activity_logger import log_activity

router = APIRouter(prefix="/cameras", tags=["Cameras & Rules"])

@router.get("/", response_model=List[CameraResponse])
async def list_cameras(
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """Fetches all CAMERAS for the UI Manage Page."""
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

@router.put("/{camera_id}", response_model=CameraResponse)
async def update_camera(
        camera_id: UUID,
        update_data: CameraUpdate,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db),
        background_tasks: BackgroundTasks = BackgroundTasks(),
):
    """Updates camera details and rules from the UI."""
    stmt = select(Camera).where(
        Camera.id == camera_id,
        Camera.organization_id == current_user.organization_id
    )
    camera = (await db.execute(stmt)).scalars().first()

    if not camera:
        raise HTTPException(status_code=404, detail="Camera not found")

    # Track changes for logging
    changes = {}

    if update_data.name and update_data.name != camera.name:
        changes["name"] = {"old": camera.name, "new": update_data.name}
        camera.name = update_data.name
    elif update_data.name:
        camera.name = update_data.name

    if update_data.location and update_data.location != camera.location:
        changes["location"] = {"old": camera.location, "new": update_data.location}
        camera.location = update_data.location
    elif update_data.location:
        camera.location = update_data.location

    if update_data.rtsp_url and update_data.rtsp_url != camera.rtsp_url:
        changes["rtsp_url"] = {"old": camera.rtsp_url, "new": update_data.rtsp_url}
        camera.rtsp_url = update_data.rtsp_url
    elif update_data.rtsp_url:
        camera.rtsp_url = update_data.rtsp_url

    final_rules = {}
    if update_data.active_rules is not None:
        stmt_rules = select(CameraRule).where(CameraRule.camera_id == camera.id)
        rule_record = (await db.execute(stmt_rules)).scalars().first()

        if rule_record:
            if rule_record.active_rules != update_data.active_rules:
                changes["active_rules"] = {"old": rule_record.active_rules, "new": update_data.active_rules}
            rule_record.active_rules = update_data.active_rules
            final_rules = rule_record.active_rules
        else:
            new_rule = CameraRule(
                camera_id=camera.id,
                active_rules=update_data.active_rules,
                is_active=True
            )
            db.add(new_rule)
            changes["active_rules"] = {"old": None, "new": update_data.active_rules}
            final_rules = update_data.active_rules
    else:
        stmt_rules = select(CameraRule).where(CameraRule.camera_id == camera.id)
        rule_record = (await db.execute(stmt_rules)).scalars().first()
        if rule_record: final_rules = rule_record.active_rules

    await db.commit()
    await db.refresh(camera)

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
                "camera_id": str(camera.id),
                "camera_name": camera.name,
                "changes": changes,
            },
        )

    return CameraResponse(
        id=camera.id,
        name=camera.name,
        location=camera.location,
        rtsp_url=camera.rtsp_url,
        status=camera.status,
        active_rules=final_rules
    )