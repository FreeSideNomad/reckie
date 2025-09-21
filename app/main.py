"""FastAPI application entry point."""

from typing import Dict

from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from app.config import settings
from app.routes import main as main_routes
from app.routes import chat

app = FastAPI(
    title="Reckie - AI-Native Requirements Engineering Platform",
    description="Platform for AI-native software development workflows",
    version="0.1.0",
    docs_url="/api/docs" if settings.debug else None,
    redoc_url="/api/redoc" if settings.debug else None,
)

# Static files and templates
app.mount("/static", StaticFiles(directory="app/static"), name="static")
templates = Jinja2Templates(directory="app/templates")

# Include routes
app.include_router(main_routes.router)
app.include_router(chat.router)


@app.get("/", response_class=HTMLResponse, name="home")
async def read_root(request: Request) -> HTMLResponse:
    """Dashboard home page."""
    return templates.TemplateResponse(
        request, "index.html", {"title": "Reckie - Dashboard"}
    )


@app.get("/health")
async def health_check() -> Dict[str, str]:
    """Health check endpoint."""
    return {"status": "healthy", "version": "0.1.0"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=settings.debug,
        log_level="info",
    )
