from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import delete
from typing import List
from app.db.database import get_db
from app.models.capabilities import OrganizationCapability
from app.models.device import Device
from app.models.user import User
from app.core.dependencies import get_current_active_user
from app.schemas.capabilities import CapabilitySyncRequest, CapabilityResponse, CapabilityUpdate

router = APIRouter(prefix="/capabilities", tags=["AI Capabilities"])

# Note: We reuse the same logic from devices.py to verify the Edge PC
async def verify_edge_device(device_token: str, db: AsyncSession) -> Device:
    stmt = select(Device).where(Device.device_token_secret == device_token)
    device = (await db.execute(stmt)).scalars().first()
    if not device:
        raise HTTPException(status_code=403, detail="Invalid device token.")
    return device

@router.post("/sync")
async def sync_capabilities(
        payload: CapabilitySyncRequest,
        db: AsyncSession = Depends(get_db)
):
    """Called by the Edge ML model to register its detection classes."""
    # Authenticate via Device Token (Not a human user JWT!)
    device = await verify_edge_device(payload.device_token_secret, db)
    org_id = device.organization_id

    delete_stmt = delete(OrganizationCapability).where(OrganizationCapability.organization_id == org_id)
    await db.execute(delete_stmt)

    for obj in payload.capabilities:
        new_cap = OrganizationCapability(
            organization_id=org_id,
            object_code=obj.object_code,
            display_name=obj.display_name,
            is_ppe=obj.is_ppe
        )
        db.add(new_cap)

    await db.commit()
    return {"status": "success", "synced_count": len(payload.capabilities)}

@router.get("/", response_model=List[CapabilityResponse])
async def list_capabilities(
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    """Fetches the list of detectable objects for the user's UI Manage Page."""
    stmt = select(OrganizationCapability).where(
        OrganizationCapability.organization_id == current_user.organization_id
    )
    result = await db.execute(stmt)
    return result.scalars().all()

# ===== AI CAPABILITY MANAGEMENT (AI Capabilities) =====

@router.patch("/{object_code}", response_model=CapabilityResponse)
async def update_capability(
    object_code: str,
    capability_data: CapabilityUpdate,
    current_user: User = Depends(get_current_active_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Update a capability's display_name and/or is_ppe fields using user JWT authentication.
    Only fields provided in the request body will be updated (partial update).
    """
    # Find the capability by organization_id and object_code
    stmt = select(OrganizationCapability).where(
        OrganizationCapability.organization_id == current_user.organization_id,
        OrganizationCapability.object_code == object_code
    )
    result = await db.execute(stmt)
    capability = result.scalars().first()

    if not capability:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Capability with object_code '{object_code}' not found in this organization."
        )

    # Update only the provided fields
    if capability_data.display_name is not None:
        capability.display_name = capability_data.display_name
    if capability_data.is_ppe is not None:
        capability.is_ppe = capability_data.is_ppe

    await db.commit()
    await db.refresh(capability)
    return capability