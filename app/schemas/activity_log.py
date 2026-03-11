# app/schemas/activity_log.py
from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional, List, Any


class ActivityLogResponse(BaseModel):
    id: UUID
    user_id: Optional[UUID] = None
    action: str
    details: Optional[dict] = None
    created_at: datetime

    model_config = {"from_attributes": True}


class ActivityLogListResponse(BaseModel):
    logs: List[ActivityLogResponse]
    total_count: int
    page: int
    page_size: int
