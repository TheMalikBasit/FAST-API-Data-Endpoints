from sqlalchemy import Column, String, ForeignKey, TIMESTAMP,DateTime, Boolean, Float, func
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from .base import BaseModel

# --- Violation Model ---
class Violation(BaseModel):
    """Corresponds to the 'violations' table (The event log)."""
    __tablename__ = 'violations'

    organization_id = Column(
        UUID(as_uuid=True),
        ForeignKey('organizations.id', ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    camera_id = Column(
        UUID(as_uuid=True),
        ForeignKey('cameras.id', ondelete="CASCADE"),
        nullable=False
    )

    timestamp_utc = Column(TIMESTAMP(timezone=True), nullable=False, index=True)
    violation_type = Column(String(100), nullable=False) # e.g., "MISSING_HELMET"
    person_track_id = Column(String(255), nullable=False)
    snapshot_url = Column(String, nullable=False)
    duration_seconds = Column(Float)
    is_resolved = Column(Boolean, default=False, nullable=False)

    # Define relationships
    camera = relationship("Camera", back_populates="violations")