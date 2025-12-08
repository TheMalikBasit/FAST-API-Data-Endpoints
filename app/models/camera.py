from sqlalchemy import Column, String, ForeignKey, Boolean, Integer
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from .base import BaseModel

# --- Camera Model ---
class Camera(BaseModel):
    """Corresponds to the 'cameras' table."""
    __tablename__ = 'cameras'

    organization_id = Column(
        UUID(as_uuid=True),
        ForeignKey('organizations.id', ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    device_id = Column(
        UUID(as_uuid=True),
        ForeignKey('devices.id', ondelete="CASCADE"),
        nullable=False
    )

    name = Column(String(255), nullable=False)
    rtsp_url = Column(String, nullable=False) # TEXT type is good here for long URLs
    local_timezone = Column(String(50), nullable=False)
    status = Column(String(50), default="Offline")

    # Define relationships
    device = relationship("Device", back_populates="cameras")
    rules = relationship("CameraRule", uselist=False, back_populates="camera") # One-to-one relationship
    violations = relationship("Violation", back_populates="camera") # One camera has many violations

# --- CameraRule Model ---
class CameraRule(BaseModel):
    """Corresponds to the 'camera_rules' table."""
    __tablename__ = 'camera_rules'

    # Foreign Key that also acts as a UNIQUE constraint for the one-to-one link
    camera_id = Column(
        UUID(as_uuid=True),
        ForeignKey('cameras.id', ondelete="CASCADE"),
        primary_key=True # Ensures one rule per camera
    )

    is_active = Column(Boolean, default=True, nullable=False)

    # PPE Requirement Flags
    ppe_helmet_required = Column(Boolean, default=False, nullable=False)
    ppe_vest_required = Column(Boolean, default=False, nullable=False)
    ppe_glasses_required = Column(Boolean, default=False, nullable=False)

    # JSONB for storing flexible, queryable data like detection zone coordinates
    detection_zones = Column(JSONB)
    violation_cooldown_sec = Column(Integer, default=60, nullable=False)

    # Define relationship
    camera = relationship("Camera", back_populates="rules")