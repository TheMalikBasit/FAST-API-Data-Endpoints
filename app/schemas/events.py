# app/schemas/events.py

from pydantic import BaseModel, Field
from typing import Optional
from uuid import UUID
from datetime import datetime

class ViolationResponse(BaseModel):
    id: UUID
    timestamp_utc: datetime # Matches model field
    violation_type: str     # Matches model field
    # The 'severity' field from the UI must be derived or added to the model later.
    # For now, we will add a placeholder field here.
    severity: str = Field(..., description="e.g., critical, high, medium")

    snapshot_url: str       # Matches model field (your 'image_url')
    duration_seconds: Optional[float] = None
    is_resolved: bool

    # Additional fields needed for the dashboard UI (Camera Name, Location)
    camera_name: Optional[str] = None
    room_name: Optional[str] = None

    model_config = {
        "from_attributes": True
    }