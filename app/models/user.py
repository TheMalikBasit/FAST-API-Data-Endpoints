# Add UniqueConstraint to this import line
from sqlalchemy import Column, String, ForeignKey, Boolean, DateTime, UniqueConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
from .base import BaseModel


class User(BaseModel):
    """Corresponds to the 'users' table."""
    __tablename__ = 'users'

    # Foreign Key linking back to Organization (Multi-Tenancy Key)
    organization_id = Column(
        UUID(as_uuid=True),
        ForeignKey('organizations.id', ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    # Make unique=False because names are not unique
    username = Column(String(100), nullable=False, index=True)
    # Make unique=False here (we handle it via table_args below)
    email = Column(String(255), nullable=False)
    password_hash = Column(String(255), nullable=False)
    role = Column(String(50), nullable=False, default="Supervisor")
    is_active = Column(Boolean, default=True, nullable=False)
    phone_number = Column(String, nullable=True)
    # 2FA Columns
    is_2fa_enabled = Column(Boolean, default=False, nullable=False)
    otp_hash = Column(String, nullable=True)
    otp_expires_at = Column(DateTime, nullable=True)
    organization = relationship("Organization", backref="users")
    # 3. New Rule: Email must be unique ONLY within the same Organization
    __table_args__ = (
        UniqueConstraint('email', 'organization_id', name='uix_user_email_org'),
    )