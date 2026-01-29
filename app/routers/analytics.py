from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func, case, desc, and_, extract
from typing import List, Dict, Any
from datetime import datetime, date
import calendar

from app.db.database import get_db
from app.models.user import User
from app.models.violation import Violation
from app.models.camera import Camera
from app.models.device import Organization
from app.core.dependencies import get_current_active_user

router = APIRouter(prefix="/analytics", tags=["Analytics"])

# --- Helper: Get Available Months ---
@router.get("/available-months")
async def get_available_months(
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    stmt = select(Organization.created_at).where(Organization.id == current_user.organization_id)
    result = await db.execute(stmt)
    created_at = result.scalars().first()
    if not created_at: created_at = datetime.utcnow().replace(year=2024, month=1)

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


# --- 1. Dashboard Stats ---
@router.get("/dashboard-stats")
async def get_dashboard_stats(
        month: int = Query(..., ge=1, le=12),
        year: int = Query(..., ge=2020),
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    _, last_day = calendar.monthrange(year, month)
    start_date = datetime(year, month, 1, 0, 0, 0)
    end_date = datetime(year, month, last_day, 23, 59, 59)

    org_filter = (Violation.organization_id == current_user.organization_id)
    date_filter = and_(Violation.timestamp_utc >= start_date, Violation.timestamp_utc <= end_date)

    # KPI Stats
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

    # Trend Query
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

    daily_data = {}
    for d in range(1, last_day + 1):
        dt = datetime(year, month, d)
        day_label = dt.strftime("%d %b")
        daily_data[day_label] = {
            "day": day_label,
            "full_date": dt.strftime("%Y-%m-%d"),
            "total_valid": 0,
            "total_false": 0,
        }

    for row in raw_trend:
        day_label = row.day.strftime("%d %b")
        if day_label in daily_data:
            count = row.count
            v_type = row.violation_type
            sev = row.severity.lower()
            if row.is_false_positive:
                daily_data[day_label]["total_false"] += count
                key = f"false_{sev}"
                daily_data[day_label][key] = daily_data[day_label].get(key, 0) + count
            else:
                daily_data[day_label]["total_valid"] += count
                daily_data[day_label][v_type] = daily_data[day_label].get(v_type, 0) + count

    # Room Stats (UPDATED: Group by LOCATION, not name)
    stmt_room = select(Camera.location, func.count(Violation.id).label("count")) \
        .join(Violation).where(and_(org_filter, date_filter, Violation.is_false_positive == False)) \
        .group_by(Camera.location).order_by(desc("count")).limit(5)

    room_results = (await db.execute(stmt_room)).all()
    # row.location holds the Room Name (e.g., "Surgical Ward")
    chart_by_room = [{"room": row.location or "Unknown", "violations": row.count} for row in room_results]

    return {
        "stats": {
            "total_valid_violations": valid_total,
            "total_false_positives": false_pos,
            "resolution_rate": resolution_rate
        },
        "trend_data": list(daily_data.values()),
        "room_data": chart_by_room
    }


# --- 2. Day Detail Endpoint ---
@router.get("/day-details")
async def get_day_details(
        date_str: str = Query(..., description="YYYY-MM-DD"),
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    try:
        target_date = datetime.strptime(date_str, "%Y-%m-%d").date()
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD")

    org_filter = (Violation.organization_id == current_user.organization_id)
    date_filter = and_(
        Violation.timestamp_utc >= datetime.combine(target_date, datetime.min.time()),
        Violation.timestamp_utc <= datetime.combine(target_date, datetime.max.time())
    )

    # A. Hourly Trend
    stmt_hourly = select(
        extract('hour', Violation.timestamp_utc).label('hour'),
        Violation.violation_type,
        Violation.severity,
        Violation.is_false_positive,
        func.count(Violation.id).label('count')
    ).where(and_(org_filter, date_filter)).group_by('hour', Violation.violation_type, Violation.severity,
                                                    Violation.is_false_positive)

    raw_hourly = (await db.execute(stmt_hourly)).all()

    hourly_data = []
    for h in range(24):
        time_label = datetime.strptime(str(h), "%H").strftime("%I%p").lstrip("0")
        hourly_data.append({
            "hour": time_label,
            "raw_hour": h,
            "total_violations": 0,
            "total_false": 0
        })

    for row in raw_hourly:
        h_idx = int(row.hour)
        count = row.count
        v_type = row.violation_type
        sev = row.severity.lower()

        if row.is_false_positive:
            hourly_data[h_idx]["total_false"] += count
            key = f"false_{sev}"
            hourly_data[h_idx][key] = hourly_data[h_idx].get(key, 0) + count
        else:
            hourly_data[h_idx]["total_violations"] += count
            hourly_data[h_idx][v_type] = hourly_data[h_idx].get(v_type, 0) + count

    # B. Detailed List of Violations (Fetches BOTH Name and Location)
    stmt_list = select(
        Violation,
        Camera.name.label("camera_name"),
        Camera.location.label("room_name")
    ).join(Camera, Violation.camera_id == Camera.id).where(and_(org_filter, date_filter)).order_by(
        desc(Violation.timestamp_utc))

    raw_list = (await db.execute(stmt_list)).all()

    violations_list = []
    stats = {"critical": 0, "high": 0, "total": 0}

    for v, cam_name, room_name in raw_list:
        stats["total"] += 1
        if v.severity == "Critical": stats["critical"] += 1
        if v.severity == "High": stats["high"] += 1

        violations_list.append({
            "id": str(v.id),
            "type": v.violation_type,
            "severity": v.severity.lower(),
            "timestamp": v.timestamp_utc.strftime("%I:%M %p"),
            "cameraName": cam_name or "Unknown Camera", # Specific Camera
            "roomName": room_name or "Unknown Location", # Room Location
            "imageUrl": v.snapshot_url or "https://via.placeholder.com/150",
            "description": f"{v.violation_type} detected in {room_name or 'Unknown Location'}",
            "is_false_positive": v.is_false_positive
        })

    # C. Daily Room Stats (UPDATED: Group by LOCATION)
    stmt_room = select(Camera.location, func.count(Violation.id).label("count")) \
        .join(Violation).where(and_(org_filter, date_filter, Violation.is_false_positive == False)) \
        .group_by(Camera.location).order_by(desc("count")).limit(5)

    room_results = (await db.execute(stmt_room)).all()
    day_room_data = [{"room": row.location or "Unknown", "violations": row.count} for row in room_results]

    return {
        "date": date_str,
        "stats": stats,
        "hourly_data": hourly_data,
        "violations": violations_list,
        "room_data": day_room_data
    }