# app/models/violation.py
from sqlalchemy import Column, String, ForeignKey, Boolean, Float, DateTime, TIMESTAMP
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from .base import BaseModel


class Violation(BaseModel):
    """Corresponds to the 'violations' table (The event log)."""
    __tablename__ = 'violations'

    # 1. Foreign Keys
    organization_id = Column(UUID(as_uuid=True),ForeignKey('organizations.id', ondelete="CASCADE"),nullable=False,index=True)
    camera_id = Column(UUID(as_uuid=True),ForeignKey('cameras.id', ondelete="CASCADE"),nullable=False)

    # 2. Event Metadata
    timestamp_utc = Column(TIMESTAMP(timezone=True), server_default=func.now(), nullable=False, index=True)
    violation_type = Column(String(100), nullable=False)  # e.g., "no_helmet"

    # 3. Analytics Fields (The New Stuff)
    severity = Column(String(20), default="Medium", nullable=False)  # Critical, High, Medium, Low
    is_false_positive = Column(Boolean, default=False, nullable=False)

    # 4. Evidence
    snapshot_url = Column(String, nullable=True)  # Changed to nullable=True just in case upload fails
    person_track_id = Column(String(255), nullable=True)
    duration_seconds = Column(Float, default=0.0)

    # 5. Status
    is_resolved = Column(Boolean, default=False, nullable=False)

    # 6. Relationships
    camera = relationship("Camera", back_populates="violations")