# Reckie Automation Scripts

## Overview

Reckie includes intelligent automation scripts that handle the complete development lifecycle with AI-powered error detection and automatic fixing.

## Scripts Available

### 🚀 `./scripts/commit-and-push.sh`

Intelligent commit and push script with automatic CI/CD monitoring and error fixing.

**Features:**
- **Smart Branch Detection**: Automatically detects if you're on main/master or feature branch
- **Intelligent Commit Messages**: Generates meaningful commit messages based on file changes
- **GitHub Actions Monitoring**: Waits for CI/CD pipelines to complete
- **Automatic Issue Creation**: Creates GitHub issues for build failures with detailed error analysis
- **Auto-Fix Capabilities**: Attempts to fix common issues automatically:
  - Code formatting (Black)
  - Import sorting (isort)
  - Basic linting issues
  - Dependency problems
- **Retry Logic**: Automatically retries up to 5 times with fixes applied
- **Detailed Logging**: Color-coded output with progress tracking

**Usage:**
```bash
# Auto-generate commit message and push
./scripts/commit-and-push.sh

# Use custom commit message
./scripts/commit-and-push.sh "feat: add new user authentication system"
```

**Workflow:**
1. Stages changes (if not already staged)
2. Generates or uses provided commit message
3. Commits changes with standardized format
4. Pushes to appropriate branch (main or feature)
5. Monitors GitHub Actions for completion
6. If failures occur:
   - Analyzes error logs
   - Creates detailed GitHub issue
   - Attempts automatic fixes
   - Retries commit/push cycle
   - Updates GitHub issue with fix status

### 🔧 `./scripts/deploy.sh`

Production deployment script with comprehensive pre-flight checks.

**Features:**
- **Pre-deployment Validation**: Runs full test suite and quality checks
- **Branch Management**: Handles main branch merging
- **Integration**: Uses the intelligent commit-and-push script
- **Safety Checks**: Prevents broken code from reaching production

**Usage:**
```bash
# Deploy with pre-flight checks
./scripts/deploy.sh

# Deploy with custom message
./scripts/deploy.sh "release: version 1.2.0 with new features"
```

### 🛠️ `./scripts/dev.sh`

Enhanced development server with automatic browser opening.

**Features:**
- **Auto-browser Launch**: Opens browser when server is ready
- **Health Monitoring**: Waits for server to be fully operational
- **Cross-platform**: Works on macOS, Linux, and Windows
- **Docker Integration**: Automatically starts required services

### 🧪 `./scripts/test.sh`

Comprehensive testing with coverage reporting.

### 🔍 `./scripts/lint.sh`

Code quality enforcement with multiple tools.

## Automatic Issue Management

When build failures occur, the system automatically:

### 1. Error Analysis
- Extracts error messages from GitHub Actions logs
- Categorizes error types (formatting, linting, dependencies, etc.)
- Identifies root causes

### 2. Issue Creation
Creates GitHub issues with:
- **Detailed Error Logs**: Complete stack traces and error messages
- **Commit Information**: SHA, branch, and timestamp
- **Priority Classification**: Critical for build failures
- **Auto-assignment**: Issues are assigned to the committer
- **Proper Labeling**: `bug`, `ci-cd`, `critical`, `auto-generated`

### 3. Automatic Fixes

The system can automatically fix:

#### Code Formatting Issues
- **Black formatting**: Applies consistent Python code formatting
- **Import sorting**: Uses isort to organize imports correctly

#### Linting Problems
- **Trailing whitespace**: Removes extra spaces
- **Line length**: Basic fixes for overly long lines

#### Dependency Issues
- **Requirements sync**: Updates requirements.txt from pyproject.toml
- **Missing imports**: Identifies and suggests missing dependencies

#### Type Checking
- **Basic type issues**: Adds type ignore comments where appropriate
- **Import problems**: Resolves basic typing import issues

### 4. Retry Logic

The script implements intelligent retry logic:
- **Maximum 5 attempts**: Prevents infinite loops
- **Progressive fixing**: Each attempt applies different fixes
- **Status tracking**: Updates GitHub issues with fix attempts
- **Success verification**: Re-runs CI/CD after each fix

## Configuration

### Environment Variables
```bash
# Set in your environment or CI/CD
GITHUB_TOKEN=your_github_token_here
REPO_OWNER=FreeSideNomad
REPO_NAME=reckie
```

### Required Tools
- `gh` (GitHub CLI)
- `git`
- `curl`
- `jq` (for JSON parsing)

## Advanced Usage

### Custom Error Handlers

Add custom error patterns in `commit-and-push.sh`:

```bash
# In attempt_automatic_fix function
if echo "$error_details" | grep -q "your-custom-error-pattern"; then
    log_info "Detected custom issue, applying fix..."
    # Your custom fix logic here
    fixed=true
fi
```

### Integration with CI/CD

The scripts integrate seamlessly with GitHub Actions:

```yaml
# Example GitHub Action trigger
on:
  push:
    branches: [main, develop]
  # Automatically triggered by commit-and-push.sh
```

### Monitoring and Alerts

- **Real-time feedback**: Terminal output shows progress
- **GitHub notifications**: Issues created automatically notify team
- **Slack integration**: Can be extended to post to Slack channels

## Best Practices

### 1. Pre-commit Workflow
```bash
# Before committing major changes
./scripts/lint.sh          # Check code quality
./scripts/test.sh           # Run tests
./scripts/commit-and-push.sh # Commit with monitoring
```

### 2. Feature Branch Workflow
```bash
git checkout -b feature/new-feature
# Make changes
./scripts/commit-and-push.sh "feat: implement new feature"
# Script handles feature branch push and monitoring
```

### 3. Hotfix Workflow
```bash
git checkout main
git checkout -b hotfix/urgent-fix
# Apply fix
./scripts/deploy.sh "fix: critical security patch"
# Handles merge to main and deployment
```

## Troubleshooting

### Common Issues

#### GitHub CLI Authentication
```bash
gh auth login
gh auth refresh -s project
```

#### Docker Services Not Starting
```bash
docker-compose -f docker/docker-compose.yml down
docker-compose -f docker/docker-compose.yml up -d
```

#### CI/CD Timeout Issues
- Increase `max_wait` in `wait_for_github_actions()`
- Check GitHub Actions status page
- Verify repository permissions

### Manual Override

If automatic fixes fail:
1. Check the created GitHub issue for detailed error analysis
2. Apply manual fixes based on error messages
3. Run `./scripts/commit-and-push.sh` again
4. The script will automatically close related issues when successful

## Security Considerations

- **Token Security**: GitHub tokens are read from environment variables
- **Permissions**: Scripts only modify code and create issues
- **Audit Trail**: All actions are logged and tracked in GitHub
- **Isolation**: Each fix attempt is a separate commit for easy rollback

## Future Enhancements

- **AI-powered fixes**: Integration with Claude for complex error resolution
- **Performance optimization**: Caching of workflow runs and error patterns
- **Team notifications**: Slack/Discord integration for team awareness
- **Metrics dashboard**: Track fix success rates and common error patterns