from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from jose import jwt, JWTError
from uuid import UUID
from app.db.database import get_db
from app.core.config import settings
from app.models.user import User # User model is needed to ensure the user exists
from app.models.device import Device

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/token")

async def get_current_active_user(
        db: AsyncSession = Depends(get_db),
        token: str = Depends(oauth2_scheme)
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        # Decode the token using the SECRET_KEY
        payload = jwt.decode(
            token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM]
        )
        user_id: str = payload.get("sub")
        token_type: str = payload.get("type")

        if user_id is None or token_type != "user":
            raise credentials_exception

        user_uuid = UUID(user_id)

    except JWTError:
        raise credentials_exception

    # Fetch the user from the DB to get their organization_id
    stmt = select(User).where(User.id == user_uuid)
    result = await db.execute(stmt)
    user = result.scalars().first()

    if user is None or not user.is_active:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found or inactive")

    return user

# --- NEW FUNCTION FOR EDGE DEVICE AUTH ---
# This assumes the Edge PC sends the token in the 'Authorization' header
# or a custom header. For simplicity, we reuse the OAuth2 scheme or just read a header.
# Since OAuth2 expects "Bearer <token>", we will support that.

async def get_device_by_token(
        token: str = Depends(oauth2_scheme),
        db: AsyncSession = Depends(get_db)
) -> Device:
    """
    Authenticates an Edge Device using its specific device token.
    Used for endpoints like /events/violation.
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid device credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        # Decode the token
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        device_id: str = payload.get("sub")
        token_type: str = payload.get("type")

        # Strict check: Must be a 'device' token, not a user token
        if device_id is None or token_type != "device":
            raise credentials_exception

        device_uuid = UUID(device_id)

    except JWTError:
        raise credentials_exception

    # Check if device exists in DB
    stmt = select(Device).where(Device.id == device_uuid)
    result = await db.execute(stmt)
    device = result.scalars().first()

    if not device:
        raise HTTPException(status_code=404, detail="Device not found")

    return device