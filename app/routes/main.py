"""Main application routes."""

from typing import Dict

from fastapi import APIRouter, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

router = APIRouter()
templates = Jinja2Templates(directory="app/templates")


@router.get("/api/status")
async def api_status() -> Dict[str, str]:
    """API status endpoint."""
    return {"status": "operational", "service": "reckie-api"}


@router.get("/projects", response_class=HTMLResponse)
async def projects_page(request: Request) -> HTMLResponse:
    """Projects management page."""
    return templates.TemplateResponse(
        request, "projects.html", {"title": "Projects - Reckie"}
    )


@router.get("/requirements", response_class=HTMLResponse)
async def requirements_page(request: Request) -> HTMLResponse:
    """Requirements management page."""
    return templates.TemplateResponse(
        request, "requirements.html", {"title": "Requirements - Reckie"}
    )


@router.get("/ai-analysis", response_class=HTMLResponse)
async def ai_analysis_page(request: Request) -> HTMLResponse:
    """AI Analysis page."""
    return templates.TemplateResponse(
        request, "ai-analysis.html", {"title": "AI Analysis - Reckie"}
    )


@router.get("/smart-generation", response_class=HTMLResponse)
async def smart_generation_page(request: Request) -> HTMLResponse:
    """Smart Generation page."""
    return templates.TemplateResponse(
        request,
        "smart-generation.html",
        {"title": "Smart Generation - Reckie"},
    )


@router.get("/validation", response_class=HTMLResponse)
async def validation_page(request: Request) -> HTMLResponse:
    """Validation tools page."""
    return templates.TemplateResponse(
        request, "validation.html", {"title": "Validation - Reckie"}
    )


@router.get("/analytics", response_class=HTMLResponse)
async def analytics_page(request: Request) -> HTMLResponse:
    """Analytics and reports page."""
    return templates.TemplateResponse(
        request, "analytics.html", {"title": "Analytics - Reckie"}
    )


@router.get("/exports", response_class=HTMLResponse)
async def exports_page(request: Request) -> HTMLResponse:
    """Data exports page."""
    return templates.TemplateResponse(
        request, "exports.html", {"title": "Exports - Reckie"}
    )


@router.get("/profile", response_class=HTMLResponse)
async def profile_page(request: Request) -> HTMLResponse:
    """User profile page."""
    return templates.TemplateResponse(
        request, "profile.html", {"title": "Profile - Reckie"}
    )


@router.get("/settings", response_class=HTMLResponse)
async def settings_page(request: Request) -> HTMLResponse:
    """Settings page."""
    return templates.TemplateResponse(
        request, "settings.html", {"title": "Settings - Reckie"}
    )
