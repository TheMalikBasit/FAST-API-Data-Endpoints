"""All notification-system HTTP endpoints.

  GET   /notifications/policy                 (any authed user — read-only)
  PATCH /notifications/policy                 (GlobalAdmin)
  GET   /users/me/notifications/prefs
  PATCH /users/me/notifications/prefs
  POST  /notifications/test-email             (GlobalAdmin)
  GET   /notifications/log                    (GlobalAdmin, paginated)
  GET   /notifications/unsubscribe?token=     (no auth)
"""
from datetime import datetime, timezone
from typing import Optional
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query, status
from fastapi.responses import HTMLResponse
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.database import get_db
from app.models.user import User
from app.models.device import Organization
from app.models.notification import (
    OrgNotificationPolicy, UserNotificationPref, NotificationLog,
)
from app.core.dependencies import get_current_active_user
from app.core.config import settings
from app.notifications.schemas import (
    OrgPolicyResponse, OrgPolicyUpdate,
    UserPrefResponse, UserPrefUpdate,
    NotificationLogRow, NotificationLogPage,
)
from app.notifications import service
from app.notifications.unsubscribe import verify_token, make_token, unsubscribe_url

router = APIRouter(prefix="/notifications", tags=["Notifications"])
user_router = APIRouter(prefix="/users/me/notifications", tags=["Notifications"])


# ----------------------------------------------------------------------------
# Org policy
# ----------------------------------------------------------------------------
async def _get_or_create_policy(db: AsyncSession, org_id: UUID) -> OrgNotificationPolicy:
    stmt = select(OrgNotificationPolicy).where(
        OrgNotificationPolicy.organization_id == org_id
    )
    policy = (await db.execute(stmt)).scalars().first()
    if policy:
        return policy
    policy = OrgNotificationPolicy(
        organization_id=org_id,
        eligible_roles=["GlobalAdmin"],
        severity_floor="Medium",
        realtime_enabled=True,
        digest_enabled=True,
        analytics_enabled=True,
    )
    db.add(policy)
    await db.commit()
    await db.refresh(policy)
    return policy


@router.get("/policy", response_model=OrgPolicyResponse)
async def get_policy(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db),
):
    policy = await _get_or_create_policy(db, current_user.organization_id)
    return policy


@router.patch("/policy", response_model=OrgPolicyResponse)
async def update_policy(
    payload: OrgPolicyUpdate,
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db),
):
    if current_user.role != "GlobalAdmin":
        raise HTTPException(status_code=403, detail="GlobalAdmin role required.")
    policy = await _get_or_create_policy(db, current_user.organization_id)
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(policy, field, value)
    policy.updated_by = current_user.id
    await db.commit()
    await db.refresh(policy)
    return policy


# ----------------------------------------------------------------------------
# User prefs
# ----------------------------------------------------------------------------
async def _get_or_create_prefs(db: AsyncSession, user_id: UUID) -> UserNotificationPref:
    stmt = select(UserNotificationPref).where(UserNotificationPref.user_id == user_id)
    prefs = (await db.execute(stmt)).scalars().first()
    if prefs:
        if not prefs.unsubscribe_token:
            prefs.unsubscribe_token = make_token(str(user_id))
            await db.commit()
            await db.refresh(prefs)
        return prefs
    prefs = UserNotificationPref(
        user_id=user_id,
        realtime_enabled=False,        # opt-out by default
        severity_filter=["Critical", "High"],
        type_filter=None,
        digest_cadence="daily",        # opt-in by default
        digest_hour=9,
        analytics_cadence="weekly",
        timezone="UTC",
        unsubscribe_token=make_token(str(user_id)),
    )
    db.add(prefs)
    await db.commit()
    await db.refresh(prefs)
    return prefs


async def _require_notification_eligible(db: AsyncSession, user: User) -> None:
    """403 if the org policy doesn't list this user's role as eligible."""
    policy = await _get_or_create_policy(db, user.organization_id)
    if user.role not in (policy.eligible_roles or []):
        raise HTTPException(
            status_code=403,
            detail="Your role is not eligible to receive notifications. Contact your GlobalAdmin.",
        )


@user_router.get("/prefs", response_model=UserPrefResponse)
async def get_my_prefs(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db),
):
    await _require_notification_eligible(db, current_user)
    return await _get_or_create_prefs(db, current_user.id)


@user_router.patch("/prefs", response_model=UserPrefResponse)
async def update_my_prefs(
    payload: UserPrefUpdate,
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db),
):
    await _require_notification_eligible(db, current_user)
    prefs = await _get_or_create_prefs(db, current_user.id)
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(prefs, field, value)
    await db.commit()
    await db.refresh(prefs)
    return prefs


# ----------------------------------------------------------------------------
# Test email
# ----------------------------------------------------------------------------
@router.post("/test-email")
async def send_test_email(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db),
):
    if current_user.role != "GlobalAdmin":
        raise HTTPException(status_code=403, detail="GlobalAdmin role required.")

    org_stmt = select(Organization).where(Organization.id == current_user.organization_id)
    org = (await db.execute(org_stmt)).scalars().first()

    template_body = {
        "subject": "WSMS — SMTP Test",
        "header_label": "Test",
        "recipient_name": current_user.username or "there",
        "org_name": (org.name if org else "your organization"),
        "sent_at_str": datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC"),
        "from_label": f"{settings.MAIL_FROM_NAME} <{settings.MAIL_FROM or settings.MAIL_USERNAME}>",
        "app_url": settings.APP_PUBLIC_URL,
        "unsubscribe_url": None,
    }
    ok, err = await service.send_email(
        recipients=[current_user.email],
        subject="WSMS — SMTP test",
        template_name="test_email.html",
        template_body=template_body,
    )
    await service.log_send(
        db,
        user_id=current_user.id,
        organization_id=current_user.organization_id,
        kind="test",
        status="sent" if ok else "failed",
        error=err,
    )
    if not ok:
        raise HTTPException(status_code=500, detail=f"Send failed: {err}")
    return {"success": True, "sent_to": current_user.email}


# ----------------------------------------------------------------------------
# Audit log
# ----------------------------------------------------------------------------
@router.get("/log", response_model=NotificationLogPage)
async def list_log(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    kind: Optional[str] = None,
    status_filter: Optional[str] = Query(None, alias="status"),
):
    if current_user.role != "GlobalAdmin":
        raise HTTPException(status_code=403, detail="GlobalAdmin role required.")

    base = select(NotificationLog).where(
        NotificationLog.organization_id == current_user.organization_id
    )
    if kind:
        base = base.where(NotificationLog.kind == kind)
    if status_filter:
        base = base.where(NotificationLog.status == status_filter)

    total = (await db.execute(
        select(func.count()).select_from(base.subquery())
    )).scalar() or 0

    rows_stmt = base.order_by(NotificationLog.sent_at.desc()).limit(limit).offset(offset)
    rows = (await db.execute(rows_stmt)).scalars().all()
    return NotificationLogPage(rows=rows, total=total)


# ----------------------------------------------------------------------------
# Unsubscribe (public)
# ----------------------------------------------------------------------------
_UNSUB_PAGE = """<!doctype html><html><head><meta charset="utf-8"><title>Unsubscribed</title>
<style>body{{font-family:-apple-system,sans-serif;background:#0f0a1f;color:#e8e6f0;display:flex;align-items:center;justify-content:center;height:100vh;margin:0}}
.card{{background:#1a1233;padding:40px;border-radius:16px;max-width:420px;text-align:center;border:1px solid rgba(139,92,246,0.3)}}
h1{{color:#fff;margin:0 0 12px}}p{{color:#A78BFA;line-height:1.6}}a{{color:#10B981}}</style></head>
<body><div class="card"><h1>{title}</h1><p>{message}</p>
<p style="margin-top:24px;font-size:13px;"><a href="{app}/dashboard/profile-settings/notifications">Manage notification preferences</a></p>
</div></body></html>"""


@router.get("/unsubscribe", response_class=HTMLResponse)
async def unsubscribe(token: str, db: AsyncSession = Depends(get_db)):
    user_id = verify_token(token)
    if not user_id:
        return HTMLResponse(_UNSUB_PAGE.format(
            title="Invalid link",
            message="This unsubscribe link is invalid or has expired.",
            app=settings.APP_PUBLIC_URL,
        ), status_code=400)

    prefs_stmt = select(UserNotificationPref).where(UserNotificationPref.user_id == user_id)
    prefs = (await db.execute(prefs_stmt)).scalars().first()
    if prefs:
        prefs.realtime_enabled = False
        prefs.digest_cadence = "none"
        prefs.analytics_cadence = "none"
        await db.commit()

    return HTMLResponse(_UNSUB_PAGE.format(
        title="You're unsubscribed",
        message="You won't receive any further WSMS notifications by email. You can re-enable them anytime from your profile settings.",
        app=settings.APP_PUBLIC_URL,
    ))
