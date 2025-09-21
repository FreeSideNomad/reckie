"""GitHub webhook validation service using configured secret."""

import hashlib
import hmac

from app.config import settings


class WebhookService:
    """Service for validating GitHub webhooks."""

    def __init__(self):
        """Initialize webhook service with configured secret."""
        self.secret = settings.github_webhook_secret

    def validate_signature(self, payload: bytes, signature: str) -> bool:
        """Validate GitHub webhook signature."""
        if not self.secret:
            raise ValueError("GitHub webhook secret not configured")

        # GitHub sends signature as 'sha256=<hash>'
        if not signature.startswith("sha256="):
            return False

        expected_signature = signature[7:]  # Remove 'sha256=' prefix

        # Generate HMAC signature
        mac = hmac.new(self.secret.encode("utf-8"), payload, hashlib.sha256)
        calculated_signature = mac.hexdigest()

        # Compare signatures using constant-time comparison
        return hmac.compare_digest(expected_signature, calculated_signature)

    def is_configured(self) -> bool:
        """Check if webhook secret is configured."""
        return self.secret is not None and len(self.secret) > 0
