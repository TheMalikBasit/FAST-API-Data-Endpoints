# app/core/activity_logger.py
"""
Background-safe activity logger.
Creates its own short-lived AsyncSession so it works correctly
inside FastAPI BackgroundTasks (after the request session is closed).
"""
from uuid import UUID
from typing import Optional
from app.db.database import AsyncSessionLocal
from app.models.activity_log import ActivityLog


async def log_activity(
    organization_id: UUID,
    user_id: Optional[UUID],
    action: str,
    details: Optional[dict] = None,
):
    """
    Insert one activity log row using a fresh session.
    Silently catches all exceptions — logging must never break the user's request.
    """
    try:
        async with AsyncSessionLocal() as session:
            entry = ActivityLog(
                organization_id=organization_id,
                user_id=user_id,
                action=action,
                details=details,
            )
            session.add(entry)
            await session.commit()
    except Exception as e:
        # Never propagate — the user action already succeeded
        print(f"[ActivityLogger] Failed to write log: {e}")
