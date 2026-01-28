from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from datetime import timedelta, datetime
import uuid
from uuid import UUID
from typing import Union, List, Optional
from app.db.database import get_db
from app.models.user import User
from app.models.device import Device, Organization
from app.schemas.auth import (
    Token,
    OrganizationRegister,
    OrganizationRegisterResponse,
    TokenOr2FA,
    Verify2FARequest,
    Toggle2FARequest
)
from app.schemas.user import (
    UserResponse,
    UserCreate,
    UserUpdateSchema,
    UserProfileResponse,
    UserPasswordUpdate
)
from app.core.security import (
    verify_password,
    create_access_token,
    get_password_hash,
    create_device_token,
    generate_otp_code  # <--- Imported new helper
)
from app.core.dependencies import get_current_active_user
from app.core.email import send_2fa_email  # <--- Ensure this exists from Phase 2

router = APIRouter(prefix="/auth", tags=["Authentication"])

ACCESS_TOKEN_EXPIRE_MINUTES = 30


# --- 1. SMART LOGIN ENDPOINT (Updated) ---
@router.post("/token", response_model=TokenOr2FA)
async def login_for_access_token(
        form_data: OAuth2PasswordRequestForm = Depends(),
        db: AsyncSession = Depends(get_db)
):
    """
    Smart Login:
    - If 2FA is OFF: Returns access_token immediately.
    - If 2FA is ON: Generates OTP, sends Email, and returns {is_2fa_required: True}.
    """
    normalized_email = form_data.username.lower()

    # 1. Verify Credentials
    stmt = select(User).where(User.email == normalized_email)
    user = (await db.execute(stmt)).scalars().first()

    if not user or not user.is_active or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # 2. Check 2FA Status
    if user.is_2fa_enabled:
        # --- 2FA FLOW ---
        otp = generate_otp_code()

        # Save hash and expiration (5 mins)
        user.otp_hash = get_password_hash(otp)
        user.otp_expires_at = datetime.utcnow() + timedelta(minutes=5)
        db.add(user)
        await db.commit()

        # Send Email (Background task preferred in production, but await is fine for now)
        try:
            await send_2fa_email(user.email, otp)
        except Exception as e:
            print(f"Failed to send email: {e}")
            raise HTTPException(status_code=500, detail="Failed to send 2FA code.")

        return {
            "is_2fa_required": True,
            "message": "Verification code sent to email."
        }

    # --- STANDARD FLOW (No 2FA) ---
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        subject=user.id,
        token_type="user",
        expires_delta=access_token_expires
    )

    return {
        "access_token": access_token,
        "token_type": "bearer",
        "is_2fa_required": False
    }


# --- 2. VERIFY 2FA ENDPOINT (New) ---
@router.post("/2fa/verify", response_model=Token)
async def verify_2fa_code(
        data: Verify2FARequest,
        db: AsyncSession = Depends(get_db)
):
    """
    Finalizes login by verifying the OTP sent to email.
    """
    stmt = select(User).where(User.email == data.email.lower())
    user = (await db.execute(stmt)).scalars().first()

    if not user:
        raise HTTPException(status_code=400, detail="User not found")

    # Check Checks
    if not user.otp_hash or not user.otp_expires_at:
        raise HTTPException(status_code=400, detail="No 2FA request pending.")

    if datetime.utcnow() > user.otp_expires_at:
        raise HTTPException(status_code=400, detail="Code expired. Please login again.")

    if not verify_password(data.otp_code, user.otp_hash):
        raise HTTPException(status_code=400, detail="Invalid verification code.")

    # Success! Clear OTP fields and issue token
    user.otp_hash = None
    user.otp_expires_at = None
    db.add(user)
    await db.commit()

    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        subject=user.id,
        token_type="user",
        expires_delta=access_token_expires
    )

    return {"access_token": access_token, "token_type": "bearer"}


# --- 3. TOGGLE 2FA SETTING (New) ---
@router.put("/2fa/toggle")
async def toggle_2fa(
        data: Toggle2FARequest,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """Allow user to enable/disable 2FA from profile settings."""
    current_user.is_2fa_enabled = data.enable
    db.add(current_user)
    await db.commit()

    status_msg = "enabled" if data.enable else "disabled"
    return {"message": f"Two-factor authentication {status_msg}."}


# --- 2. Method to REGISTER ORGANIZATION
@router.post(
    "/register/organization",
    response_model=OrganizationRegisterResponse,
    status_code=status.HTTP_201_CREATED
)
async def register_organization(
        data: OrganizationRegister,
        db: AsyncSession = Depends(get_db)
):
    user_exists_stmt = select(User).where(User.email == data.admin_email)
    if (await db.execute(user_exists_stmt)).scalar_one_or_none():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A user with this email already exists."
        )

    new_org = Organization(name=data.organization_name, status="Active")
    db.add(new_org)
    await db.flush()

    hashed_password = get_password_hash(data.admin_password)
    new_admin = User(
        organization_id=new_org.id,
        username=data.admin_username,
        email=data.admin_email,
        password_hash=hashed_password,
        role="GlobalAdmin",
        is_active=True
    )
    db.add(new_admin)

    new_device_id = UUID(str(uuid.uuid4()))
    secure_token = create_device_token(new_device_id)

    new_device = Device(
        id=new_device_id,
        organization_id=new_org.id,
        name=data.device_name,
        device_token_secret=secure_token,
    )
    db.add(new_device)

    await db.commit()

    return {
        "organization_id": new_org.id,
        "device_id": new_device.id,
        "device_token_secret": secure_token,
        "admin_email": new_admin.email,
        "message": "Organization, Device, and Admin user created successfully."
    }


# --- 3. Method to GET CURRENT USER PROFILE
@router.get("/users/me", response_model=UserProfileResponse)
async def read_users_me(
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """
    Retrieves profile data. Now fetches Organization Name for display.
    """
    # Fetch the organization details to get the name
    stmt = select(Organization).where(Organization.id == current_user.organization_id)
    result = await db.execute(stmt)
    org = result.scalars().first()

    org_name = org.name if org else "Unknown Organization"

    # Return structure matching UserProfileResponse
    return {
        "id": current_user.id,
        "username": current_user.username,
        "email": current_user.email,
        "phone_number": current_user.phone_number,
        "role": current_user.role,
        "organization_id": current_user.organization_id,
        "organization_name": org_name,
        "is_2fa_enabled": current_user.is_2fa_enabled
    }

# --- 4. Method to UPDATE USER PROFILE
@router.put("/users/me", response_model=UserProfileResponse)
async def update_user_me(
        user_update: UserUpdateSchema,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """
    Updates the authenticated user's profile info (Name, Email, Phone).
    """

    # 1. Update fields if provided
    if user_update.full_name is not None:
        current_user.username = user_update.full_name

    if user_update.phone_number is not None:
        # Ensure your User model has this column!
        current_user.phone_number = user_update.phone_number

    if user_update.email is not None and user_update.email != current_user.email:
        # Check if new email is already taken
        stmt = select(User).where(User.email == user_update.email)
        existing = (await db.execute(stmt)).scalars().first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="This email address is already in use."
            )
        current_user.email = user_update.email

    # 2. Commit Changes
    db.add(current_user)
    await db.commit()
    await db.refresh(current_user)

    # 3. Re-fetch Organization Name for response consistency
    stmt = select(Organization).where(Organization.id == current_user.organization_id)
    result = await db.execute(stmt)
    org = result.scalars().first()
    org_name = org.name if org else "Unknown Organization"

    return {
        "id": current_user.id,
        "username": current_user.username,
        "email": current_user.email,
        "phone_number": getattr(current_user, "phone_number", None),
        "role": current_user.role,
        "organization_id": current_user.organization_id,
        "organization_name": org_name,
        "is_2fa_enabled": current_user.is_2fa_enabled
    }

# --- 5. Method to CREATE USER (ADMIN ONLY)
@router.post("/users/create", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_new_user(
        new_user_data: UserCreate,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    if current_user.role != "GlobalAdmin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only Global Admins can create new user accounts."
        )

    user_exists_stmt = select(User).where(User.email == new_user_data.email.lower())
    if (await db.execute(user_exists_stmt)).scalar_one_or_none():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A user with this email already exists."
        )

    hashed_password = get_password_hash(new_user_data.password)

    new_user = User(
        organization_id=current_user.organization_id,
        username=new_user_data.username,
        email=new_user_data.email.lower(),
        password_hash=hashed_password,
        role=new_user_data.role,
        is_active=True
    )
    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)

    return new_user

# --- 6. Method for LISTING USERS
@router.get("/users/list", response_model=List[UserResponse])
async def list_organization_users(
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    stmt = select(User).where(
        User.organization_id == current_user.organization_id
    )
    result = await db.execute(stmt)
    users = result.scalars().all()

    return users


@router.put("/users/me/password", status_code=status.HTTP_200_OK)
async def update_user_password(
        password_data: UserPasswordUpdate,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db)
):
    """
    Updates the user's password after verifying the current one.
    """
    # 1. Verify Current Password
    if not verify_password(password_data.current_password, current_user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Incorrect current password."
        )

    # 2. Hash New Password
    new_hash = get_password_hash(password_data.new_password)

    # 3. Update User Record
    current_user.password_hash = new_hash
    db.add(current_user)
    await db.commit()

    return {"message": "Password updated successfully."}