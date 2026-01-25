from pydantic import BaseModel, Field
from typing import List

class CapabilityCreate(BaseModel):
    """
    Schema for a single detection capability sent by the Edge ML model.
    Example: {"object_code": "hard_hat", "display_name": "Hard Hat", "is_ppe": true}
    """
    object_code: str = Field(..., max_length=100, description="Raw class name from YOLO (e.g., 'no_helmet')")
    display_name: str = Field(..., max_length=100, description="Human-readable name (e.g., 'No Helmet')")
    is_ppe: bool = Field(False, description="Whether this object is a safety rule item")

class CapabilitySyncRequest(BaseModel):
    """The list payload sent to /devices/capabilities/sync"""
    capabilities: List[CapabilityCreate]

class CapabilityResponse(BaseModel):
    """
    Schema for sending capability data to the Frontend (Manage Page).
    """
    object_code: str
    display_name: str
    is_ppe: bool
    model_config = {"from_attributes": True} # This allows Pydantic to read data directly from the SQLAlchemy model