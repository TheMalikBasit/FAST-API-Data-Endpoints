from pydantic import BaseModel, Field, EmailStr
from uuid import UUID
from typing import Optional

class Token(BaseModel):
    """Response model for a successful login."""
    access_token: str
    token_type: str = "bearer"

class OrganizationRegister(BaseModel):
    """Input model for registering a new Organization, Device, and Global Admin User."""

    # Organization Details
    organization_name: str = Field(..., max_length=255)

    # Initial Device Details (The Edge PC)
    device_name: str = Field(..., max_length=255)

    # Initial Admin User Credentials
    admin_username: str = Field(..., min_length=3, max_length=100)
    admin_email: EmailStr
    admin_password: str = Field(..., min_length=8)

class OrganizationRegisterResponse(BaseModel):
    """Output model for the successful registration."""
    organization_id: UUID
    device_id: UUID
    # This token is the unique secure credential for the Edge PC deployment
    device_token_secret: str
    admin_email: EmailStr
    message: str = "Organization, Device, and Admin user created successfully."


class TokenOr2FA(BaseModel):
    """
    Response for the Login endpoint.
    Can either contain the Token (login success)
    OR a flag indicating 2FA is required.
    """
    access_token: Optional[str] = None
    token_type: Optional[str] = None

    # 2FA Flags
    is_2fa_required: bool = False
    message: Optional[str] = None


class Verify2FARequest(BaseModel):
    email: EmailStr
    otp_code: str


class Toggle2FARequest(BaseModel):
    enable: bool