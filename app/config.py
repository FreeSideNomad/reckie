"""Application configuration management."""
from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    """Application settings."""
    debug: bool = True
    secret_key: str = "your-secret-key-change-in-production"
    database_url: str = "postgresql://reckie:reckie_password@localhost:5432/reckie_db"
    openai_api_key: Optional[str] = None
    github_token: Optional[str] = None
    github_webhook_secret: Optional[str] = None

    model_config = {"env_file": ".env", "case_sensitive": False}

settings = Settings()