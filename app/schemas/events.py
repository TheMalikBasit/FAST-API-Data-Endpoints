# app/schemas/events.py
from pydantic import BaseModel, Field
from uuid import UUID
from datetime import datetime
from typing import Optional


class ViolationReportSchema(BaseModel):
    """Payload sent by the Edge PC."""
    camera_id: UUID
    violation_type: str = Field(..., description="The object code (e.g. 'no_helmet')")

    # Edge PC determines severity from its local config
    severity: str = Field("Medium", description="Critical, High, Medium, Low")

    timestamp_utc: datetime
    person_track_id: Optional[str] = None
    snapshot_url: Optional[str] = None
    duration_seconds: float = 0.0


class ViolationResponse(BaseModel):
    """Response sent back to UI/Dashboard."""
    id: UUID
    organization_id: UUID  # Added back
    camera_id: UUID
    timestamp_utc: datetime
    violation_type: str
    severity: str

    snapshot_url: Optional[str]
    duration_seconds: Optional[float]

    is_resolved: bool
    is_false_positive: bool

    # For UI display (optional, requires joins in router to populate)
    camera_name: Optional[str] = None
    room_name: Optional[str] = None

    model_config = {
        "from_attributes": True
    }