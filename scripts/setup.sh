#!/bin/bash
set -e

# Source common utilities
source "$(dirname "$0")/common.sh"

echo "🚀 Setting up Reckie development environment..."

# Check dependencies
log_info "Checking dependencies..."
if ! check_dependencies "curl" "docker" "docker-compose"; then
    log_error "Missing required dependencies. Please install them and try again."
    exit 1
fi

# Check and install uv if needed
if ! command_exists uv; then
    log_info "Installing uv package manager..."
    if ! check_dependencies "uv"; then
        log_error "Failed to install uv package manager"
        exit 1
    fi
fi

# Check Docker
if ! check_docker; then
    log_error "Docker is required for development"
    exit 1
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