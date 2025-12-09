from sqlalchemy import Column, String, ForeignKey, TIMESTAMP
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
from .base import BaseModel

# --- Organization Model ---
class Organization(BaseModel):
    """Corresponds to the 'organizations' table."""
    __tablename__ = 'organizations'

    name = Column(String(255), nullable=False, unique=True)
    status = Column(String(50), nullable=False, default="Active")
    api_key_public = Column(String(255), unique=True) # Public key for setup guides

    # Define relationship to its devices (one organization has many devices)
    devices = relationship("Device", back_populates="organization")

# --- Device Model (The Edge PC) ---
class Device(BaseModel):
    """Corresponds to the 'devices' table (the local Edge PC)."""
    __tablename__ = 'devices'

    # Foreign Key linking back to Organization
    organization_id = Column(
        UUID(as_uuid=True),
        ForeignKey('organizations.id', ondelete="CASCADE"),
        nullable=False,
        index=True
    )

    name = Column(String(255), nullable=False)
    status = Column(String(50), default="Offline", nullable=False) # <--- THIS IS REQUIRED
    device_token_secret = Column(String(255), unique=True, nullable=False) # The secure auth token
    last_heartbeat = Column(TIMESTAMP(timezone=True)) # To monitor system health

    # Define relationships
    organization = relationship("Organization", back_populates="devices")
    cameras = relationship("Camera", back_populates="device")