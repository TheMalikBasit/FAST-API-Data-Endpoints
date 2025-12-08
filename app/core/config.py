from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict

# Ensure you run 'pip install pydantic-settings' if you haven't yet

class Settings(BaseSettings):
    """
    Application settings class. Reads environment variables first, then .env file.

    Fields are named in lowercase (Python convention), but Pydantic Settings
    will look for uppercase ENV vars (e.g., POSTGRES_USER).
    """

    # --- Project Metadata ---
    PROJECT_NAME: str = "PPE Violation Detection API"
    VERSION: str = "1.0.0"

    # --- Database Settings ---
    POSTGRES_USER: str
    POSTGRES_PASSWORD: str
    POSTGRES_SERVER: str
    POSTGRES_PORT: int = 5432
    POSTGRES_DB: str

    # The final DATABASE_URL constructed from the fields above.
    @property
    def DATABASE_URL(self) -> str:
        # The 'postgresql+asyncpg' prefix is essential for async SQLAlchemy
        return (
            f"postgresql+asyncpg://{self.POSTGRES_USER}:{self.POSTGRES_PASSWORD}"
            f"@{self.POSTGRES_SERVER}:{self.POSTGRES_PORT}/{self.POSTGRES_DB}"
        )

    # --- Security/JWT Settings ---
    SECRET_KEY: str
    # Algorithm used for JWT encoding (e.g., for device authentication)
    ALGORITHM: str = "HS256"

    # Pydantic Settings configuration: tells it where to look for .env files
    model_config = SettingsConfigDict(
        # Read environment variables from a .env file located in the project root
        env_file=".env",
        env_file_encoding='utf-8',
        # Allows fields to be accessed like attributes (e.g., settings.DATABASE_URL)
        case_sensitive=True
    )

@lru_cache()
def get_settings() -> Settings:
    """
    Returns a cached instance of the Settings object.
    Ensures settings are loaded only once per application run.
    """
    return Settings()

settings = get_settings()