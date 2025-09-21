#!/bin/bash
set -e

# Source common utilities
source "$(dirname "$0")/common.sh"

echo "🧪 Running Reckie test suite..."

# Check dependencies
log_info "Checking dependencies..."
if ! check_dependencies "docker" "docker-compose" "python3"; then
    log_error "Missing required dependencies. Please install them and try again."
    exit 1
fi

# Check and setup virtual environment
if ! check_venv; then
    log_error "Failed to setup virtual environment"
    exit 1
fi

# Check Docker
if ! check_docker; then
    log_error "Docker is required for testing"
    exit 1
fi

docker-compose -f docker/docker-compose.yml up -d db

echo "Running unit tests..."
pytest tests/unit/ -v

echo "Running integration tests..."
pytest tests/integration/ -v

echo "Starting application for E2E tests..."
uvicorn app.main:app --host 0.0.0.0 --port 8000 &
APP_PID=$!
sleep 5

echo "Running E2E tests..."
pytest tests/e2e/ -v

kill $APP_PID

echo "Generating coverage report..."
coverage run -m pytest tests/
coverage report
coverage html

echo "✅ All tests completed!"