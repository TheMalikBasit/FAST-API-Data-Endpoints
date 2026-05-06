from datetime import datetime
from typing import List, Optional
from uuid import UUID
from pydantic import BaseModel, Field


# ---------- Org policy ----------
class OrgPolicyResponse(BaseModel):
    organization_id: UUID
    eligible_roles: List[str]
    severity_floor: str
    realtime_enabled: bool
    digest_enabled: bool
    analytics_enabled: bool
    updated_at: datetime

    model_config = {"from_attributes": True}


class OrgPolicyUpdate(BaseModel):
    eligible_roles: Optional[List[str]] = None
    severity_floor: Optional[str] = Field(None, pattern="^(Low|Medium|High|Critical)$")
    realtime_enabled: Optional[bool] = None
    digest_enabled: Optional[bool] = None
    analytics_enabled: Optional[bool] = None


# ---------- User prefs ----------
class UserPrefResponse(BaseModel):
    realtime_enabled: bool
    severity_filter: List[str]
    type_filter: Optional[List[str]]
    digest_cadence: str
    digest_hour: int
    analytics_cadence: str
    timezone: str

    model_config = {"from_attributes": True}


class UserPrefUpdate(BaseModel):
    realtime_enabled: Optional[bool] = None
    severity_filter: Optional[List[str]] = None
    type_filter: Optional[List[str]] = None  # null clears (= all types)
    digest_cadence: Optional[str] = Field(None, pattern="^(none|daily)$")
    digest_hour: Optional[int] = Field(None, ge=0, le=23)
    analytics_cadence: Optional[str] = Field(None, pattern="^(none|daily|weekly|monthly)$")
    timezone: Optional[str] = None


# ---------- Audit log ----------
class NotificationLogRow(BaseModel):
    id: UUID
    user_id: UUID
    channel: str
    kind: str
    ref_id: Optional[UUID]
    camera_id: Optional[UUID]
    severity: Optional[str]
    status: str
    sent_at: datetime
    error: Optional[str]

    model_config = {"from_attributes": True}


class NotificationLogPage(BaseModel):
    rows: List[NotificationLogRow]
    total: int
