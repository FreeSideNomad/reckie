"""FastAPI application entry point."""
from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

from app.config import settings
from app.routes import main as main_routes

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

@app.get("/", response_class=HTMLResponse)
async def read_root(request: Request):
    """Hello World page."""
    return templates.TemplateResponse(
        request, "index.html", {"title": "Reckie - Hello World"}
    )

@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy", "version": "0.1.0"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=settings.debug,
        log_level="info"
    )