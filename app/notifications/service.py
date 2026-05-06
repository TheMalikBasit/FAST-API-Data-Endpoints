"""Core notification primitives — send, throttle, log.

Throttle rule: at most one realtime email per (user, camera) per WINDOW_MIN.
While suppressed, we still write a `suppressed` row so the next sent email
can include the count of recent fires.
"""
from datetime import datetime, timedelta, timezone
from typing import Sequence
from uuid import UUID

from fastapi_mail import MessageSchema, MessageType
from sqlalchemy import select, func, and_
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.notification import NotificationLog
from app.notifications.config import fast_mail

WINDOW_MIN = 10  # collapse window for realtime alerts


async def send_email(
    *,
    recipients: Sequence[str],
    subject: str,
    template_name: str,
    template_body: dict,
    attachments: list | None = None,
) -> tuple[bool, str | None]:
    """Send a Jinja-templated email. Returns (ok, error_message)."""
    try:
        msg = MessageSchema(
            subject=subject,
            recipients=list(recipients),
            template_body=template_body,
            subtype=MessageType.html,
            attachments=attachments or [],
        )
        await fast_mail.send_message(msg, template_name=template_name)
        return True, None
    except Exception as e:
        return False, str(e)


async def count_suppressed_since_last_sent(
    db: AsyncSession, *, user_id: UUID, camera_id: UUID,
) -> int:
    """How many realtime alerts were suppressed for this (user, camera) since the
    last successfully sent realtime email — caps at the WINDOW_MIN window."""
    window_start = datetime.now(timezone.utc) - timedelta(minutes=WINDOW_MIN)

    # find timestamp of last sent realtime in window (if any)
    last_sent_stmt = select(func.max(NotificationLog.sent_at)).where(
        and_(
            NotificationLog.user_id == user_id,
            NotificationLog.camera_id == camera_id,
            NotificationLog.kind == "realtime",
            NotificationLog.status == "sent",
            NotificationLog.sent_at >= window_start,
        )
    )
    last_sent = (await db.execute(last_sent_stmt)).scalar()
    threshold = last_sent or window_start

    count_stmt = select(func.count()).select_from(NotificationLog).where(
        and_(
            NotificationLog.user_id == user_id,
            NotificationLog.camera_id == camera_id,
            NotificationLog.kind == "realtime",
            NotificationLog.status == "suppressed",
            NotificationLog.sent_at > threshold,
        )
    )
    return (await db.execute(count_stmt)).scalar() or 0


async def has_recent_realtime(
    db: AsyncSession, *, user_id: UUID, camera_id: UUID,
) -> bool:
    """Any successfully sent realtime alert for (user, camera) within WINDOW_MIN?"""
    window_start = datetime.now(timezone.utc) - timedelta(minutes=WINDOW_MIN)
    stmt = select(func.count()).select_from(NotificationLog).where(
        and_(
            NotificationLog.user_id == user_id,
            NotificationLog.camera_id == camera_id,
            NotificationLog.kind == "realtime",
            NotificationLog.status == "sent",
            NotificationLog.sent_at >= window_start,
        )
    )
    return ((await db.execute(stmt)).scalar() or 0) > 0


async def log_send(
    db: AsyncSession,
    *,
    user_id: UUID,
    organization_id: UUID,
    kind: str,
    status: str,
    ref_id: UUID | None = None,
    camera_id: UUID | None = None,
    severity: str | None = None,
    error: str | None = None,
    channel: str = "email",
) -> NotificationLog:
    row = NotificationLog(
        user_id=user_id,
        organization_id=organization_id,
        channel=channel,
        kind=kind,
        ref_id=ref_id,
        camera_id=camera_id,
        severity=severity,
        status=status,
        sent_at=datetime.now(timezone.utc),
        error=error,
    )
    db.add(row)
    await db.commit()
    await db.refresh(row)
    return row
