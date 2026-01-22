from pydantic import BaseModel, Field, HttpUrl
from typing import List, Optional, Dict, Any
from uuid import UUID

# --- Schemas for Camera Data sent from Edge PC ---
class RuleConfig(BaseModel):
    """Defines the settings for a single object type."""
    required: bool = False
    severity: str = "Medium" # Options: Low, Medium, High, Critical

class RTSPStreamSchema(BaseModel):
    """Data model for a single RTSP stream discovered locally on the Edge PC."""
    rtsp_url: HttpUrl = Field(..., description="The full RTSP URL of the camera stream.")
    local_name: Optional[str] = Field(None, max_length=100)
    model_config = {"extra": "forbid"}

class DeviceHandshakeSchema(BaseModel):
    """The full payload sent from the Edge Docker on initial connection."""
    device_token_secret: str = Field(..., min_length=32)
    cameras: List[RTSPStreamSchema] # The list of cameras discovered on the local network.
    hostname: str = Field(..., max_length=100) # Information about the Edge PC itself (e.g., hostname, version)
    model_config = {"extra": "forbid"} # We enforce that no extra fields are sent by the Edge PC, which is safer.

class DeviceProvisionSchema(BaseModel):
    """Input model for provisioning a new device and organization (Admin use)."""
    organization_name: str = Field(..., max_length=255)
    device_name: str = Field(..., max_length=255)

class ProvisionResponseSchema(BaseModel):
    """Output model for the provisioning response. (Front End Usage) """
    organization_id: UUID
    device_id: UUID
    device_token_secret: str # This is the secret key used for the Edge Docker deployment (VERY sensitive!)
    message: str = "Device and organization provisioned successfully."

class DeviceResponse(BaseModel):
    """Output model for listing Edge Devices/Cameras. (Front End Usage) """
    id: UUID
    organization_id: UUID
    name: str
    status: str
    model_config = {"from_attributes": True}

class CameraRuleUpdate(BaseModel):
    """Input model for updating rules for a specific CAMERA."""
    camera_id: UUID
    name: str = Field(..., max_length=255)
    # Camera accepts a dictionary of RuleConfigs
    # Example: {"helmet": {"required": true, "severity": "Critical"}}
    active_rules: Dict[str, RuleConfig]

class CameraRuleResponse(BaseModel):
    """Output model for the successful camera rule update. (Front End Usage) """
    camera_id: UUID
    name: str
    active_rules: Dict[str, RuleConfig]  # Returns the detailed structure back to UI
    message: str = "Camera rules updated successfully."