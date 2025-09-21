# Reckie Development Scripts

This directory contains automated scripts for the Reckie development workflow, all enhanced with intelligent dependency checking and automatic installation capabilities.

## 🔧 Features

### Automatic Dependency Management
All scripts now include:
- **Smart dependency detection** - Automatically checks for required tools before execution
- **Cross-platform installation** - Supports macOS (Homebrew), Linux (apt/yum/dnf/pacman), and Windows (Chocolatey/winget)
- **Intelligent error handling** - Provides specific installation instructions for missing tools
- **GitHub CLI authentication** - Automatic authentication prompts when needed

### Common Dependencies Checked
- `git` - Version control
- `gh` - GitHub CLI for repository operations
- `jq` - JSON processing for GitHub API responses
- `curl` - HTTP requests and downloads
- `docker` & `docker-compose` - Container orchestration
- `python3` - Python runtime
- `uv` - Modern Python package manager

## 📁 Scripts Overview

### `common.sh`
Shared utility functions used by all scripts:
- `check_dependencies()` - Validates and installs required tools
- `check_gh_auth()` - Ensures GitHub CLI authentication
- `check_venv()` - Sets up Python virtual environment
- `check_docker()` - Validates Docker daemon status
- Cross-platform package installation functions

### `setup.sh`
Initial development environment setup:
- **Dependencies**: `curl`, `docker`, `docker-compose`, `uv`
- Creates virtual environment
- Installs Python dependencies
- Configures Docker services
- Sets up Playwright browsers

### `dev.sh`
Development server with auto-browser opening:
- **Dependencies**: `docker`, `docker-compose`, `curl`
- Starts Docker services
- Launches FastAPI server
- Opens browser automatically when ready
- Cross-platform browser detection

### `lint.sh`
Code quality enforcement:
- **Dependencies**: `python3`
- Runs Black formatter
- Sorts imports with isort
- Validates with flake8
- Type checks with mypy

### `test.sh`
Comprehensive testing suite:
- **Dependencies**: `docker`, `docker-compose`, `python3`
- Unit, integration, and E2E tests
- Coverage reporting
- Docker service orchestration

### `commit-and-push.sh`
Intelligent commit automation with CI/CD monitoring:
- **Dependencies**: `git`, `gh`, `jq`, `curl`
- Smart commit message generation
- GitHub Actions monitoring
- Automatic issue creation for failures
- Intelligent error fixing and retry logic
- **Requires GitHub CLI authentication**

### `deploy.sh`
Production deployment with pre-flight checks:
- **Dependencies**: `git`, `gh`, `jq`, `curl`
- Pre-deployment validation
- Branch management
- Integration with commit-and-push script

## 🚀 Usage

### First Time Setup
```bash
# Run setup once to install everything
./scripts/setup.sh

# The script will automatically:
# - Check for required tools (curl, docker, docker-compose, uv)
# - Install missing dependencies using your system's package manager
# - Set up Python virtual environment
# - Install project dependencies
# - Configure Docker services
```

### Daily Development
```bash
# Start development server (auto-opens browser)
./scripts/dev.sh

# Run code quality checks
./scripts/lint.sh

# Run test suite
./scripts/test.sh

# Intelligent commit and push with CI/CD monitoring
./scripts/commit-and-push.sh "your commit message"

# Deploy to production
./scripts/deploy.sh
```

### Dependency Resolution

If any script encounters missing dependencies, it will:

1. **Detect missing tools** and display a warning
2. **Attempt automatic installation** using your system's package manager:
   - **macOS**: Homebrew (`brew install`)
   - **Linux**: apt-get, yum, dnf, or pacman
   - **Windows**: Chocolatey or winget
3. **Provide manual installation instructions** if automatic installation fails
4. **Verify installation** before proceeding

### GitHub CLI Authentication

For scripts requiring GitHub operations (`commit-and-push.sh`, `deploy.sh`):

```bash
# Authenticate if not already done
gh auth login

# Scripts will prompt for authentication if needed
```

## 🔍 Troubleshooting

### Package Manager Not Found
If automatic installation fails due to missing package managers:

**macOS**: Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Linux**: Most distributions include a supported package manager by default

**Windows**: Install Chocolatey
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### Docker Issues
```bash
# Start Docker daemon
# macOS/Windows: Start Docker Desktop
# Linux: sudo systemctl start docker

# Check Docker status
docker info
```

### Virtual Environment Issues
```bash
# Recreate virtual environment
rm -rf .venv
./scripts/setup.sh
```

### GitHub CLI Issues
```bash
# Re-authenticate
gh auth logout
gh auth login

# Check authentication status
gh auth status
```

## 🔄 Development Workflow

The recommended workflow with dependency management:

1. **Initial Setup**: Run `./scripts/setup.sh` once
2. **Development**: Use `./scripts/dev.sh` to start coding
3. **Quality Assurance**: Run `./scripts/lint.sh` and `./scripts/test.sh`
4. **Commit**: Use `./scripts/commit-and-push.sh` for intelligent automation
5. **Deploy**: Use `./scripts/deploy.sh` for production releases

Each script will automatically verify dependencies and guide you through any required installations, ensuring a smooth development experience regardless of your system configuration.

## 📊 Dependency Matrix

| Script | git | gh | jq | curl | docker | docker-compose | python3 | uv |
|--------|-----|----|----|------|--------|----------------|---------|-----|
| setup.sh | ✓ | | | ✓ | ✓ | ✓ | ✓ | ✓ |
| dev.sh | | | | ✓ | ✓ | ✓ | ✓ | |
| lint.sh | | | | | | | ✓ | |
| test.sh | | | | | ✓ | ✓ | ✓ | |
| commit-and-push.sh | ✓ | ✓ | ✓ | ✓ | | | | |
| deploy.sh | ✓ | ✓ | ✓ | ✓ | | | | |

✓ = Required dependency, automatically checked and installed if missing