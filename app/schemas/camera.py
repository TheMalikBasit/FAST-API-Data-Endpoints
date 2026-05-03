from pydantic import BaseModel, Field
from typing import Optional, Dict, Any
from uuid import UUID

class CameraRulesSchema(BaseModel):
    required: bool = False
    severity: str = "Medium"


class CameraCreate(BaseModel):
    name: str = Field(..., max_length=255)
    location: Optional[str] = Field(None, max_length=255)
    rtsp_url: str = Field(..., min_length=1)
    device_id: UUID


class CameraResponse(BaseModel):
    id: UUID
    name: str
    location: Optional[str] = None
    rtsp_url: str
    status: str
    active_rules: Dict[str, Any] = {}

    model_config = {"from_attributes": True}


class CameraUpdate(BaseModel):
    name: Optional[str] = None
    location: Optional[str] = None
    rtsp_url: Optional[str] = None
    active_rules: Optional[Dict[str, Any]] = None