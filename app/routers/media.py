from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import FileResponse
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from pathlib import Path
import os

from app.db.database import get_db
from app.models.violation import Violation

router = APIRouter(prefix="/media", tags=["Media & Storage"])

# Define paths
MEDIA_ROOT = Path("media")
PLACEHOLDER_FILENAME = "placeholder.jpg"


@router.get("/violation/{violation_id}/snapshot")
async def get_violation_snapshot(
        violation_id: str,
        db: AsyncSession = Depends(get_db)
):
    """
    Securely serves the snapshot image.
    If the specific image is missing, it returns the placeholder.
    """
    # 1. Fetch Violation Metadata
    try:
        stmt = select(Violation).where(Violation.id == violation_id)
        result = await db.execute(stmt)
        violation = result.scalars().first()
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid ID format")

    if not violation:
        raise HTTPException(status_code=404, detail="Violation not found")

    # 2. Identify the target file
    # If the DB has a filename, use it. If null, use placeholder.
    target_filename = violation.snapshot_url if violation.snapshot_url else PLACEHOLDER_FILENAME

    # Security: Ensure we only stick to filenames, remove folders to prevent directory traversal
    target_filename = os.path.basename(target_filename)

    file_path = MEDIA_ROOT / target_filename
    placeholder_path = MEDIA_ROOT / PLACEHOLDER_FILENAME

    # 3. Try to serve the real file
    if file_path.is_file():
        return FileResponse(file_path)

    # 4. Fallback: Serve placeholder if real file is missing
    if placeholder_path.is_file():
        return FileResponse(placeholder_path)

    # 5. Final Fail: If even placeholder is missing, return 404 (Don't Crash!)
    raise HTTPException(status_code=404, detail="Image evidence not available")