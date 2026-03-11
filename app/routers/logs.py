# app/routers/logs.py
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func, desc
from datetime import datetime, date, timedelta
from typing import Optional

from app.db.database import get_db
from app.models.user import User
from app.models.activity_log import ActivityLog
from app.core.dependencies import get_current_active_user
from app.schemas.activity_log import ActivityLogResponse, ActivityLogListResponse

router = APIRouter(prefix="/logs", tags=["Activity Logs"])


@router.get("", response_model=ActivityLogListResponse)
async def get_activity_logs(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db),
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    action: Optional[str] = Query(None, description="Filter by action code"),
    date_from: Optional[date] = Query(None, description="Start date (inclusive)"),
    date_to: Optional[date] = Query(None, description="End date (inclusive)"),
    timezone_offset: int = Query(0, description="Timezone offset in minutes (e.g., 300 for UTC+5)"),
):
    """
    Returns paginated activity logs for the current organization.
    Only accessible by GlobalAdmin.
    """
    if current_user.role != "GlobalAdmin":
        raise HTTPException(status_code=403, detail="Only Global Admins can view activity logs.")

    org_id = current_user.organization_id

    # Base filter
    filters = [ActivityLog.organization_id == org_id]

    if action:
        filters.append(ActivityLog.action == action)

    # Shift UTC timestamps to local before date comparison
    if date_from or date_to:
        local_created = ActivityLog.created_at + timedelta(minutes=timezone_offset)
        if date_from:
            filters.append(func.date(local_created) >= date_from)
        if date_to:
            filters.append(func.date(local_created) <= date_to)

    # Total count
    count_stmt = select(func.count(ActivityLog.id)).where(*filters)
    total_count = (await db.execute(count_stmt)).scalar() or 0

    # Paginated rows
    offset = (page - 1) * page_size
    stmt = (
        select(ActivityLog)
        .where(*filters)
        .order_by(desc(ActivityLog.created_at))
        .offset(offset)
        .limit(page_size)
    )
    results = (await db.execute(stmt)).scalars().all()

    return ActivityLogListResponse(
        logs=[ActivityLogResponse.model_validate(r) for r in results],
        total_count=total_count,
        page=page,
        page_size=page_size,
    )
