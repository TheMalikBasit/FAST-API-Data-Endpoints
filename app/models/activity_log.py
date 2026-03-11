# app/models/activity_log.py
from sqlalchemy import Column, String, ForeignKey, Index
from sqlalchemy.dialects.postgresql import UUID, JSONB
from .base import BaseModel


class ActivityLog(BaseModel):
    """Corresponds to the 'activity_logs' table — one row per auditable action."""
    __tablename__ = 'activity_logs'

    # Organization scope (always present)
    organization_id = Column(
        UUID(as_uuid=True),
        ForeignKey('organizations.id', ondelete="CASCADE"),
        nullable=False,
    )

    # The user who performed the action (SET NULL when user is hard-deleted)
    user_id = Column(
        UUID(as_uuid=True),
        ForeignKey('users.id', ondelete="SET NULL"),
        nullable=True,
    )

    # Action code — e.g. USER_ADDED, USER_REMOVED, CAMERA_CONFIGURED,
    # USER_LOGIN, REPORT_DOWNLOADED, VIOLATION_FALSE_POSITIVE_TOGGLED,
    # VIOLATION_RESOLVED_TOGGLED
    action = Column(String(50), nullable=False)

    # Flexible context — actor info, target details, old/new values, etc.
    details = Column(JSONB, nullable=True)

    # Composite index for fast GlobalAdmin reads (org + newest first)
    __table_args__ = (
        Index('ix_activity_logs_org_created', 'organization_id', 'created_at'),
    )
