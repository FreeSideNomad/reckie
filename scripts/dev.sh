#!/bin/bash
set -e

echo "🚀 Starting Reckie development server..."
source .venv/bin/activate

if ! docker-compose -f docker/docker-compose.yml ps | grep -q "Up"; then
    echo "Starting Docker services..."
    docker-compose -f docker/docker-compose.yml up -d
fi

uvicorn app.main:app --reload --host 0.0.0.0 --port 8000