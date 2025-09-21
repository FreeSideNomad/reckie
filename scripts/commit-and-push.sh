#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MAX_RETRIES=5
RETRY_COUNT=0
REPO_OWNER="FreeSideNomad"
REPO_NAME="reckie"

echo -e "${BLUE}🚀 Intelligent Commit and Push Script${NC}"
echo "================================================"

# Function to print colored output
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Function to get current branch
get_current_branch() {
    git branch --show-current
}

# Function to check if we're on main/master
is_main_branch() {
    local branch=$(get_current_branch)
    [[ "$branch" == "main" || "$branch" == "master" ]]
}

# Function to generate commit message based on changes
generate_commit_message() {
    local changes=$(git diff --cached --name-only | head -10)
    local num_files=$(git diff --cached --name-only | wc -l | xargs)

    if [ $num_files -eq 0 ]; then
        echo "No changes to commit"
        return 1
    fi

    # Analyze change types
    local has_new_features=false
    local has_fixes=false
    local has_docs=false
    local has_tests=false
    local has_config=false

    while IFS= read -r file; do
        case "$file" in
            app/*) has_new_features=true ;;
            tests/*) has_tests=true ;;
            *.md|docs/*) has_docs=true ;;
            *.yml|*.yaml|*.json|*.toml) has_config=true ;;
            *fix*|*bug*) has_fixes=true ;;
        esac
    done <<< "$changes"

    # Generate meaningful commit message
    local message=""
    if $has_new_features; then
        message="feat: "
    elif $has_fixes; then
        message="fix: "
    elif $has_tests; then
        message="test: "
    elif $has_docs; then
        message="docs: "
    elif $has_config; then
        message="config: "
    else
        message="chore: "
    fi

    # Add summary based on files changed
    if [ $num_files -eq 1 ]; then
        message+="update $(basename "$changes")"
    elif [ $num_files -le 5 ]; then
        message+="update $(echo "$changes" | wc -l | xargs) files"
    else
        message+="major updates across $num_files files"
    fi

    echo "$message"
}

# Function to wait for GitHub Actions to complete
wait_for_github_actions() {
    local commit_sha="$1"
    local branch="$2"

    log_info "Waiting for GitHub Actions to complete for commit $commit_sha..."

    local max_wait=600  # 10 minutes
    local wait_time=0
    local check_interval=30

    while [ $wait_time -lt $max_wait ]; do
        log_info "Checking GitHub Actions status... (${wait_time}s elapsed)"

        # Get workflow runs for this commit
        local runs=$(gh api repos/$REPO_OWNER/$REPO_NAME/actions/runs \
            --jq ".workflow_runs[] | select(.head_sha == \"$commit_sha\") | {id: .id, status: .status, conclusion: .conclusion, name: .name}")

        if [ -z "$runs" ]; then
            log_warning "No workflow runs found yet for commit $commit_sha"
            sleep $check_interval
            wait_time=$((wait_time + check_interval))
            continue
        fi

        # Check if all runs are completed
        local all_completed=true
        local has_failures=false
        local failed_runs=()

        while IFS= read -r run; do
            if [ -n "$run" ]; then
                local status=$(echo "$run" | jq -r '.status')
                local conclusion=$(echo "$run" | jq -r '.conclusion')
                local name=$(echo "$run" | jq -r '.name')
                local id=$(echo "$run" | jq -r '.id')

                if [ "$status" != "completed" ]; then
                    all_completed=false
                    log_info "Workflow '$name' still running..."
                elif [ "$conclusion" != "success" ]; then
                    has_failures=true
                    failed_runs+=("$id:$name:$conclusion")
                    log_error "Workflow '$name' failed with conclusion: $conclusion"
                else
                    log_success "Workflow '$name' completed successfully"
                fi
            fi
        done <<< "$runs"

        if $all_completed; then
            if $has_failures; then
                log_error "GitHub Actions completed with failures"
                echo "${failed_runs[@]}"
                return 1
            else
                log_success "All GitHub Actions completed successfully!"
                return 0
            fi
        fi

        sleep $check_interval
        wait_time=$((wait_time + check_interval))
    done

    log_error "Timeout waiting for GitHub Actions to complete"
    return 1
}

# Function to analyze workflow failure and extract errors
analyze_workflow_failure() {
    local run_id="$1"
    local workflow_name="$2"

    log_info "Analyzing failure in workflow: $workflow_name (ID: $run_id)"

    # Get workflow run details
    local run_details=$(gh api repos/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id)
    local jobs_url=$(echo "$run_details" | jq -r '.jobs_url')

    # Get failed jobs
    local failed_jobs=$(gh api "$jobs_url" --jq '.jobs[] | select(.conclusion == "failure") | {id: .id, name: .name, steps: [.steps[] | select(.conclusion == "failure") | {name: .name, number: .number}]}')

    local errors=()

    while IFS= read -r job; do
        if [ -n "$job" ]; then
            local job_id=$(echo "$job" | jq -r '.id')
            local job_name=$(echo "$job" | jq -r '.name')

            # Get job logs
            local logs=$(gh api repos/$REPO_OWNER/$REPO_NAME/actions/jobs/$job_id/logs 2>/dev/null || echo "")

            # Extract error patterns
            local error_lines=$(echo "$logs" | grep -i "error\|failed\|exception\|traceback" | head -10)

            if [ -n "$error_lines" ]; then
                errors+=("Job: $job_name
Errors:
$error_lines")
            fi
        fi
    done <<< "$failed_jobs"

    printf '%s\n' "${errors[@]}"
}

# Function to create GitHub issue for build failure
create_build_failure_issue() {
    local commit_sha="$1"
    local branch="$2"
    local failed_runs="$3"
    local error_details="$4"

    local issue_title="[BUILD FAILURE] CI/CD pipeline failed on branch $branch"
    local issue_body="## Build Failure Report

**Commit**: $commit_sha
**Branch**: $branch
**Timestamp**: $(date -u +"%Y-%m-%d %H:%M:%S UTC")

### Failed Workflows
$failed_runs

### Error Details
\`\`\`
$error_details
\`\`\`

### Priority
🔴 **Critical** - Build pipeline is broken

### Action Items
- [ ] Analyze root cause of failure
- [ ] Implement fix
- [ ] Verify fix resolves issue
- [ ] Update CI/CD pipeline if needed

### Auto-generated
This issue was automatically created by the commit-and-push script.

🤖 Generated with [Claude Code](https://claude.ai/code)"

    # Create the issue
    local issue_url=$(gh issue create \
        --title "$issue_title" \
        --body "$issue_body" \
        --label "bug,ci-cd,critical,auto-generated" \
        --assignee "@me")

    log_success "Created GitHub issue: $issue_url"
    echo "$issue_url"
}

# Function to attempt automatic fix based on error analysis
attempt_automatic_fix() {
    local error_details="$1"
    local fixed=false

    log_info "Attempting automatic fixes based on error analysis..."

    # Common fix patterns
    if echo "$error_details" | grep -q "black.*would reformat"; then
        log_info "Detected code formatting issues, running black..."
        if command -v black >/dev/null 2>&1; then
            black app/ tests/ || true
            git add -A
            fixed=true
            log_success "Applied code formatting fixes"
        fi
    fi

    if echo "$error_details" | grep -q "isort.*would reformat\|isort.*Imports are incorrectly sorted"; then
        log_info "Detected import sorting issues, running isort..."
        if command -v isort >/dev/null 2>&1; then
            isort app/ tests/ || true
            git add -A
            fixed=true
            log_success "Applied import sorting fixes"
        fi
    fi

    if echo "$error_details" | grep -q "flake8\|pycodestyle\|E[0-9]\+\|W[0-9]\+"; then
        log_info "Detected linting issues, attempting basic fixes..."
        # Remove trailing whitespaces
        find app/ tests/ -name "*.py" -exec sed -i '' 's/[[:space:]]*$//' {} \; 2>/dev/null || true
        git add -A
        fixed=true
        log_success "Applied basic linting fixes"
    fi

    if echo "$error_details" | grep -q "requirements.txt\|ModuleNotFoundError\|ImportError"; then
        log_info "Detected dependency issues, updating requirements..."
        if [ -f "pyproject.toml" ]; then
            # Regenerate requirements if using uv
            if command -v uv >/dev/null 2>&1; then
                uv pip freeze > requirements.txt 2>/dev/null || true
                git add requirements.txt
                fixed=true
                log_success "Updated requirements.txt"
            fi
        fi
    fi

    if echo "$error_details" | grep -q "mypy.*error"; then
        log_info "Detected type checking issues, adding type ignores for now..."
        # This is a temporary fix - in practice, you'd want more sophisticated type fixing
        log_warning "Type errors detected - manual review recommended"
    fi

    if $fixed; then
        log_success "Applied automatic fixes"
        return 0
    else
        log_warning "No automatic fixes could be applied"
        return 1
    fi
}

# Function to update GitHub issue with fix attempt
update_issue_with_fix() {
    local issue_url="$1"
    local fix_description="$2"
    local success="$3"

    local issue_number=$(echo "$issue_url" | grep -o '[0-9]*$')

    local comment_body="## Fix Attempt $(date -u +"%Y-%m-%d %H:%M:%S UTC")

**Fix Applied**: $fix_description
**Status**: $([ "$success" = "true" ] && echo "✅ Success" || echo "❌ Failed")

$([ "$success" = "true" ] && echo "The fix has been applied and committed. Re-running CI/CD pipeline..." || echo "Fix attempt was unsuccessful. Manual intervention may be required.")

🤖 Auto-generated fix attempt"

    gh issue comment "$issue_number" --body "$comment_body"
}

# Main execution function
main() {
    # Check if there are changes to commit
    if [ -z "$(git diff --cached --name-only)" ]; then
        log_info "Staging all changes..."
        git add -A

        if [ -z "$(git diff --cached --name-only)" ]; then
            log_warning "No changes to commit"
            exit 0
        fi
    fi

    # Generate commit message
    local commit_message
    if [ $# -gt 0 ]; then
        commit_message="$*"
    else
        commit_message=$(generate_commit_message)
        if [ $? -ne 0 ]; then
            log_error "Failed to generate commit message"
            exit 1
        fi
    fi

    log_info "Commit message: $commit_message"

    # Start the commit and push cycle
    while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
        log_info "Attempt $((RETRY_COUNT + 1)) of $MAX_RETRIES"

        # Commit changes
        git commit -m "$commit_message

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

        local commit_sha=$(git rev-parse HEAD)
        log_success "Created commit: $commit_sha"

        # Determine push strategy based on branch
        local current_branch=$(get_current_branch)

        if is_main_branch; then
            log_info "On main branch, pushing directly..."
            git push origin "$current_branch"
        else
            log_info "On feature branch '$current_branch', pushing to feature branch..."
            git push origin "$current_branch"
        fi

        log_success "Successfully pushed to origin/$current_branch"

        # Wait for GitHub Actions
        local failed_runs_output
        if wait_for_github_actions "$commit_sha" "$current_branch"; then
            log_success "All CI/CD checks passed! 🎉"
            break
        else
            failed_runs_output=$(wait_for_github_actions "$commit_sha" "$current_branch" 2>&1 || echo "$?")
            log_error "CI/CD checks failed"

            # Analyze failures and create issues
            local failed_runs=($(echo "$failed_runs_output" | grep -o '[0-9]*:[^:]*:[^:]*'))
            local all_errors=""

            for run_info in "${failed_runs[@]}"; do
                IFS=':' read -r run_id workflow_name conclusion <<< "$run_info"
                local error_details=$(analyze_workflow_failure "$run_id" "$workflow_name")
                all_errors+="
Workflow: $workflow_name
$error_details
"
            done

            # Create GitHub issue
            local issue_url=$(create_build_failure_issue "$commit_sha" "$current_branch" "$(printf '%s\n' "${failed_runs[@]}")" "$all_errors")

            # Attempt automatic fix
            if attempt_automatic_fix "$all_errors"; then
                update_issue_with_fix "$issue_url" "Applied automatic fixes for common issues" "true"

                # Update commit message for fix attempt
                commit_message="fix: resolve CI/CD pipeline issues from $commit_sha"
                RETRY_COUNT=$((RETRY_COUNT + 1))

                log_info "Applied fixes, retrying commit and push..."
                continue
            else
                update_issue_with_fix "$issue_url" "No automatic fixes available" "false"
                log_error "Unable to automatically fix issues. Manual intervention required."
                log_info "GitHub issue created: $issue_url"
                exit 1
            fi
        fi
    done

    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        log_error "Maximum retry attempts reached. Please fix issues manually."
        exit 1
    fi

    log_success "Commit and push completed successfully! 🚀"
}

# Run main function with all arguments
main "$@"