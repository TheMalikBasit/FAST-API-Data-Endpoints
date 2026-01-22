from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func, case, desc
from typing import List, Dict, Any
from datetime import datetime, timedelta
from app.db.database import get_db
from app.models.user import User
from app.models.violation import Violation
from app.models.camera import Camera
from app.core.dependencies import get_current_active_user

router = APIRouter(prefix="/analytics", tags=["Analytics"])

@router.get("/dashboard-stats")
async def get_dashboard_stats(
        time_range: str = "7days",  # Options: 7days, 30days
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """
    Returns aggregated data for the Admin Dashboard.
    Calculates trends, counts by type, and room stats efficiently in SQL.
    """

    # 1. Determine Date Range
    now = datetime.utcnow()
    if time_range == "30days":
        start_date = now - timedelta(days=30)
    else:
        start_date = now - timedelta(days=7)

    # 2. Base Query (Filtered by Org & Date)
    # We filter out False Positives for accuracy
    base_filter = [
        Violation.organization_id == current_user.organization_id,
        Violation.timestamp_utc >= start_date,
        Violation.is_false_positive == False
    ]

    # --- METRIC A: Total Violations & Resolution Rate ---
    # We count total violations and how many are 'resolved'
    stmt_stats = select(
        func.count(Violation.id).label("total"),
        func.count(case((Violation.is_resolved == True, 1))).label("resolved")
    ).where(*base_filter)

    result_stats = (await db.execute(stmt_stats)).first()
    total = result_stats.total or 0
    resolved = result_stats.resolved or 0
    resolution_rate = round((resolved / total * 100), 1) if total > 0 else 0

    # --- METRIC B: Violations Over Time (For Line Chart) ---
    # Group by Date (PostgreSQL 'date_trunc')
    stmt_trend = select(
        func.date_trunc('day', Violation.timestamp_utc).label("day"),
        func.count(Violation.id)
    ).where(*base_filter).group_by("day").order_by("day")

    trend_results = (await db.execute(stmt_trend)).all()

    # Format for Recharts (Frontend)
    chart_data = [
        {"day": row.day.strftime("%a" if time_range == "7days" else "%b %d"), "violations": row.count}
        for row in trend_results
    ]

    # --- METRIC C: Violations By Type (For Pie/Bar Chart) ---
    stmt_type = select(
        Violation.violation_type,
        func.count(Violation.id)
    ).where(*base_filter).group_by(Violation.violation_type)

    type_results = (await db.execute(stmt_type)).all()
    type_data = [{"name": row.violation_type, "value": row.count} for row in type_results]

    # --- METRIC D: Top Rooms/Cameras (For "Frequent Violations" Chart) ---
    stmt_room = select(
        Camera.name,
        func.count(Violation.id).label("count")
    ).join(Violation).where(*base_filter).group_by(Camera.name).order_by(desc("count")).limit(5)

    room_results = (await db.execute(stmt_room)).all()
    room_data = [{"room": row.name, "violations": row.count} for row in room_results]

    return {
        "stats": {
            "total_violations": total,
            "resolution_rate": resolution_rate,
            "time_range": time_range
        },
        "charts": {
            "over_time": chart_data,
            "by_type": type_data,
            "by_room": room_data
        }
    }