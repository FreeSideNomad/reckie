#!/bin/bash

# Common utilities for all scripts
# Source this file in other scripts with: source "$(dirname "$0")/common.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Function to detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*) echo "linux" ;;
        CYGWIN*|MINGW*|MSYS*) echo "windows" ;;
        *) echo "unknown" ;;
    esac
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install package using appropriate package manager
install_package() {
    local package="$1"
    local os=$(detect_os)

    log_info "Installing $package for $os..."

    case "$os" in
        "macos")
            if command_exists brew; then
                brew install "$package"
            else
                log_error "Homebrew not found. Please install Homebrew first: https://brew.sh"
                return 1
            fi
            ;;
        "linux")
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y "$package"
            elif command_exists yum; then
                sudo yum install -y "$package"
            elif command_exists dnf; then
                sudo dnf install -y "$package"
            elif command_exists pacman; then
                sudo pacman -S --noconfirm "$package"
            else
                log_error "No supported package manager found (apt-get, yum, dnf, pacman)"
                return 1
            fi
            ;;
        "windows")
            if command_exists choco; then
                choco install "$package" -y
            elif command_exists winget; then
                winget install "$package"
            else
                log_error "No supported package manager found (chocolatey, winget)"
                return 1
            fi
            ;;
        *)
            log_error "Unsupported operating system: $os"
            return 1
            ;;
    esac
}

# Function to install GitHub CLI
install_gh() {
    local os=$(detect_os)

    case "$os" in
        "macos")
            install_package "gh"
            ;;
        "linux")
            # Use official GitHub CLI installation method for Linux
            type -p curl >/dev/null || sudo apt install curl -y
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
            && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
            && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
            && sudo apt update \
            && sudo apt install gh -y
            ;;
        "windows")
            install_package "gh"
            ;;
        *)
            log_error "Unsupported OS for GitHub CLI installation"
            return 1
            ;;
    esac
}

# Function to check and install required tools
check_dependencies() {
    local tools=("$@")
    local missing_tools=()
    local installation_failed=()

    log_info "Checking dependencies: ${tools[*]}"

    # Check which tools are missing
    for tool in "${tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_tools+=("$tool")
        fi
    done

    # If all tools are available, return success
    if [ ${#missing_tools[@]} -eq 0 ]; then
        log_success "All required dependencies are available"
        return 0
    fi

    # Try to install missing tools
    log_warning "Missing dependencies: ${missing_tools[*]}"
    log_info "Attempting to install missing dependencies..."

    for tool in "${missing_tools[@]}"; do
        case "$tool" in
            "gh")
                if ! install_gh; then
                    installation_failed+=("$tool")
                fi
                ;;
            "jq"|"curl"|"git"|"docker"|"docker-compose")
                if ! install_package "$tool"; then
                    installation_failed+=("$tool")
                fi
                ;;
            "uv")
                if ! command_exists curl; then
                    log_error "curl is required to install uv"
                    installation_failed+=("$tool")
                else
                    log_info "Installing uv package manager..."
                    curl -LsSf https://astral.sh/uv/install.sh | sh
                    # Source the environment to make uv available
                    if [ -f "$HOME/.cargo/env" ]; then
                        source "$HOME/.cargo/env"
                    fi
                    # Add to PATH for current session
                    export PATH="$HOME/.cargo/bin:$PATH"
                    if ! command_exists uv; then
                        installation_failed+=("$tool")
                    fi
                fi
                ;;
            "python3"|"python")
                # Python installation is OS-specific and complex
                local os=$(detect_os)
                case "$os" in
                    "macos")
                        install_package "python3"
                        ;;
                    "linux")
                        install_package "python3"
                        ;;
                    "windows")
                        install_package "python"
                        ;;
                esac
                if ! command_exists python3 && ! command_exists python; then
                    installation_failed+=("$tool")
                fi
                ;;
            *)
                if ! install_package "$tool"; then
                    installation_failed+=("$tool")
                fi
                ;;
        esac

        # Verify installation
        if command_exists "$tool"; then
            log_success "Successfully installed $tool"
        fi
    done

    # Check for any remaining failures
    if [ ${#installation_failed[@]} -gt 0 ]; then
        log_error "Failed to install: ${installation_failed[*]}"
        log_error "Please install these tools manually:"
        for tool in "${installation_failed[@]}"; do
            case "$tool" in
                "gh")
                    log_error "  GitHub CLI: https://cli.github.com/"
                    ;;
                "jq")
                    log_error "  jq: https://stedolan.github.io/jq/download/"
                    ;;
                "docker")
                    log_error "  Docker: https://docs.docker.com/get-docker/"
                    ;;
                "docker-compose")
                    log_error "  Docker Compose: https://docs.docker.com/compose/install/"
                    ;;
                "uv")
                    log_error "  uv: https://docs.astral.sh/uv/getting-started/installation/"
                    ;;
                *)
                    log_error "  $tool: Please check your package manager or official website"
                    ;;
            esac
        done
        return 1
    fi

    log_success "All dependencies are now available"
    return 0
}

# Function to check GitHub CLI authentication
check_gh_auth() {
    if ! command_exists gh; then
        log_error "GitHub CLI (gh) is not installed"
        return 1
    fi

    if ! gh auth status >/dev/null 2>&1; then
        log_warning "GitHub CLI is not authenticated"
        log_info "Please run 'gh auth login' to authenticate with GitHub"

        # Offer to authenticate automatically
        read -p "Would you like to authenticate now? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            gh auth login
            if gh auth status >/dev/null 2>&1; then
                log_success "GitHub CLI authenticated successfully"
                return 0
            else
                log_error "GitHub CLI authentication failed"
                return 1
            fi
        else
            log_warning "Continuing without GitHub CLI authentication"
            return 1
        fi
    fi

    log_success "GitHub CLI is authenticated"
    return 0
}

# Function to check virtual environment
check_venv() {
    if [ ! -d ".venv" ]; then
        log_warning "Virtual environment not found"
        if command_exists uv; then
            log_info "Creating virtual environment with uv..."
            uv venv
        elif command_exists python3; then
            log_info "Creating virtual environment with python3..."
            python3 -m venv .venv
        else
            log_error "Cannot create virtual environment: no Python found"
            return 1
        fi
    fi

    # Activate virtual environment
    if [ -f ".venv/bin/activate" ]; then
        source .venv/bin/activate
        log_success "Virtual environment activated"
    else
        log_error "Virtual environment activation script not found"
        return 1
    fi

    return 0
}

# Function to check Docker services
check_docker() {
    if ! command_exists docker; then
        log_error "Docker is not installed"
        return 1
    fi

    if ! docker info >/dev/null 2>&1; then
        log_error "Docker daemon is not running"
        log_info "Please start Docker and try again"
        return 1
    fi

    log_success "Docker is running"
    return 0
}