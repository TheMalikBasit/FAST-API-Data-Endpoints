from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import FileResponse
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from pathlib import Path
import os

from app.db.database import get_db
from app.models.user import User
from app.models.violation import Violation
from app.core.dependencies import get_current_active_user

router = APIRouter(prefix="/media", tags=["Media & Storage"])

# Define where files are physically stored
MEDIA_ROOT = Path("media")


@router.get("/violation/{violation_id}/snapshot")
async def get_violation_snapshot(
        violation_id: str,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """
    Securely serves the snapshot image for a specific violation.
    Only allows access if the User belongs to the same Organization as the Violation.
    """
    # 1. Fetch the Violation
    try:
        stmt = select(Violation).where(Violation.id == violation_id)
        result = await db.execute(stmt)
        violation = result.scalars().first()
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid Violation ID format")

    if not violation:
        raise HTTPException(status_code=404, detail="Violation not found")

    # 2. SECURITY CHECK: Tenant Isolation
    # Does the user's Org match the Violation's Org?
    if violation.organization_id != current_user.organization_id:
        print(f"🚨 Security Alert: User {current_user.email} tried to access data from another Org!")
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You do not have permission to view this evidence."
        )

    # 3. Locate the file on disk
    # We assume the 'snapshot_url' field in DB stores the filename or relative path
    # Example DB value: "violations/2026/01/snapshot_123.jpg" or just "snapshot_123.jpg"

    # For this phase, let's assume we store the filename in a specific column or extract it
    # If using the seed data, the URL is http://.../something.jpg. We need the filename.

    file_name = os.path.basename(violation.snapshot_url)
    file_path = MEDIA_ROOT / file_name

    # 4. Check if file actually exists
    if not file_path.is_file():
        # Fallback for demo purposes if the real file is missing
        # (Useful during development so the app doesn't crash)
        return FileResponse("media/placeholder.jpg")

        # 5. Serve the file
    return FileResponse(file_path)