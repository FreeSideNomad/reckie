#!/bin/bash
set -e

# Source common utilities
source "$(dirname "$0")/common.sh"

echo -e "${BLUE}🚀 Reckie Deployment Script${NC}"
echo "=================================="

# Check dependencies
log_info "Checking dependencies..."
if ! check_dependencies "git" "gh" "jq" "curl"; then
    log_error "Missing required dependencies. Please install them and try again."
    exit 1
fi

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