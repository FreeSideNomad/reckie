"""Integration tests for API endpoints."""

from fastapi.testclient import TestClient


def test_api_status_endpoint(client: TestClient):
    """Test API status endpoint."""
    response = client.get("/api/status")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "operational"
    assert data["service"] == "reckie-api"
