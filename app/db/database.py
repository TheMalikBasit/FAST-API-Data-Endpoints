from typing import AsyncGenerator
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import sessionmaker
from app.core.config import settings

# 1. Database Engine: The factory for database connections.
# create_async_engine is required for async operation.
# echo=True is helpful for debugging (prints SQL queries to console).
engine = create_async_engine(
    settings.DATABASE_URL,
    echo=False,
    pool_pre_ping=True
)

# 2. Session Factory: Creates new asynchronous sessions bound to the engine.
# expire_on_commit=False is important: keeps ORM objects accessible after commit.
AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autoflush=False # Controls when changes are written to the database
)

# 3. Dependency Function (The FastAPI connection hook)
async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """
    Dependency function that yields an async database session for FastAPI routes.
    It manages the entire session lifecycle automatically.
    """
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()