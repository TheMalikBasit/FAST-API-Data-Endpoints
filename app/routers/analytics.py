from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func, case, desc, and_
from typing import List, Dict, Any
from datetime import datetime, timedelta
import calendar

from app.db.database import get_db
from app.models.user import User
from app.models.violation import Violation
from app.models.camera import Camera
from app.models.device import Organization
from app.core.dependencies import get_current_active_user

router = APIRouter(prefix="/analytics", tags=["Analytics"])


@router.get("/available-months")
async def get_available_months(
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """Returns list of months for the dropdown."""
    stmt = select(Organization.created_at).where(Organization.id == current_user.organization_id)
    result = await db.execute(stmt)
    created_at = result.scalars().first()

    if not created_at:
        created_at = datetime.utcnow().replace(year=2024, month=1)

    # Strip timezone to avoid comparison errors
    start_date = created_at.replace(day=1, hour=0, minute=0, second=0, microsecond=0, tzinfo=None)
    now = datetime.utcnow()

    months = []
    cursor = start_date
    while cursor <= now:
        months.append({
            "label": cursor.strftime("%B %Y"),
            "month": cursor.month,
            "year": cursor.year
        })
        if cursor.month == 12:
            cursor = cursor.replace(year=cursor.year + 1, month=1)
        else:
            cursor = cursor.replace(month=cursor.month + 1)

    return months[::-1]


@router.get("/dashboard-stats")
async def get_dashboard_stats(
        month: int = Query(..., ge=1, le=12),
        year: int = Query(..., ge=2020),
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    # 1. Date Range
    _, last_day = calendar.monthrange(year, month)
    start_date = datetime(year, month, 1, 0, 0, 0)
    end_date = datetime(year, month, last_day, 23, 59, 59)

    # 2. Base Filter
    org_filter = (Violation.organization_id == current_user.organization_id)
    date_filter = and_(Violation.timestamp_utc >= start_date, Violation.timestamp_utc <= end_date)

    # 3. KPI Stats
    stmt_stats = select(
        func.count(Violation.id).label("total"),
        func.count(case((Violation.is_resolved == True, 1))).label("resolved"),
        func.count(case((Violation.is_false_positive == True, 1))).label("false_positives")
    ).where(and_(org_filter, date_filter))

    result_stats = (await db.execute(stmt_stats)).first()
    total = result_stats.total or 0
    false_pos = result_stats.false_positives or 0
    valid_total = total - false_pos
    resolution_rate = round(((result_stats.resolved or 0) / total * 100), 1) if total > 0 else 0

    # 4. MASTER TREND QUERY (The Magic)
    # We fetch ALL violations for the month and group by Day + Type + Severity + FalsePositive
    # This allows us to build ANY graph on the frontend.
    stmt_trend = select(
        func.date_trunc('day', Violation.timestamp_utc).label("day"),
        Violation.violation_type,
        Violation.severity,
        Violation.is_false_positive,
        func.count(Violation.id).label("count")
    ).where(and_(org_filter, date_filter)).group_by(
        "day", Violation.violation_type, Violation.severity, Violation.is_false_positive
    ).order_by("day")

    raw_trend = (await db.execute(stmt_trend)).all()

    # 5. Process into "Daily Buckets"
    # We create a dictionary for each day of the month:
    # { "01 Jan": { "total": 10, "no_helmet": 5, "critical_false": 1, ... } }
    daily_data = {}

    # Initialize all days in month with 0
    for d in range(1, last_day + 1):
        day_label = datetime(year, month, d).strftime("%d %b")  # "01 Jan"
        daily_data[day_label] = {
            "day": day_label,
            "total_valid": 0,
            "total_false": 0,
            # We will auto-populate types below
        }

    for row in raw_trend:
        day_label = row.day.strftime("%d %b")
        count = row.count
        v_type = row.violation_type  # e.g. "no_helmet"
        sev = row.severity.lower()  # e.g. "critical"
        is_false = row.is_false_positive

        if is_false:
            daily_data[day_label]["total_false"] += count
            # Track false positives by severity for that graph
            # key: "false_critical", "false_high"
            key = f"false_{sev}"
            daily_data[day_label][key] = daily_data[day_label].get(key, 0) + count
        else:
            daily_data[day_label]["total_valid"] += count
            # Track valid violations by type for that graph
            # key: "no_helmet", "no_vest"
            daily_data[day_label][v_type] = daily_data[day_label].get(v_type, 0) + count

    # Convert dict to sorted list for Recharts
    chart_trend_data = list(daily_data.values())

    # 6. Room Stats (Bar Chart)
    stmt_room = select(
        Camera.name,
        func.count(Violation.id).label("count")
    ).join(Violation).where(and_(org_filter, date_filter, Violation.is_false_positive == False)).group_by(
        Camera.name).order_by(desc("count")).limit(5)

    room_results = (await db.execute(stmt_room)).all()
    chart_by_room = [{"room": row.name, "violations": row.count} for row in room_results]

    return {
        "stats": {
            "total_valid_violations": valid_total,
            "total_false_positives": false_pos,
            "resolution_rate": resolution_rate
        },
        "trend_data": chart_trend_data,  # One dataset for 3 graphs
        "room_data": chart_by_room
    }