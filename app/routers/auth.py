from fastapi import APIRouter, Depends, HTTPException, status, BackgroundTasks
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from datetime import timedelta, datetime
import uuid
from uuid import UUID
from typing import Union, List, Optional
from app.db.database import get_db
from app.models.user import User
from app.core.activity_logger import log_activity
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
    UserPasswordUpdate,
    AdminUserUpdateSchema
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
        db: AsyncSession = Depends(get_db),
        background_tasks: BackgroundTasks = BackgroundTasks(),
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

    # Log successful login
    background_tasks.add_task(
        log_activity,
        organization_id=user.organization_id,
        user_id=user.id,
        action="USER_LOGIN",
        details={"actor_email": user.email, "actor_name": user.username, "method": "standard"},
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
        db: AsyncSession = Depends(get_db),
        background_tasks: BackgroundTasks = BackgroundTasks(),
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

    # Log successful 2FA login
    background_tasks.add_task(
        log_activity,
        organization_id=user.organization_id,
        user_id=user.id,
        action="USER_LOGIN",
        details={"actor_email": user.email, "actor_name": user.username, "method": "2fa"},
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
    # 1. Create Organization
    new_org = Organization(name=data.organization_name, status="Active")
    db.add(new_org)
    await db.flush()

    # 2. Hash Password and Create Admin User
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

    # 3. Create Edge Device and Token
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
        "message": "Organization created successfully."
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

# --- 4. Method to UPDATE USER PROFILE (ADMIN ONLY)
@router.put("/users/me", response_model=UserProfileResponse)
async def update_user_me(
        user_update: UserUpdateSchema,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db),
        background_tasks: BackgroundTasks = BackgroundTasks(),
):
    """
    Updates the authenticated user's profile info (Name, Email, Phone).
    Restricted to GlobalAdmin only.
    """
    if current_user.role != "GlobalAdmin":
        raise HTTPException(status_code=403, detail="Only Global Admins can update profile details.")

    # Track changes for logging
    changes = {}

    # 1. Update fields if provided
    if user_update.full_name is not None and user_update.full_name != current_user.username:
        changes["username"] = {"old": current_user.username, "new": user_update.full_name}
        current_user.username = user_update.full_name

    if user_update.phone_number is not None and user_update.phone_number != current_user.phone_number:
        changes["phone_number"] = {"old": current_user.phone_number, "new": user_update.phone_number}
        current_user.phone_number = user_update.phone_number

    if user_update.email is not None and user_update.email != current_user.email:
        # Check if new email is already taken in this org
        stmt = select(User).where(
            User.email == user_update.email,
            User.organization_id == current_user.organization_id,
        )
        existing = (await db.execute(stmt)).scalars().first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="This email address is already in use."
            )
        changes["email"] = {"old": current_user.email, "new": user_update.email}
        current_user.email = user_update.email

    # 2. Commit Changes
    db.add(current_user)
    await db.commit()
    await db.refresh(current_user)

    # 3. Log if something changed
    if changes:
        background_tasks.add_task(
            log_activity,
            organization_id=current_user.organization_id,
            user_id=current_user.id,
            action="USER_PROFILE_UPDATED",
            details={
                "actor_email": current_user.email,
                "actor_name": current_user.username,
                "changes": changes,
            },
        )

    # 4. Re-fetch Organization Name for response consistency
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
        db: AsyncSession = Depends(get_db),
        background_tasks: BackgroundTasks = BackgroundTasks(),
):
    if current_user.role != "GlobalAdmin":
        raise HTTPException(status_code=403, detail="Only Global Admins can create users.")

    # UPDATED: Check for duplicate email ONLY in the current organization
    user_exists_stmt = select(User).where(
        (User.email == new_user_data.email.lower()) &
        (User.organization_id == current_user.organization_id)
    )

    if (await db.execute(user_exists_stmt)).scalar_one_or_none():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A user with this email already exists in this organization."
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

    # Log user creation
    background_tasks.add_task(
        log_activity,
        organization_id=current_user.organization_id,
        user_id=current_user.id,
        action="USER_ADDED",
        details={
            "actor_email": current_user.email,
            "actor_name": current_user.username,
            "target_user_email": new_user.email,
            "target_user_name": new_user.username,
            "target_user_role": new_user.role,
        },
    )

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
        db: AsyncSession = Depends(get_db),
        background_tasks: BackgroundTasks = BackgroundTasks(),
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

    # 4. Log password change
    background_tasks.add_task(
        log_activity,
        organization_id=current_user.organization_id,
        user_id=current_user.id,
        action="USER_PASSWORD_CHANGED",
        details={
            "actor_email": current_user.email,
            "actor_name": current_user.username,
        },
    )

    return {"message": "Password updated successfully."}


# --- 8. Method to DELETE USER (ADMIN ONLY, HARD DELETE) ---
@router.delete("/users/{user_id}", status_code=status.HTTP_200_OK)
async def delete_user(
        user_id: UUID,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db),
        background_tasks: BackgroundTasks = BackgroundTasks(),
):
    """
    Hard-deletes a user from the organization. GlobalAdmin only.
    Admins can delete other admins. Cannot delete yourself.
    """
    if current_user.role != "GlobalAdmin":
        raise HTTPException(status_code=403, detail="Only Global Admins can remove users.")

    if user_id == current_user.id:
        raise HTTPException(status_code=400, detail="You cannot delete yourself.")

    # Fetch target user — must be in same org
    stmt = select(User).where(
        User.id == user_id,
        User.organization_id == current_user.organization_id,
    )
    target_user = (await db.execute(stmt)).scalars().first()

    if not target_user:
        raise HTTPException(status_code=404, detail="User not found in your organization.")

    # Capture info before deletion for the log
    target_email = target_user.email
    target_name = target_user.username
    target_role = target_user.role

    await db.delete(target_user)
    await db.commit()

    # Log user removal
    background_tasks.add_task(
        log_activity,
        organization_id=current_user.organization_id,
        user_id=current_user.id,
        action="USER_REMOVED",
        details={
            "actor_email": current_user.email,
            "actor_name": current_user.username,
            "target_user_email": target_email,
            "target_user_name": target_name,
            "target_user_role": target_role,
        },
    )

    return {"message": f"User {target_email} has been permanently removed."}


# --- 9. Method to UPDATE USER DETAILS (ADMIN ONLY) ---
@router.put("/users/{user_id}", response_model=UserResponse)
async def admin_update_user(
        user_id: UUID,
        update_data: AdminUserUpdateSchema,
        current_user: User = Depends(get_current_active_user),
        db: AsyncSession = Depends(get_db),
        background_tasks: BackgroundTasks = BackgroundTasks(),
):
    """
    Admin updates another user's details (name, email, phone, role).
    GlobalAdmin only. Target must be in same org.
    """
    if current_user.role != "GlobalAdmin":
        raise HTTPException(status_code=403, detail="Only Global Admins can update user details.")

    # Fetch target user in same org
    stmt = select(User).where(
        User.id == user_id,
        User.organization_id == current_user.organization_id,
    )
    target_user = (await db.execute(stmt)).scalars().first()

    if not target_user:
        raise HTTPException(status_code=404, detail="User not found in your organization.")

    # Track changes
    changes = {}

    if update_data.username is not None and update_data.username != target_user.username:
        changes["username"] = {"old": target_user.username, "new": update_data.username}
        target_user.username = update_data.username

    if update_data.phone_number is not None and update_data.phone_number != target_user.phone_number:
        changes["phone_number"] = {"old": target_user.phone_number, "new": update_data.phone_number}
        target_user.phone_number = update_data.phone_number

    if update_data.role is not None and update_data.role != target_user.role:
        changes["role"] = {"old": target_user.role, "new": update_data.role}
        target_user.role = update_data.role

    if update_data.email is not None and update_data.email.lower() != target_user.email:
        # Check email uniqueness within org
        email_stmt = select(User).where(
            User.email == update_data.email.lower(),
            User.organization_id == current_user.organization_id,
        )
        if (await db.execute(email_stmt)).scalars().first():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="This email address is already in use in this organization."
            )
        changes["email"] = {"old": target_user.email, "new": update_data.email.lower()}
        target_user.email = update_data.email.lower()

    db.add(target_user)
    await db.commit()
    await db.refresh(target_user)

    # Log only if something actually changed
    if changes:
        background_tasks.add_task(
            log_activity,
            organization_id=current_user.organization_id,
            user_id=current_user.id,
            action="USER_DETAILS_UPDATED",
            details={
                "actor_email": current_user.email,
                "actor_name": current_user.username,
                "target_user_id": str(target_user.id),
                "target_user_email": target_user.email,
                "target_user_name": target_user.username,
                "changes": changes,
            },
        )

    return target_user