#!/bin/bash
set -e

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

echo -e "${BLUE}🚀 Reckie Deployment Script${NC}"
echo "=================================="

# Function to run pre-deployment checks
run_pre_deployment_checks() {
    log_info "Running pre-deployment checks..."

    # Run linting
    log_info "Running code quality checks..."
    if ./scripts/lint.sh; then
        log_success "Code quality checks passed"
    else
        log_error "Code quality checks failed"
        return 1
    fi

    # Run tests
    log_info "Running test suite..."
    if ./scripts/test.sh; then
        log_success "All tests passed"
    else
        log_error "Tests failed"
        return 1
    fi

    log_success "Pre-deployment checks completed successfully"
}

# Function to check if we're on main/master
is_main_branch() {
    local branch=$(git branch --show-current)
    [[ "$branch" == "main" || "$branch" == "master" ]]
}

# Main deployment function
main() {
    # Check if we're on main branch
    if ! is_main_branch; then
        local current_branch=$(git branch --show-current)
        log_warning "Not on main branch (currently on: $current_branch)"
        read -p "Do you want to merge to main first? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Switching to main and merging $current_branch..."
            git checkout main
            git pull origin main
            git merge "$current_branch"
        else
            log_info "Deploying from feature branch: $current_branch"
        fi
    fi

    # Run pre-deployment checks
    if ! run_pre_deployment_checks; then
        log_error "Pre-deployment checks failed. Aborting deployment."
        exit 1
    fi

    # Use the intelligent commit and push script
    log_info "Running intelligent commit and push..."
    ./scripts/commit-and-push.sh "$@"

    log_success "Deployment completed successfully! 🎉"
}

# Run main function with all arguments
main "$@"