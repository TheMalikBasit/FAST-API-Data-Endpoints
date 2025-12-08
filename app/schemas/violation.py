from pydantic import BaseModel, Field, HttpUrl
from uuid import UUID
from datetime import datetime
from typing import Optional

class ViolationCreateSchema(BaseModel):
    """Data model for a confirmed violation event sent by the Edge Docker."""

    # The ID of the camera that generated the event (from the central 'cameras' table)
    camera_id: UUID = Field(..., description="UUID of the camera that triggered the event.")

    # The time the violation was detected, sent as UTC string (ISO 8601 format)
    # Pydantic automatically converts the incoming string to a Python datetime object.
    timestamp_utc: datetime = Field(..., description="UTC time of the violation (ISO 8601 format).")

    # The specific PPE item that was missing or violation type (e.g., 'MISSING_HELMET')
    violation_type: str = Field(..., max_length=100)

    # The unique ID assigned to the person being tracked (used for cooldown logic)
    person_track_id: str = Field(..., max_length=255)

    # The URL where the image evidence is stored (e.g., AWS S3 or central storage)
    snapshot_url: HttpUrl = Field(..., description="URL to the violation image evidence.")

    # Optional field to indicate how long the violation lasted before resolution/cooldown
    duration_seconds: Optional[float] = Field(None, ge=0.0)

    # For security and reliability, we forbid extra fields.
    model_config = {
        "extra": "forbid"
    }

class ViolationResponseSchema(BaseModel):
    """Schema for returning violation data to the dashboard."""
    id: UUID
    camera_id: UUID
    timestamp_utc: datetime
    violation_type: str
    person_track_id: str
    snapshot_url: str
    is_resolved: bool

    model_config = {
        "from_attributes": True
    }