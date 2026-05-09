from sqlalchemy import Column, String, ForeignKey, Boolean, Integer, DateTime
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from .base import BaseModel

class Camera(BaseModel):
    """Corresponds to the 'cameras' table."""
    __tablename__ = 'cameras'

    organization_id = Column(UUID(as_uuid=True), ForeignKey('organizations.id', ondelete="CASCADE"), nullable=False, index=True)
    device_id = Column(UUID(as_uuid=True), ForeignKey('devices.id', ondelete="CASCADE"), nullable=False)

    name = Column(String(255), nullable=False)
    rtsp_url = Column(String, nullable=False)
    local_timezone = Column(String(50), nullable=False)
    status = Column(String(50), default="Offline")

    # Soft-delete marker. When set, the camera is hidden from the active fleet
    # but the row remains so historical violations keep resolving camera_id.
    deleted_at = Column(DateTime(timezone=True), nullable=True, index=True)

    # Define relationships
    # passive_deletes=True + cascade="all, delete" defers cascade to the DB's
    # ondelete="CASCADE" FK constraint, so async session.delete() doesn't try
    # to lazy-load children (which raises MissingGreenlet in async mode).
    device = relationship("Device", back_populates="cameras")
    rules = relationship(
        "CameraRule",
        uselist=False,
        back_populates="camera",
        cascade="all, delete",
        passive_deletes=True,
    )
    violations = relationship(
        "Violation",
        back_populates="camera",
        cascade="all, delete",
        passive_deletes=True,
    )
    location = Column(String(255), nullable=True)

class CameraRule(BaseModel):
    """Corresponds to the 'camera_rules' table."""
    __tablename__ = 'camera_rules'

    # Foreign Key that also acts as a UNIQUE constraint for the one-to-one link
    camera_id = Column(UUID(as_uuid=True), ForeignKey('cameras.id', ondelete="CASCADE"), primary_key=True)
    is_active = Column(Boolean, default=True, nullable=False)

    # DYNAMIC FIELD: keys are object_codes from the capabilities table.
    # Values are nested config dicts. Required fields: required, severity.
    # Optional (Phase 1+): validation_window_sec, flicker_tolerance_sec,
    #                     cooldown_sec, min_confidence, scope, active_hours.
    # Example:
    #   {
    #     "hard_hat": {"required": true, "severity": "High"},
    #     "phone":    {"required": false, "severity": "Medium",
    #                  "validation_window_sec": 30, "cooldown_sec": 120}
    #   }
    active_rules = Column(JSONB, default={}, nullable=False)

    detection_zones = Column(JSONB)
    violation_cooldown_sec = Column(Integer, default=60, nullable=False)

    camera = relationship("Camera", back_populates="rules")