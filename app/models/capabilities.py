from sqlalchemy import Column, String, Boolean, ForeignKey, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
import uuid
from app.models.base import BaseModel

class OrganizationCapability(BaseModel):
    __tablename__ = "organization_capabilities"

    organization_id = Column(UUID(as_uuid=True), ForeignKey("organizations.id", ondelete="CASCADE"), nullable=False)
    object_code = Column(String(100), nullable=False)
    display_name = Column(String(100), nullable=False)
    is_ppe = Column(Boolean, default=False)

    __table_args__ = (UniqueConstraint('organization_id', 'object_code', name='_org_object_uc'),)