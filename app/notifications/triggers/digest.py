"""Daily digest builder.

Job runs hourly. For each user with digest_cadence='daily', if the user's local
time matches their digest_hour, send a digest covering the previous 24h.
"""
from datetime import datetime, timedelta, timezone
from uuid import UUID

from sqlalchemy import select, func, and_
from zoneinfo import ZoneInfo

from app.db.database import AsyncSessionLocal as async_session_maker
from app.models.camera import Camera
from app.models.user import User
from app.models.device import Organization
from app.models.violation import Violation
from app.models.notification import (
    OrgNotificationPolicy, UserNotificationPref,
)
from app.notifications import service
from app.notifications.unsubscribe import unsubscribe_url
from app.core.config import settings


def _local_hour(tz_name: str) -> int:
    try:
        return datetime.now(ZoneInfo(tz_name)).hour
    except Exception:
        return datetime.now(timezone.utc).hour


async def run_hourly_digest_tick() -> None:
    """Called every hour by the scheduler. Sends digests due in this hour."""
    async with async_session_maker() as db:
        # All users opted into daily digests
        candidates_stmt = (
            select(User, UserNotificationPref, OrgNotificationPolicy, Organization)
            .join(UserNotificationPref, UserNotificationPref.user_id == User.id)
            .join(OrgNotificationPolicy, OrgNotificationPolicy.organization_id == User.organization_id)
            .join(Organization, Organization.id == User.organization_id)
            .where(and_(
                User.is_active.is_(True),
                UserNotificationPref.digest_cadence == "daily",
                OrgNotificationPolicy.digest_enabled.is_(True),
            ))
        )
        rows = (await db.execute(candidates_stmt)).all()

        now_utc = datetime.now(timezone.utc)
        period_start = now_utc - timedelta(hours=24)

        for user, prefs, policy, org in rows:
            if user.role not in (policy.eligible_roles or []):
                continue
            if _local_hour(prefs.timezone) != prefs.digest_hour:
                continue

            await _send_digest_for_user(
                db, user=user, org=org, period_start=period_start, period_end=now_utc,
            )


async def _send_digest_for_user(db, *, user, org, period_start, period_end) -> None:
    # Aggregate violations for this org in window
    base = select(Violation).where(and_(
        Violation.organization_id == org.id,
        Violation.timestamp_utc >= period_start,
        Violation.timestamp_utc < period_end,
    ))

    total = (await db.execute(
        select(func.count()).select_from(base.subquery())
    )).scalar() or 0

    critical = (await db.execute(
        select(func.count()).select_from(
            base.where(Violation.severity == "Critical").subquery()
        )
    )).scalar() or 0

    resolved = (await db.execute(
        select(func.count()).select_from(
            base.where(Violation.is_resolved.is_(True)).subquery()
        )
    )).scalar() or 0

    resolved_pct = round((resolved / total) * 100) if total else 0

    # By camera
    cam_stmt = (
        select(Camera.name, Camera.location, func.count(Violation.id).label("cnt"))
        .join(Violation, Violation.camera_id == Camera.id)
        .where(and_(
            Violation.organization_id == org.id,
            Violation.timestamp_utc >= period_start,
            Violation.timestamp_utc < period_end,
        ))
        .group_by(Camera.id, Camera.name, Camera.location)
        .order_by(func.count(Violation.id).desc())
        .limit(10)
    )
    by_camera = [
        {"name": name, "location": location, "count": cnt}
        for (name, location, cnt) in (await db.execute(cam_stmt)).all()
    ]

    template_body = {
        "subject": f"WSMS daily digest — {org.name}",
        "header_label": "Daily Digest",
        "org_name": org.name,
        "period_label": f"Last 24 hours · {period_end.strftime('%b %d')}",
        "totals": {
            "total": total,
            "critical": critical,
            "resolved_pct": resolved_pct,
        },
        "by_camera": by_camera,
        "app_url": settings.APP_PUBLIC_URL,
        "unsubscribe_url": unsubscribe_url(str(user.id)),
    }
    ok, err = await service.send_email(
        recipients=[user.email],
        subject=template_body["subject"],
        template_name="digest_daily.html",
        template_body=template_body,
    )
    await service.log_send(
        db,
        user_id=user.id, organization_id=org.id,
        kind="digest",
        status="sent" if ok else "failed",
        error=err,
    )
