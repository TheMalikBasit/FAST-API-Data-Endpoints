from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.db.database import get_db
from app.models.user import User
from app.models.violation import Violation
from app.models.camera import Camera
from app.models.device import Device
# UPDATED: Import the new schemas we defined
from app.schemas.events import ViolationReportSchema, ViolationResponse
from app.core.dependencies import get_current_active_user, get_device_by_token
from typing import Dict, Any, List
from datetime import datetime, timedelta
from fastapi.responses import JSONResponse

router = APIRouter(prefix="/events", tags=["Events"])


# This function would be expanded to handle Email/SMS notifications
def trigger_alert(violation_data: ViolationReportSchema):
    """Placeholder for the notification service (Email, SMS, Webhook)."""
    print(
        f"ALERT TRIGGERED: {violation_data.violation_type} (Severity: {violation_data.severity}) at {violation_data.timestamp_utc}")
    pass


@router.post("/violation", status_code=status.HTTP_201_CREATED)
async def log_violation(
        report: ViolationReportSchema,  # UPDATED: Use new schema with severity
        db: AsyncSession = Depends(get_db),
        # UPDATED: Security Check - Ensure request comes from a valid Edge Device
        device: Device = Depends(get_device_by_token)
) -> Dict[str, Any]:
    """
    Receives a confirmed violation event from the Edge Device and logs it.
    """

    # 1. Security & Context Check
    # Verify the camera exists AND belongs to the authenticating device
    stmt = select(Camera).where(
        Camera.id == report.camera_id,
        Camera.device_id == device.id  # Security: Device cannot report for others
    )
    result = await db.execute(stmt)
    camera = result.scalars().first()

    if not camera:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Camera ID not found or does not belong to this device."
        )

    # 2. Create the Violation ORM object
    new_violation = Violation(
        organization_id=camera.organization_id,  # Derived from Camera (Multi-tenancy)
        camera_id=report.camera_id,
        timestamp_utc=report.timestamp_utc,
        violation_type=report.violation_type,

        # NEW: Save the severity determined by the Edge PC
        severity=report.severity,

        # NEW: Default status flags
        is_false_positive=False,
        is_resolved=False,

        person_track_id=report.person_track_id,
        snapshot_url=str(report.snapshot_url) if report.snapshot_url else None,
        duration_seconds=report.duration_seconds
    )

    # 3. Add to session and commit
    db.add(new_violation)
    await db.commit()
    await db.refresh(new_violation)

    # 4. Trigger Alert
    trigger_alert(report)

    return {"status": "success", "violation_id": new_violation.id}


@router.get("/violations", response_model=List[ViolationResponse])
async def get_violation_logs(
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db),
        limit: int = Query(20, ge=1, le=100),
):
    """Retrieves recent violations for the authenticated organization."""

    # 1. Join Violation with Camera to get context (Room Name / Camera Name)
    stmt = select(
        Violation,
        Camera.name.label("camera_name"),
        # We also have camera.location (Pending Work Rather to depreciate location and use name or make the use of location entity)
        Camera.name.label("room_name")
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
        # 2. UPDATED: No more manual severity calculation!
        # We read directly from the DB because the Edge PC sent it.

        # 3. Combine data for Pydantic validation
        violations_with_context.append(ViolationResponse.model_validate({
            "id": violation.id,
            "organization_id": violation.organization_id,
            "camera_id": violation.camera_id,
            "timestamp_utc": violation.timestamp_utc,
            "violation_type": violation.violation_type,
            "snapshot_url": violation.snapshot_url,
            "duration_seconds": violation.duration_seconds,
            "is_resolved": violation.is_resolved,

            # New Fields
            "severity": violation.severity,  # <-- Now coming from DB
            "is_false_positive": violation.is_false_positive,

            # Derived fields
            "camera_name": camera_name,
            "room_name": room_name,
        }))

    return violations_with_context


@router.get("/status/ml", tags=["Health"])
async def get_ml_status():
    """Mock Health Check."""
    return JSONResponse(content={
        "status": "Online",
        "latency_ms": 45,
        "last_sync": (datetime.now() - timedelta(seconds=2)).isoformat(),
        "gpu_load": 67,
        "storage_used_gb": 234,
        "storage_total_gb": 300
    })