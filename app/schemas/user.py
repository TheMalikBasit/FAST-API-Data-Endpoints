from pydantic import BaseModel, EmailStr, Field
from uuid import UUID
from typing import Optional

# --- EXISTING SCHEMAS (Kept for compatibility) ---
class UserCreate(BaseModel):
    username: str = Field(..., min_length=3, max_length=100)
    email: EmailStr
    password: str
    organization_id: Optional[UUID] = None
    role: str = "Supervisor"

class UserInDB(BaseModel):
    id: UUID
    email: EmailStr
    organization_id: UUID
    role: str
    model_config = {"from_attributes": True}

class UserResponse(BaseModel):
    """Basic schema for auth context."""
    id: UUID
    username: str
    email: EmailStr
    organization_id: UUID
    role: str
    # Added phone_number here too so it's available in context if needed
    phone_number: Optional[str] = None
    model_config = {"from_attributes": True}

# --- NEW SCHEMAS FOR PROFILE SETTINGS ---

class UserUpdateSchema(BaseModel):
    """Payload for updating user profile."""
    full_name: Optional[str] = None
    email: Optional[EmailStr] = None
    phone_number: Optional[str] = None

class UserProfileResponse(BaseModel):
    id: UUID
    username: str
    email: EmailStr
    phone_number: Optional[str] = None
    role: str
    organization_id: UUID
    organization_name: str
    is_2fa_enabled: bool = False

    model_config = {"from_attributes": True}

class UserPasswordUpdate(BaseModel):
    current_password: str = Field(..., description="Required to verify identity")
    new_password: str = Field(..., min_length=8, description="New secure password")