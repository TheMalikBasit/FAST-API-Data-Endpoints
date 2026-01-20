from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.db.database import get_db
from app.models.user import User
from app.models.violation import Violation
from app.models.camera import Camera
from app.schemas.violation import ViolationCreateSchema, ViolationResponseSchema
from app.core.dependencies import get_current_active_user
from typing import Dict, Any
from uuid import UUID
from typing import Dict, Any, Optional, List
from datetime import datetime, timedelta
from fastapi.responses import JSONResponse

router = APIRouter(prefix="/events", tags=["Events"])

# This function would be expanded to handle Email/SMS notifications
def trigger_alert(violation_data: ViolationCreateSchema):
    """Placeholder for the notification service (Email, SMS, Webhook)."""
    print(f"ALERT TRIGGERED: {violation_data.violation_type} at {violation_data.timestamp_utc}")
    # In production: send data to an external queue (e.g., Redis or a dedicated Email Service)
    pass

# Dependency to check Camera validity and get its organization_id
async def get_valid_camera_info(camera_id: UUID, db: AsyncSession = Depends(get_db)):
    """Validates the Camera ID and retrieves required data (especially organization_id)."""
    stmt = select(Camera).where(Camera.id == camera_id)
    result = await db.execute(stmt)
    camera = result.scalars().first()

    if not camera:
        # A 404 implies the Edge Docker sent an ID for a camera that doesn't exist centrally
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Invalid Camera ID in violation report.")

    # Return the organization_id needed for the Violation record
    return camera.organization_id

@router.post("/violation", status_code=status.HTTP_201_CREATED)
async def log_violation(
        violation_data: ViolationCreateSchema,
        db: AsyncSession = Depends(get_db),
        # Use the validation function as a dependency, and alias its return value
        organization_id: UUID = Depends(get_valid_camera_info)
) -> Dict[str, Any]:
    """Receives a confirmed violation event and logs it to the database."""

    # 1. Create the Violation ORM object
    new_violation = Violation(
        organization_id=organization_id,  # Fetched securely from the dependency
        camera_id=violation_data.camera_id,
        timestamp_utc=violation_data.timestamp_utc,
        violation_type=violation_data.violation_type,
        person_track_id=violation_data.person_track_id,
        snapshot_url=str(violation_data.snapshot_url),
        duration_seconds=violation_data.duration_seconds
    )

    # 2. Add to session and commit
    db.add(new_violation)
    await db.commit()
    await db.refresh(new_violation) # Refresh to get the generated UUID

    # 3. Trigger Alert (non-blocking)
    # Note: This should ideally be handed off to a separate worker (like Celery/Redis Queue)
    trigger_alert(violation_data)

    return {"status": "success", "violation_id": new_violation.id}

@router.get("/violations", response_model=List[ViolationResponseSchema])
async def get_violation_logs(
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db),
        limit: int = Query(20, ge=1, le=100),
):
    """Retrieves recent violations for the authenticated organization, joining Camera data."""

    # 1. Complex Multi-Tenancy Join Query
    # Join Violation (V) with Camera (C) to get the required context fields
    stmt = select(
        Violation,
        Camera.name.label("camera_name"),
        Camera.location.label("room_name") # Assumes location field is now on Camera model
    ).join(
        Camera, Violation.camera_id == Camera.id
    ).where(
        Violation.organization_id == current_user.organization_id
    ).order_by(
        Violation.timestamp_utc.desc()
    ).limit(limit)

    results = await db.execute(stmt)

    violations_with_context = []

    for violation, camera_name, room_name in results.all():
        # 2. Map violation_type to a UI-friendly severity (CRITICAL, HIGH, etc.)
        severity = "low"
        violation_type = violation.violation_type.upper() # Standardize violation type

        if violation_type in ["MISSING_HELMET", "FIRE_EXIT_BLOCKED"]:
            severity = "critical"
        elif violation_type in ["RESTRICTED_AREA", "MISSING_VEST"]:
            severity = "high"

        # 3. Combine data for Pydantic validation
        violations_with_context.append(ViolationResponseSchema.model_validate({
            # Direct mapping from Violation model
            "id": violation.id,
            "timestamp_utc": violation.timestamp_utc,
            "violation_type": violation.violation_type,
            "snapshot_url": violation.snapshot_url, # Maps to snapshot_url
            "duration_seconds": violation.duration_seconds,
            "is_resolved": violation.is_resolved,

            # Derived/Joined fields
            "severity": severity,
            "camera_name": camera_name,
            "room_name": room_name,
        }))

    return violations_with_context

@router.get("/status/ml", tags=["Health"], response_model=Dict[str, Any])
async def get_ml_status():
    """
    Simulates checking the connection and latency to the downstream ML service.
    (In a real app, this pings the actual ML server.)
    """

    # Mocking the real-time check result:
    status = "Online"
    latency_ms = 45 # Mock latency value

    # We can fetch the last heartbeat of the Edge Docker here (from the devices table)
    # For now, we return a mock status mirroring your UI.

    return JSONResponse(content={
        "status": status,
        "latency_ms": latency_ms,
        "last_sync": (datetime.now() - timedelta(seconds=2)).isoformat(),
        "gpu_load": 67, # Mock GPU load
        "storage_used_gb": 234, # Mock storage usage
        "storage_total_gb": 300
    })