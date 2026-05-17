from sqlalchemy import (
    Column, String, ForeignKey, Boolean, Integer, DateTime, Index,
)
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from .base import BaseModel


class OrgNotificationPolicy(BaseModel):
    """One row per organization. Set by GlobalAdmin in Settings."""
    __tablename__ = "org_notification_policy"

    organization_id = Column(
        UUID(as_uuid=True),
        ForeignKey("organizations.id", ondelete="CASCADE"),
        nullable=False, unique=True, index=True,
    )
    # roles whose users may receive notifications, e.g. ["GlobalAdmin", "Supervisor"]
    eligible_roles = Column(JSONB, nullable=False, default=list)
    # severity floor — anything below is silently dropped
    severity_floor = Column(String(20), nullable=False, default="Medium")
    # org-level kill switch
    realtime_enabled = Column(Boolean, nullable=False, default=True)
    digest_enabled = Column(Boolean, nullable=False, default=True)
    analytics_enabled = Column(Boolean, nullable=False, default=True)

    updated_by = Column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True,
    )

    organization = relationship("Organization")


class UserNotificationPref(BaseModel):
    """One row per user; lazy-created on first access."""
    __tablename__ = "user_notification_pref"

    user_id = Column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False, unique=True, index=True,
    )

    realtime_enabled = Column(Boolean, nullable=False, default=False)
    # severity values the user wants — stored as ordered list
    severity_filter = Column(JSONB, nullable=False, default=lambda: ["Critical", "High"])
    # null = all violation types
    type_filter = Column(JSONB, nullable=True)

    digest_cadence = Column(String(20), nullable=False, default="daily")  # none|daily
    digest_hour = Column(Integer, nullable=False, default=9)  # 0-23 in user tz

    analytics_cadence = Column(String(20), nullable=False, default="weekly")  # none|daily|weekly|monthly

    timezone = Column(String(64), nullable=False, default="UTC")

    # signed unsubscribe token (rotated on prefs reset)
    unsubscribe_token = Column(String(255), nullable=True, index=True)

    user = relationship("User")


class NotificationLog(BaseModel):
    """Audit trail + throttling source-of-truth."""
    __tablename__ = "notification_log"

    user_id = Column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False, index=True,
    )
    organization_id = Column(
        UUID(as_uuid=True),
        ForeignKey("organizations.id", ondelete="CASCADE"),
        nullable=False, index=True,
    )

    channel = Column(String(20), nullable=False, default="email")
    # realtime | digest | analytics | test | suppressed
    kind = Column(String(20), nullable=False)
    # violation_id (realtime/suppressed) or run id (digest/analytics) — nullable.
    # String because violation IDs are now incident-style strings (INC-...).
    ref_id = Column(String(64), nullable=True)
    # camera the realtime alert was about — used by throttle query
    camera_id = Column(
        UUID(as_uuid=True),
        ForeignKey("cameras.id", ondelete="SET NULL"),
        nullable=True,
    )
    # violation severity at time of send (for analytics on what fired)
    severity = Column(String(20), nullable=True)

    status = Column(String(20), nullable=False, default="sent")  # sent|failed|suppressed
    sent_at = Column(DateTime(timezone=True), nullable=False, index=True)
    error = Column(String, nullable=True)

    __table_args__ = (
        # primary throttle lookup: did this user get any realtime for this camera in last N min?
        Index(
            "ix_notif_throttle",
            "user_id", "camera_id", "kind", "sent_at",
        ),
    )
