#!/bin/bash
set -e

echo "🚀 Setting up Reckie development environment..."

if ! command -v uv &> /dev/null; then
    echo "Installing uv package manager..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source $HOME/.cargo/env
fi

echo "Creating virtual environment..."
uv venv
source .venv/bin/activate

echo "Installing dependencies..."
uv pip install -e ".[dev]"

echo "Installing Playwright browsers..."
playwright install

if [ ! -f .env ]; then
    echo "Creating .env file..."
    cp .env.example .env
fi

echo "Starting Docker services..."
docker-compose -f docker/docker-compose.yml up -d

echo "Waiting for database to be ready..."
sleep 10

echo "✅ Setup complete! Run './scripts/dev.sh' to start development server."