"""GitHub API service using configured environment variables."""

from typing import Any, Dict, Optional

import httpx

from app.config import settings


class GitHubService:
    """Service for interacting with GitHub API."""

    def __init__(self):
        """Initialize GitHub service with configured token."""
        self.token = settings.github_token
        self.base_url = "https://api.github.com"

    async def get_user_info(self) -> Optional[Dict[str, Any]]:
        """Get authenticated user information."""
        if not self.token:
            raise ValueError("GitHub token not configured")

        headers = {
            "Authorization": f"Bearer {self.token}",
            "Accept": "application/vnd.github.v3+json",
        }

        async with httpx.AsyncClient() as client:
            response = await client.get(f"{self.base_url}/user", headers=headers)
            response.raise_for_status()
            return response.json()

    async def get_repository_info(
        self, owner: str, repo: str
    ) -> Optional[Dict[str, Any]]:
        """Get repository information."""
        if not self.token:
            raise ValueError("GitHub token not configured")

        headers = {
            "Authorization": f"Bearer {self.token}",
            "Accept": "application/vnd.github.v3+json",
        }

        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{self.base_url}/repos/{owner}/{repo}", headers=headers
            )
            response.raise_for_status()
            return response.json()
