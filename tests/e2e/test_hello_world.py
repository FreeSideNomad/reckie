"""End-to-end tests for hello world functionality."""

import pytest
from playwright.async_api import Page


@pytest.mark.asyncio
async def test_hello_world_page_loads(page: Page):
    """Test that hello world page loads correctly."""
    await page.goto("http://127.0.0.1:9000")
    title = await page.title()
    assert "Reckie" in title

    hello_message = page.locator('[data-testid="hello-world-message"]')
    await hello_message.wait_for()
    message_text = await hello_message.text_content()
    assert "System is running successfully" in message_text


@pytest.mark.asyncio
async def test_interactive_elements(page: Page):
    """Test interactive elements on the page."""
    await page.goto("http://127.0.0.1:9000")
    status_element = page.locator("#status")
    await status_element.click()
    background_color = await status_element.evaluate(
        "el => getComputedStyle(el).backgroundColor"
    )
    assert background_color == "rgb(204, 231, 255)"
