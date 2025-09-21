"""Application configuration management."""

from typing import Optional

from pydantic import Field
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings."""

    debug: bool = True
    secret_key: str = "your-secret-key-change-in-production"
    database_url: str = "postgresql://reckie:reckie_password@localhost:5432/reckie_db"
    openai_api_key: Optional[str] = Field(default=None, alias="OPENAI_API_KEY")
    github_token: Optional[str] = Field(default=None, alias="GITHUB_TOKEN")
    github_webhook_secret: Optional[str] = Field(
        default=None, alias="GITHUB_WEBHOOK_SECRET"
    )

    model_config = {
        "env_file": ".env",
        "case_sensitive": False,
        "populate_by_name": True,
    }


settings = Settings()
