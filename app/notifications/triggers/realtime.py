"""Real-time per-violation notification trigger.

Called as a BackgroundTask from the violation-create endpoint.
Spawns its own DB session because the request session is closed by then.
"""
from pathlib import Path
from uuid import UUID

from sqlalchemy import select, and_

from app.db.database import AsyncSessionLocal as async_session_maker
from app.models.camera import Camera
from app.models.user import User
from app.models.violation import Violation
from app.models.notification import (
    OrgNotificationPolicy, UserNotificationPref, NotificationLog,
)
from app.notifications import service
from app.notifications.unsubscribe import unsubscribe_url
from app.core.config import settings

SEVERITY_ORDER = {"Low": 1, "Medium": 2, "High": 3, "Critical": 4}


def _meets_floor(severity: str, floor: str) -> bool:
    return SEVERITY_ORDER.get(severity, 0) >= SEVERITY_ORDER.get(floor, 0)


def _humanize_type(t: str) -> str:
    return t.replace("_", " ").title() if t else "Safety violation"


def _build_snapshot_attachment(snapshot_filename: str) -> tuple[list, str | None]:
    """Locate snapshot on disk and return fastapi-mail attachment list + CID."""
    if not snapshot_filename:
        return [], None
    media_root = Path("media")
    candidate = media_root / snapshot_filename
    if not candidate.exists():
        return [], None
    cid = "snap"
    return [{
        "file": str(candidate),
        "headers": {
            "Content-ID": f"<{cid}>",
            "Content-Disposition": f'inline; filename="{snapshot_filename}"',
        },
        "mime_type": "image",
        "mime_subtype": "jpeg",
    }], cid


async def dispatch(violation_id: UUID) -> None:
    """Fan out one violation to all eligible recipients (with throttling)."""
    async with async_session_maker() as db:
        # 1. Load violation + camera
        v_stmt = select(Violation).where(Violation.id == violation_id)
        violation = (await db.execute(v_stmt)).scalars().first()
        if not violation:
            return

        cam_stmt = select(Camera).where(Camera.id == violation.camera_id)
        camera = (await db.execute(cam_stmt)).scalars().first()
        if not camera:
            return

        org_id = violation.organization_id

        # 2. Load org policy
        policy_stmt = select(OrgNotificationPolicy).where(
            OrgNotificationPolicy.organization_id == org_id
        )
        policy = (await db.execute(policy_stmt)).scalars().first()
        if not policy or not policy.realtime_enabled:
            return
        if not _meets_floor(violation.severity, policy.severity_floor):
            return

        eligible_roles = policy.eligible_roles or []
        if not eligible_roles:
            return

        # 3. Find candidate recipients
        recipients_stmt = (
            select(User, UserNotificationPref)
            .outerjoin(UserNotificationPref, UserNotificationPref.user_id == User.id)
            .where(and_(
                User.organization_id == org_id,
                User.is_active.is_(True),
                User.role.in_(eligible_roles),
            ))
        )
        rows = (await db.execute(recipients_stmt)).all()

        # 4. Build snapshot attachment once
        attachments, cid = _build_snapshot_attachment(violation.snapshot_url)

        # 5. Per-recipient: filter, throttle, send
        for user, prefs in rows:
            if not prefs or not prefs.realtime_enabled:
                continue
            if violation.severity not in (prefs.severity_filter or []):
                continue
            if prefs.type_filter and violation.violation_type not in prefs.type_filter:
                continue

            # Throttle check
            recently_sent = await service.has_recent_realtime(
                db, user_id=user.id, camera_id=camera.id,
            )
            if recently_sent:
                await service.log_send(
                    db,
                    user_id=user.id, organization_id=org_id,
                    kind="realtime", status="suppressed",
                    ref_id=violation.id, camera_id=camera.id,
                    severity=violation.severity,
                )
                continue

            suppressed = await service.count_suppressed_since_last_sent(
                db, user_id=user.id, camera_id=camera.id,
            )

            template_body = {
                "subject": f"[{violation.severity}] {_humanize_type(violation.violation_type)} — {camera.name}",
                "header_label": "Violation Alert",
                "severity": violation.severity,
                "violation_type_label": _humanize_type(violation.violation_type),
                "camera_name": camera.name,
                "camera_location": camera.location,
                "timestamp_str": violation.timestamp_utc.strftime("%Y-%m-%d %H:%M UTC"),
                "confidence_pct": "—",  # Violation row doesn't store confidence yet
                "violation_id": str(violation.id),
                "snapshot_cid": cid,
                "suppressed_count": suppressed,
                "app_url": settings.APP_PUBLIC_URL,
                "unsubscribe_url": unsubscribe_url(str(user.id)),
            }
            subject = template_body["subject"]

            ok, err = await service.send_email(
                recipients=[user.email],
                subject=subject,
                template_name="violation_realtime.html",
                template_body=template_body,
                attachments=attachments,
            )
            await service.log_send(
                db,
                user_id=user.id, organization_id=org_id,
                kind="realtime",
                status="sent" if ok else "failed",
                ref_id=violation.id, camera_id=camera.id,
                severity=violation.severity,
                error=err,
            )
