from sqlalchemy import Column, String, ForeignKey, Boolean, Integer
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

    # Define relationships
    device = relationship("Device", back_populates="cameras")
    rules = relationship("CameraRule", uselist=False, back_populates="camera") # One-to-one relationship
    violations = relationship("Violation", back_populates="camera") # One camera has many violations
    location = Column(String(255), nullable=True)

class CameraRule(BaseModel):
    """Corresponds to the 'camera_rules' table."""
    __tablename__ = 'camera_rules'

    # Foreign Key that also acts as a UNIQUE constraint for the one-to-one link
    camera_id = Column(UUID(as_uuid=True), ForeignKey('cameras.id', ondelete="CASCADE"), primary_key=True)
    is_active = Column(Boolean, default=True, nullable=False)

    # DYNAMIC FIELD: Stores rules as {"hard_hat": true, "vest": false, "harness": true}
    # The keys here will match the 'object_code' from your capabilities table.
    active_rules = Column(JSONB, default={}, nullable=False)

    detection_zones = Column(JSONB)
    violation_cooldown_sec = Column(Integer, default=60, nullable=False)

    camera = relationship("Camera", back_populates="rules")