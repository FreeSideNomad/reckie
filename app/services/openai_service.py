"""OpenAI API service using configured environment variables."""

from typing import List, Optional

import httpx

from app.config import settings


class OpenAIService:
    """Service for interacting with OpenAI API."""

    def __init__(self):
        """Initialize OpenAI service with configured API key."""
        self.api_key = settings.openai_api_key
        self.base_url = "https://api.openai.com/v1"

    async def get_models(self) -> Optional[List[str]]:
        """Get available OpenAI models."""
        if not self.api_key:
            raise ValueError("OpenAI API key not configured")

        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
        }

        async with httpx.AsyncClient() as client:
            response = await client.get(f"{self.base_url}/models", headers=headers)
            response.raise_for_status()
            data = response.json()
            return [model["id"] for model in data.get("data", [])]

    async def generate_completion(
        self, prompt: str, model: str = "gpt-3.5-turbo"
    ) -> Optional[str]:
        """Generate completion using OpenAI API."""
        if not self.api_key:
            raise ValueError("OpenAI API key not configured")

        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
        }

        payload = {
            "model": model,
            "messages": [{"role": "user", "content": prompt}],
            "max_tokens": 150,
        }

        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{self.base_url}/chat/completions", headers=headers, json=payload
            )
            response.raise_for_status()
            data = response.json()
            return data["choices"][0]["message"]["content"]
