from pydantic import BaseModel, Field
from typing import Optional, Dict, Any
from uuid import UUID

class CameraRulesSchema(BaseModel):
    required: bool = False
    severity: str = "Medium"


class CameraResponse(BaseModel):
    id: UUID
    name: str
    location: Optional[str] = None
    rtsp_url: str
    status: str
    active_rules: Dict[str, Any] = {} # This will return the JSON rules (e.g., {"helmet": {"required": true...}})

    model_config = {"from_attributes": True}


class CameraUpdate(BaseModel):
    name: Optional[str] = None
    location: Optional[str] = None
    rtsp_url: Optional[str] = None
    active_rules: Optional[Dict[str, Any]] = None