#!/bin/bash
set -e

# Source common utilities
source "$(dirname "$0")/common.sh"

echo "🔍 Running code quality checks..."

# Check dependencies
log_info "Checking dependencies..."
if ! check_dependencies "python3"; then
    log_error "Missing required dependencies. Please install them and try again."
    exit 1
fi

# Check and setup virtual environment
if ! check_venv; then
    log_error "Failed to setup virtual environment"
    exit 1
fi

echo "Formatting code with black..."
black app/ tests/

echo "Sorting imports with isort..."
isort app/ tests/

echo "Linting with flake8..."
flake8 app/ tests/

echo "Type checking with mypy..."
mypy app/

echo "✅ Code quality checks complete!"