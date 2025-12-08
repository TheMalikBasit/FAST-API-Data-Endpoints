from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from datetime import timedelta
import uuid # <--- CRITICAL FIX: Import the module itself
from uuid import UUID # (This was the previous fix for the type hint)
from app.db.database import get_db
from app.models.user import User
from app.models.device import Device, Organization
from app.schemas.auth import Token, OrganizationRegister, OrganizationRegisterResponse
from app.schemas.user import UserResponse, UserCreate
from app.core.security import verify_password, create_access_token, get_password_hash, create_device_token
from app.core.dependencies import get_current_active_user
from app.core.config import settings

# Router definition
router = APIRouter(prefix="/auth", tags=["Authentication"])

# Expiration time for user tokens (e.g., 30 minutes)
ACCESS_TOKEN_EXPIRE_MINUTES = 30

@router.post("/token", response_model=Token)
async def login_for_access_token(
        form_data: OAuth2PasswordRequestForm = Depends(),
        db: AsyncSession = Depends(get_db)
):
    """
    Handles user login using standard OAuth2 (username/password) form data
    and returns an access token.
    """
    normalized_email = form_data.username.lower()
    print(normalized_email)
    # 1. Find the user by email (username)
    stmt = select(User).where(User.email == normalized_email)
    result = await db.execute(stmt)
    user = result.scalars().first()

    if not user or not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or inactive account",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # 2. Verify the password hash
    if not verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # 3. Create the JWT Access Token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

    # Token subject is the user's UUID
    access_token = create_access_token(
        subject=user.id,
        token_type="user", # Differentiates from 'device' tokens
        expires_delta=access_token_expires
    )

    return {"access_token": access_token, "token_type": "bearer"}

@router.post(
    "/register/organization",
    response_model=OrganizationRegisterResponse,
    status_code=status.HTTP_201_CREATED
)
async def register_organization(
        data: OrganizationRegister,
        db: AsyncSession = Depends(get_db)
):
    """
    Creates a new Organization, the first Global Admin user, and the associated
    Edge Device, all in one secure transaction.
    """

    # 0. Check if user already exists (prevent duplicate registration)
    user_exists_stmt = select(User).where(User.email == data.admin_email)
    if (await db.execute(user_exists_stmt)).scalar_one_or_none():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A user with this email already exists."
        )

    # 1. Create Organization
    new_org = Organization(name=data.organization_name, status="Active")
    db.add(new_org)
    await db.flush() # CRITICAL: Flushes to DB to generate the new_org.id

    # 2. Hash Password and Create Admin User
    hashed_password = get_password_hash(data.admin_password)
    new_admin = User(
        organization_id=new_org.id,
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

    await db.commit() # Final commit of all three records

    # 4. Return the secure token for the Edge PC deployment
    return {
        "organization_id": new_org.id,
        "device_id": new_device.id,
        "device_token_secret": secure_token,
        "admin_email": new_admin.email,
        "message": "Organization, Device, and Admin user created successfully."
    }

# Only Global Admin can add more users
@router.get("/users/me", response_model=UserResponse)
async def read_users_me(
        # The dependency validates the JWT and returns the fully loaded User ORM object
        current_user: User = Depends(get_current_active_user)
):
    """
    Retrieves the current authenticated user's data (used by the frontend context).
    """
    # The current_user object contains all necessary data (id, email, organization_id, role)
    return current_user

@router.post("/users/create", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_new_user(
        new_user_data: UserCreate,
        current_user: User = Depends(get_current_active_user), # Ensures protection
        db: AsyncSession = Depends(get_db)
):
    """
    Allows a Global Admin to create a new user account within their organization.
    """

    # 1. Authorization Check (Crucial for multi-tenancy)
    if current_user.role != "GlobalAdmin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only Global Admins can create new user accounts."
        )

    # 2. Check for duplicate email
    user_exists_stmt = select(User).where(User.email == new_user_data.email.lower())
    if (await db.execute(user_exists_stmt)).scalar_one_or_none():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A user with this email already exists."
        )

    # 3. Hash Password and Create User
    hashed_password = get_password_hash(new_user_data.password)

    new_user = User(
        # The new user MUST be linked to the admin's organization
        organization_id=current_user.organization_id,
        email=new_user_data.email.lower(),
        password_hash=hashed_password,
        role=new_user_data.role,
        is_active=True
    )
    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)

    return new_user