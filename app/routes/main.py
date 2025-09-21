"""Main application routes."""

from fastapi import APIRouter

router = APIRouter()


@router.get("/api/status")
async def api_status():
    """API status endpoint."""
    return {"status": "operational", "service": "reckie-api"}
