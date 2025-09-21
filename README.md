# Reckie - AI-Native Requirements Engineering Platform

A modern platform for AI-assisted software development workflows with comprehensive requirements management.

## Quick Start

### Prerequisites
- Python 3.11+
- Docker and Docker Compose
- Git

### Setup
```bash
# Clone repository
git clone https://github.com/FreeSideNomad/reckie.git
cd reckie

# Run setup script
chmod +x scripts/*.sh
./scripts/setup.sh
```

### Development
```bash
# Start development server
./scripts/dev.sh

# Run tests
./scripts/test.sh

# Code quality checks
./scripts/lint.sh
```

### Accessing the Application
- **Web Application**: http://localhost:8000
- **API Documentation**: http://localhost:8000/api/docs
- **Database**: localhost:5432 (reckie/reckie_password)

## Development Commands

| Command | Description |
|---------|-------------|
| `./scripts/setup.sh` | Initial environment setup |
| `./scripts/dev.sh` | Start development server |
| `./scripts/test.sh` | Run complete test suite |
| `./scripts/lint.sh` | Code quality checks |
| `uv pip install -e ".[dev]"` | Install dependencies |
| `docker-compose -f docker/docker-compose.yml up -d` | Start services |

## Testing

### Unit Tests
```bash
pytest tests/unit/ -v
```

### Integration Tests
```bash
pytest tests/integration/ -v
```

### E2E Tests
```bash
pytest tests/e2e/ -v
```

### Coverage Report
```bash
coverage run -m pytest tests/
coverage report
coverage html  # View in htmlcov/index.html
```

## Project Structure

```
reckie/
├── app/                    # Main application
├── tests/                  # Test suite
├── scripts/                # Utility scripts
├── docker/                 # Docker configuration
├── .github/workflows/      # CI/CD pipelines
└── docs/                   # Documentation
```

## Technology Stack

- **Backend**: FastAPI, Python 3.11
- **Database**: PostgreSQL with pgvector
- **Frontend**: Jinja2 templates, HTML/CSS/JS
- **Testing**: Pytest, Playwright
- **Package Management**: uv
- **Containerization**: Docker
- **CI/CD**: GitHub Actions

## Contributing

1. Create feature branch
2. Make changes
3. Run tests: `./scripts/test.sh`
4. Run quality checks: `./scripts/lint.sh`
5. Submit pull request

## License

MIT License - see LICENSE file for details.