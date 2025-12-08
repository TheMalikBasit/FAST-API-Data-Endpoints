import uuid
from datetime import datetime
from sqlalchemy import Column, DateTime, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import declarative_base

# Define the base class for declarative class definitions
Base = declarative_base()

class BaseModel(Base):
    """
    Base class which provides automated id, created_at, and updated_at columns.
    It also forces the use of UUIDs for primary keys.
    """
    __abstract__ = True # Prevents SQLAlchemy from trying to create a table for this class

    # Primary Key - Uses PostgreSQL's UUID type and Python's uuid.uuid4 to generate a default value
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        unique=True,
        nullable=False
    )

    # Audit timestamps
    created_at = Column(
        DateTime(timezone=True),
        default=func.now(),
        nullable=False
    )

    updated_at = Column(
        DateTime(timezone=True),
        default=func.now(),
        onupdate=func.now(),
        nullable=False
    )

from . import user           # Imports User model
from . import device         # Imports Organization and Device models
from . import camera         # Imports Camera and CameraRule models
from . import violation      # Imports Violation model