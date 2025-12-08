from pydantic import BaseModel, EmailStr
from uuid import UUID
from typing import Optional

class UserCreate(BaseModel):
    email: EmailStr
    password: str
    organization_id: Optional[UUID] = None # Filled by Global Admin
    role: str = "Supervisor"

class UserInDB(BaseModel):
    id: UUID
    email: EmailStr
    organization_id: UUID
    role: str

    # Configuration to handle SQLAlchemy objects
    model_config = {
        "from_attributes": True
    }

class UserResponse(BaseModel):
    """Schema for returning secure user data to the frontend after authentication."""
    id: UUID
    email: EmailStr
    organization_id: UUID  # CRITICAL for filtering all dashboard data
    role: str

    # Configuration to handle SQLAlchemy objects
    model_config = {
        "from_attributes": True
    }