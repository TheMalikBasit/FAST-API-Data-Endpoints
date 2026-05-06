"""Analytics report builder — daily / weekly / monthly cadence."""
from datetime import datetime, timedelta, timezone

from sqlalchemy import select, func, and_
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.database import AsyncSessionLocal as async_session_maker
from app.models.camera import Camera
from app.models.user import User
from app.models.device import Organization
from app.models.violation import Violation
from app.models.notification import OrgNotificationPolicy, UserNotificationPref
from app.notifications import service
from app.notifications.unsubscribe import unsubscribe_url
from app.core.config import settings

PERIOD_HOURS = {"daily": 24, "weekly": 24 * 7, "monthly": 24 * 30}
PERIOD_LABEL = {"daily": "Daily", "weekly": "Weekly", "monthly": "Monthly"}

SEV_PALETTE = {
    "Critical": "#EF4444",
    "High": "#F97316",
    "Medium": "#F59E0B",
    "Low": "#10B981",
}


async def run_analytics_tick(period: str) -> None:
    """Called by scheduler. period in {daily, weekly, monthly}."""
    if period not in PERIOD_HOURS:
        return

    async with async_session_maker() as db:
        candidates_stmt = (
            select(User, UserNotificationPref, OrgNotificationPolicy, Organization)
            .join(UserNotificationPref, UserNotificationPref.user_id == User.id)
            .join(OrgNotificationPolicy, OrgNotificationPolicy.organization_id == User.organization_id)
            .join(Organization, Organization.id == User.organization_id)
            .where(and_(
                User.is_active.is_(True),
                UserNotificationPref.analytics_cadence == period,
                OrgNotificationPolicy.analytics_enabled.is_(True),
            ))
        )
        rows = (await db.execute(candidates_stmt)).all()

        now_utc = datetime.now(timezone.utc)
        hours = PERIOD_HOURS[period]
        period_start = now_utc - timedelta(hours=hours)
        prior_start = period_start - timedelta(hours=hours)

        # Aggregate per-org once (multiple users in same org share the same data)
        org_cache: dict = {}

        for user, prefs, policy, org in rows:
            if user.role not in (policy.eligible_roles or []):
                continue
            if org.id not in org_cache:
                org_cache[org.id] = await _build_payload(
                    db, org=org, period=period,
                    period_start=period_start, period_end=now_utc,
                    prior_start=prior_start, prior_end=period_start,
                )
            payload = dict(org_cache[org.id])
            payload["unsubscribe_url"] = unsubscribe_url(str(user.id))

            ok, err = await service.send_email(
                recipients=[user.email],
                subject=payload["subject"],
                template_name="analytics.html",
                template_body=payload,
            )
            await service.log_send(
                db,
                user_id=user.id, organization_id=org.id,
                kind="analytics",
                status="sent" if ok else "failed",
                error=err,
            )


async def _build_payload(
    db: AsyncSession,
    *,
    org,
    period: str,
    period_start, period_end,
    prior_start, prior_end,
) -> dict:
    # ---- Headline: total, resolved, FP, MTTR ----
    def _scope(start, end):
        return and_(
            Violation.organization_id == org.id,
            Violation.timestamp_utc >= start,
            Violation.timestamp_utc < end,
        )

    total = (await db.execute(
        select(func.count()).select_from(
            select(Violation).where(_scope(period_start, period_end)).subquery()
        )
    )).scalar() or 0

    prior_total = (await db.execute(
        select(func.count()).select_from(
            select(Violation).where(_scope(prior_start, prior_end)).subquery()
        )
    )).scalar() or 0

    resolved = (await db.execute(
        select(func.count()).select_from(
            select(Violation).where(and_(
                _scope(period_start, period_end),
                Violation.is_resolved.is_(True),
            )).subquery()
        )
    )).scalar() or 0

    fp = (await db.execute(
        select(func.count()).select_from(
            select(Violation).where(and_(
                _scope(period_start, period_end),
                Violation.is_false_positive.is_(True),
            )).subquery()
        )
    )).scalar() or 0

    resolved_pct = round((resolved / total) * 100) if total else 0
    precision_pct = round(((total - fp) / total) * 100) if total else 100

    total_delta = None
    if prior_total > 0:
        total_delta = round(((total - prior_total) / prior_total) * 100)
    elif total > 0:
        total_delta = 100

    # ---- Severity breakdown ----
    sev_stmt = (
        select(Violation.severity, func.count(Violation.id))
        .where(_scope(period_start, period_end))
        .group_by(Violation.severity)
    )
    sev_counts = {row[0] or "Medium": row[1] for row in (await db.execute(sev_stmt)).all()}
    severity_breakdown = []
    for label in ("Critical", "High", "Medium", "Low"):
        count = sev_counts.get(label, 0)
        pct = round((count / total) * 100) if total else 0
        severity_breakdown.append({
            "label": label, "count": count, "pct": pct, "color": SEV_PALETTE[label],
        })

    # ---- Top 5 cameras ----
    cam_stmt = (
        select(Camera.name, func.count(Violation.id).label("cnt"))
        .join(Violation, Violation.camera_id == Camera.id)
        .where(_scope(period_start, period_end))
        .group_by(Camera.id, Camera.name)
        .order_by(func.count(Violation.id).desc())
        .limit(5)
    )
    top_cameras = [
        {"name": name, "count": cnt}
        for name, cnt in (await db.execute(cam_stmt)).all()
    ]

    # ---- Top 5 locations ----
    loc_stmt = (
        select(Camera.location, func.count(Violation.id).label("cnt"))
        .join(Violation, Violation.camera_id == Camera.id)
        .where(and_(_scope(period_start, period_end), Camera.location.isnot(None)))
        .group_by(Camera.location)
        .order_by(func.count(Violation.id).desc())
        .limit(5)
    )
    top_locations = [
        {"name": name, "count": cnt}
        for name, cnt in (await db.execute(loc_stmt)).all()
    ]

    # ---- Top 5 violation types ----
    type_stmt = (
        select(Violation.violation_type, func.count(Violation.id).label("cnt"))
        .where(_scope(period_start, period_end))
        .group_by(Violation.violation_type)
        .order_by(func.count(Violation.id).desc())
        .limit(5)
    )
    top_types = [
        {"name": (vt or "unknown").replace("_", " ").title(), "count": cnt}
        for vt, cnt in (await db.execute(type_stmt)).all()
    ]

    # ---- MTTR (mean time to resolve) ----
    # We don't store resolved_at; approximate using updated_at for resolved rows
    mttr_stmt = (
        select(func.avg(
            func.extract("epoch", Violation.updated_at - Violation.timestamp_utc)
        ))
        .where(and_(
            _scope(period_start, period_end),
            Violation.is_resolved.is_(True),
        ))
    )
    mttr_seconds = (await db.execute(mttr_stmt)).scalar() or 0
    mttr_str = _humanize_seconds(mttr_seconds) if mttr_seconds else "—"

    # ---- Funnel ----
    open_count = total - resolved - fp
    funnel = {"open": max(open_count, 0), "resolved": resolved, "false_positive": fp}

    return {
        "subject": f"WSMS {PERIOD_LABEL[period].lower()} analytics — {org.name}",
        "header_label": f"{PERIOD_LABEL[period]} Analytics",
        "org_name": org.name,
        "period_label": PERIOD_LABEL[period],
        "date_range": f"{period_start.strftime('%b %d')} – {period_end.strftime('%b %d, %Y')}",
        "headline": {
            "total": total,
            "total_delta": total_delta,
            "resolved_pct": resolved_pct,
            "mttr_str": mttr_str,
            "precision_pct": precision_pct,
        },
        "severity_breakdown": severity_breakdown,
        "top_cameras": top_cameras,
        "top_locations": top_locations,
        "top_types": top_types,
        "funnel": funnel,
        "app_url": settings.APP_PUBLIC_URL,
    }


def _humanize_seconds(s: float) -> str:
    s = int(s)
    if s < 60:
        return f"{s}s"
    if s < 3600:
        return f"{s // 60}m"
    if s < 86400:
        return f"{s // 3600}h {((s % 3600) // 60)}m"
    return f"{s // 86400}d {((s % 86400) // 3600)}h"
