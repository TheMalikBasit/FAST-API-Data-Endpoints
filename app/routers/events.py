from fastapi import APIRouter, Depends, HTTPException, status, Query, UploadFile, File, Form
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List, Dict, Any
from datetime import datetime, timedelta
import shutil
import os
from pathlib import Path
from uuid import uuid4
from fastapi.responses import JSONResponse

from app.db.database import get_db
from app.models.user import User
from app.models.violation import Violation
from app.models.camera import Camera
from app.models.device import Device
from app.core.dependencies import get_current_active_user, get_device_by_token

# We only need the Response schema now, as the Input is handled by Form() fields
from app.schemas.events import ViolationResponse

router = APIRouter(prefix="/events", tags=["Events"])

# Define where to store evidence
MEDIA_ROOT = Path("media")


# --- 1. NEW: Handle Violation Upload (Image + Data) ---
@router.post("/violation", status_code=status.HTTP_201_CREATED)
async def log_violation(
        # -- Metadata (Form Fields) --
        device_token: str = Form(..., description="Secret token of the Edge Device"),
        camera_id: str = Form(..., description="UUID of the Camera"),
        violation_type: str = Form(..., description="Code like 'no_helmet'"),
        severity: str = Form("Medium", description="Critical, High, Medium, Low"),
        confidence: float = Form(0.0, description="AI Confidence Score (0.0 - 1.0)"),

        # -- The Evidence File --
        image: UploadFile = File(..., description="Snapshot of the violation"),

        # -- DB Session --
        db: AsyncSession = Depends(get_db)
):
    """
    Receives violation alerts from Edge AI devices.
    Validates the device, saves the image, and logs to DB.
    """

    # A. Manual Device Authentication
    # We do this manually here because the token is coming inside the Form Data,
    # not the Headers (which is what get_device_by_token usually checks).
    stmt = select(Device).where(Device.device_token_secret == device_token)
    result = await db.execute(stmt)
    device = result.scalars().first()

    if not device:
        raise HTTPException(status_code=401, detail="Invalid Device Token")

    # B. Validate Camera & Organization
    stmt_cam = select(Camera).where(Camera.id == camera_id)
    result_cam = await db.execute(stmt_cam)
    camera = result_cam.scalars().first()

    if not camera:
        raise HTTPException(status_code=404, detail="Camera not found")

    if camera.organization_id != device.organization_id:
        raise HTTPException(status_code=403, detail="Camera does not belong to your Organization")

    # C. Save Image to Disk
    # Create folder structure if needed, or just use root media/ for now
    os.makedirs(MEDIA_ROOT, exist_ok=True)

    # Generate unique filename
    file_ext = image.filename.split(".")[-1] if "." in image.filename else "jpg"
    filename = f"violation_{uuid4()}.{file_ext}"
    file_path = MEDIA_ROOT / filename

    try:
        # Reset file cursor and save
        image.file.seek(0)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(image.file, buffer)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to save image: {str(e)}")

    # D. Create Database Entry
    new_violation = Violation(
        organization_id=device.organization_id,
        camera_id=camera.id,
        timestamp_utc=datetime.utcnow(),
        violation_type=violation_type,
        severity=severity,
        is_false_positive=False,
        is_resolved=False,
        snapshot_url=filename,  # Storing the filename we just created
        duration_seconds=0.0  # Single frame event
    )

    db.add(new_violation)

    # Update Device Heartbeat
    device.last_heartbeat = datetime.utcnow()

    await db.commit()
    await db.refresh(new_violation)

    return {
        "status": "recorded",
        "violation_id": str(new_violation.id),
        "image_saved": filename
    }


# --- 2. EXISTING: List Violations (For Dashboard) ---
@router.get("/violations", response_model=List[ViolationResponse])
async def get_violation_logs(
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db),
        limit: int = Query(20, ge=1, le=100),
):
    """Retrieves recent violations for the authenticated organization."""

    stmt = select(
        Violation,
        Camera.name.label("camera_name"),
        Camera.name.label("room_name")  # Fallback to name if location is missing
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
        # Validate using Pydantic Schema
        violations_with_context.append(ViolationResponse.model_validate({
            "id": violation.id,
            "organization_id": violation.organization_id,
            "camera_id": violation.camera_id,
            "timestamp_utc": violation.timestamp_utc,
            "violation_type": violation.violation_type,
            "snapshot_url": violation.snapshot_url,
            "duration_seconds": violation.duration_seconds,
            "is_resolved": violation.is_resolved,
            "severity": violation.severity,
            "is_false_positive": violation.is_false_positive,
            "camera_name": camera_name,
            "room_name": room_name,
        }))

    return violations_with_context


# --- 3. EXISTING: Health Check ---
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