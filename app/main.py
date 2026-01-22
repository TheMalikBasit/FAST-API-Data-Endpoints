from fastapi import FastAPI
from contextlib import asynccontextmanager
from app.db.database import engine
from app.models.base import Base # Import Base for table creation (development only)
from app.core.config import settings
from starlette.middleware.cors import CORSMiddleware
from app.routers import devices, events, auth, config, analytics
# This block is for development purposes only.
# In production, you would use Alembic for migrations.
async def create_db_tables():
    """Creates all database tables defined by SQLAlchemy models."""
    async with engine.begin() as conn:
        # Use run_sync because metadata operations are synchronous in nature
        await conn.run_sync(Base.metadata.create_all)


# Define a lifespan context manager to run code on startup and shutdown
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Code to run ON STARTUP
    print("Application Startup: Creating database tables...")
    # WARNING: Do NOT use create_db_tables() in production. Use Alembic migrations.
    await create_db_tables()

    yield

    # Code to run ON SHUTDOWN (optional)
    print("Application Shutdown: Database connection pool is closing.")


app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    lifespan=lifespan # Attach the startup/shutdown logic
)

# --- CRITICAL FIX: Add CORS Middleware ---
# Define the origins that are allowed to make requests to this API.
# Allow requests from the Next.js development server (port 3000).
origins = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    # Allow the specific IP of the host machine within the Docker network range
    "http://172.18.0.1",
    "http://172.0.0.0/8", # Broadly allows all internal Docker addresses (Safest for local dev)
    # Allows the port that the container might see traffic coming from
    "http://172.18.0.1:3000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,                       # List of allowed origins
    allow_credentials=True,                      # Allow cookies/authorization headers
    allow_methods=["*"],                         # Allow all methods (POST, GET, etc.)
    allow_headers=["*"],                         # Allow all headers (Authorization, Content-Type, etc.)
)
# ----------------------------------------

# Include the routers to activate the endpoints
app.include_router(devices.router, prefix="/api/v1")
app.include_router(events.router, prefix="/api/v1")
app.include_router(auth.router, prefix="/api/v1")
app.include_router(config.router, prefix="/api/v1")
app.include_router(analytics.router, prefix="/api/v1")
@app.get("/")
async def root():
    return {"message": "Welcome to the PPE Detection API v1.0"}