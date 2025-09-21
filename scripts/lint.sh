#!/bin/bash
set -e

echo "🔍 Running code quality checks..."
source .venv/bin/activate

echo "Formatting code with black..."
black app/ tests/

echo "Sorting imports with isort..."
isort app/ tests/

echo "Linting with flake8..."
flake8 app/ tests/

echo "Type checking with mypy..."
mypy app/

echo "✅ Code quality checks complete!"