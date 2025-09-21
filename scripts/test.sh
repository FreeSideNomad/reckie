#!/bin/bash
set -e

echo "🧪 Running Reckie test suite..."
source .venv/bin/activate

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