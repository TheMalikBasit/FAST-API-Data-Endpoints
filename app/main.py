import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from app.db.database import engine
from app.models.base import Base
from app.core.config import settings
from app.routers import devices, events, auth, config, analytics, media, cameras, capabilities


# --- Database Initialization ---
async def create_db_tables():
    """Creates all database tables defined by SQLAlchemy models."""
    print("Creation of Database Tables Started...")
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    print("Database Tables Created Successfully.")


# --- Lifespan Manager ---
@asynccontextmanager
async def lifespan(app: FastAPI):
    # 1. Startup Logic
    print("Application Startup: Checking resources...")

    # Ensure media directory exists for evidence storage
    os.makedirs("media", exist_ok=True)

    # Create tables (Dev only - Use Alembic in Prod)
    await create_db_tables()

    yield

    # 2. Shutdown Logic
    print("Application Shutdown: Closing connections.")


# --- App Definition ---
app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    lifespan=lifespan
)

# --- CORS Middleware ---
origins = [
    "http://localhost:3000",  # Local React/Next.js
    "http://127.0.0.1:3000",  # Localhost alternative
    "http://172.18.0.1:3000",  # Docker Host IP
    "*"  # Allow all (easiest for dev, restrict in prod)
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Router Registration ---
# All routers are grouped under /api/v1 for consistency
app.include_router(auth.router, prefix="/api/v1")
app.include_router(analytics.router, prefix="/api/v1")
app.include_router(media.router, prefix="/api/v1")
app.include_router(devices.router, prefix="/api/v1")
app.include_router(cameras.router, prefix="/api/v1")
app.include_router(capabilities.router, prefix="/api/v1")
app.include_router(events.router, prefix="/api/v1")
app.include_router(config.router, prefix="/api/v1")

@app.get("/")
async def root():
    return {
        "message": "Welcome to the Worker Safety Management System API v1.0",
        "status": "Online",
        "docs_url": "/docs"
    }