"""Pytest configuration and fixtures."""
import asyncio
import pytest
from fastapi.testclient import TestClient
from playwright.async_api import async_playwright

from app.main import app

@pytest.fixture
def client():
    """FastAPI test client."""
    return TestClient(app)

@pytest.fixture(scope="session")
def event_loop():
    """Create an instance of the default event loop for the test session."""
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()

@pytest.fixture(scope="session")
async def browser():
    """Browser instance for E2E tests."""
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        yield browser
        await browser.close()

@pytest.fixture
async def page(browser):
    """Page instance for E2E tests."""
    context = await browser.new_context()
    page = await context.new_page()
    yield page
    await context.close()