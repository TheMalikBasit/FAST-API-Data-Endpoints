from datetime import datetime, timedelta, timezone
from typing import Any, Union
import uuid
from app.core.config import settings
# Security libraries for hashing and JWT
from passlib.context import CryptContext
from jose import jwt, JWTError


# --- Password Hashing Setup ---
# CryptContext handles hashing and verifying passwords securely (using bcrypt)
# bcrypt is the recommended hashing scheme for passwords
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verifies a plain-text password against a hashed one from the database."""
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    """Generates a secure hash for a plain-text password for storage."""
    return pwd_context.hash(password)

# --- Token (JWT) Management Setup ---

def create_access_token(
        subject: Union[str, Any],
        token_type: str,
        expires_delta: timedelta = None
) -> str:
    """
    Generates a JSON Web Token (JWT).

    Args:
        subject: The unique identifier (e.g., Device ID, User ID).
        token_type: Custom field to distinguish between 'device' and 'user' tokens.
        expires_delta: How long the token should be valid.
    """
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        # Default expiration time (e.g., 30 days for devices, 15 min for users)
        expire = datetime.now(timezone.utc) + timedelta(days=30)

        # Payload includes the unique subject, expiration time ('exp'), and token type ('type')
    to_encode = {"exp": expire, "sub": str(subject), "type": token_type}

    # Encode the token using the SECRET_KEY from your .env file
    encoded_jwt = jwt.encode(
        to_encode,
        settings.SECRET_KEY,
        algorithm=settings.ALGORITHM # Defined in config.py (e.g., HS256)
    )
    return encoded_jwt

def decode_token(token: str) -> dict:
    """Decodes and verifies a JWT token."""
    try:
        payload = jwt.decode(
            token,
            settings.SECRET_KEY,
            algorithms=[settings.ALGORITHM]
        )
        return payload
    except JWTError:
        # Handles expired, invalid signature, or malformed tokens
        return None

    # --- Specific Device Token Generation (Used in /devices/provision) ---

def create_device_token(device_id: uuid.UUID) -> str:
    """Generates a long-lived, secure token for the Edge Device."""
    # Devices need a very long expiry time (e.g., 10 years)
    long_expiry = timedelta(days=365 * 10)
    return create_access_token(
        subject=device_id,
        token_type="device",
        expires_delta=long_expiry
    )