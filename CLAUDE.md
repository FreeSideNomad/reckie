# Claude Code Development Guidelines for Reckie

This file provides essential context and guidelines for Claude Code sessions working on the Reckie project.

## Project Overview

**Reckie** is an AI-native requirements engineering platform designed to enable autonomous software development workflows. The platform provides structured, machine-readable requirements that LLM agents can consume to generate code, create tests, manage defects, and maintain GitHub repositories.

### Key Documents
- **Vision**: `/docs/vision.md` - Complete project vision and business requirements
- **Development Process**: `/docs/development.md` - Comprehensive development methodology
- **Process Notes**: `/DEVELOPMENT_NOTES.md` - Critical process reminders and lessons learned

## Critical Development Process

**🚨 MANDATORY: NO CODE WITHOUT EXPLICIT STAKEHOLDER APPROVAL**

### 4-Phase Development Workflow

**Phase 1: Planning & Collaboration**
1. Collaborate on .md files (documentation and requirements)
2. Stakeholder review and feedback on .md files
3. **Wait for explicit approval** before proceeding

**Phase 2: Issue Creation**
4. Create GitHub Issues (Epic, Feature, User Story) based on approved .md files
5. Issue-driven development approach

**Phase 3: Implementation Cycle (Per User Story)**
6. **Get explicit approval** for each user story before starting
7. Create feature branch for specific user story
8. Implement & test until all tests pass
9. Commit & merge to remote main, fix build issues

**Phase 4: Validation & Iteration**
10. Stakeholder manual testing
11. Create GitHub issues for problems found
12. Fix & merge code
13. Repeat until user story complete
14. Move to next user story only after completion

### Essential Rules
- ✅ Collaborate on .md files freely
- ❌ Never implement code without explicit stakeholder approval
- ❌ Never create GitHub issues without approved requirements
- ❌ Never merge code without passing tests and build validation

## Technology Stack

### Approved Technologies
- **Backend**: Python/FastAPI (current choice)
- **Database**: PostgreSQL with pgvector for RAG storage
- **ORM**: SQLAlchemy for maintainability and type safety
- **Frontend**: Server-side rendering with Jinja2 templates
- **AI Integration**: OpenAI API with cost management
- **Authentication**: GitHub OAuth (when needed)
- **Testing**: Pytest for unit tests
- **Deployment**: GitHub Actions + cloud provider

### Technology Guidelines
1. **Simplicity over sophistication** - choose boring, proven technologies
2. **GitHub integration** - prioritize tools that work well with GitHub
3. **User experience** - optimize for end-user productivity
4. **Testing support** - ensure technologies support automated testing
5. **AI integration** - consider how well tools work with LLM APIs

### Anti-Patterns to Avoid
- Complex SPA frameworks unless absolutely necessary
- Custom authentication when GitHub OAuth suffices
- Heavy AJAX/HTMX that complicates testing
- Multi-tenant architecture before business model validation
- Microservices for greenfield projects
- Over-engineered data access patterns

## Architecture Principles

### 1. Domain-First Architecture
- Core business domain comes first
- Supporting domains (auth, user management) come later
- Start with business entity modeling
- Define core use cases before technical infrastructure
- Defer authentication until business logic is validated

### 2. GitHub-Native Development
- Use GitHub as single source of truth for all project artifacts
- Vision and context in GitHub Wiki
- Work tracking through GitHub Issues
- Project management via GitHub Projects
- Code in GitHub repositories
- Automation through GitHub Actions

### 3. User-Centric Validation
- Validate every significant decision with users before implementation
- Present plans as GitHub Issues for review
- Create UI mocks in structured format (Markdown/YAML) before coding
- Implement feedback loops at every stage
- Prioritize user experience over technical elegance

### 4. Essential Use Cases Methodology
- Follow Alistair Cockburn's Essential Use Cases approach
- Start with essential user goals and intentions
- Avoid technical implementation details initially
- Focus on "what" before "how"
- Progressive refinement through structured formats

## Database Architecture

### PostgreSQL Setup
- **Primary Database**: PostgreSQL for all structured data
- **Vector Storage**: pgvector extension for RAG capabilities
- **Conversation Storage**: Full conversation logging and context
- **ORM**: SQLAlchemy for database operations
- **Migrations**: Alembic for database schema management

### Data Storage Strategy
- Conversational data in PostgreSQL tables
- Vector embeddings in pgvector for similarity search
- Document storage in GitHub wiki with RAG indexing in PostgreSQL
- Planning documents managed through wiki repository with symlink integration

## Wiki Management & Workflow

### Repository Setup (One-Time)

**🚨 IMPORTANT**: Planning documents are stored in a separate GitHub wiki repository to maintain proper version control and avoid duplication.

#### First-Time Setup
```bash
# Run the setup script to configure wiki integration
./scripts/setup-wiki.sh
```

**What the setup script does:**
1. Clones `https://github.com/FreeSideNomad/reckie.wiki.git` to `../reckie.wiki`
2. Creates symbolic link: `docs/wiki` → `../reckie.wiki`
3. Adds `docs/wiki` to `.gitignore` to prevent duplication
4. Verifies all planning documents are accessible

#### Manual Setup (if script fails)
```bash
# Clone wiki repository
git clone https://github.com/FreeSideNomad/reckie.wiki.git ../reckie.wiki

# Create symbolic link
ln -s ../reckie.wiki docs/wiki

# Add to gitignore
echo "docs/wiki" >> .gitignore
```

### Daily Workflow

#### Planning Document Editing
```bash
# 1. Edit files normally in VS Code
# Files appear at docs/wiki/ but are actually in separate repository
code docs/wiki/Epic-User-LLM-Interaction-Framework.md

# 2. Files are immediately available for Claude Code references
# ✅ Read tool: docs/wiki/Epic-User-LLM-Interaction-Framework.md
# ✅ Edit tool: docs/wiki/Essential-Use-Cases-LLM-Interaction.md
```

#### Committing Wiki Changes
```bash
# Navigate to wiki directory (follows symlink)
cd docs/wiki

# Standard git workflow in wiki repository
git add .
git commit -m "docs: update planning documents with PostgreSQL architecture"
git push origin master

# Return to main repository
cd ../..
```

#### VS Code Integration
- **File Explorer**: `docs/wiki/` appears as normal directory
- **Git Integration**: Changes show in separate wiki repository
- **Claude Code**: All file references work normally
- **Search**: Wiki files included in workspace search

### File Structure

#### Main Repository
```
reckie/
├── docs/
│   ├── wiki/           # ← Symlink to ../reckie.wiki
│   ├── vision.md
│   └── development.md
├── CLAUDE.md
└── scripts/setup-wiki.sh
```

#### Wiki Repository (../reckie.wiki)
```
reckie.wiki/
├── .git/                                    # Separate version control
├── Epic-User-LLM-Interaction-Framework.md   # Epic planning
├── Essential-Use-Cases-LLM-Interaction.md   # Use cases
├── UI-Mockups-LLM-Interaction.md           # Interface mockups
├── Development-Process.md                   # Process documentation
└── Project-Vision.md                        # Project vision
```

### Version Control Benefits

#### ✅ **Advantages of This Approach**
- **Single Source of Truth**: Wiki repository is authoritative
- **No Duplication**: Files exist only in wiki repository
- **Familiar Paths**: `docs/wiki/` paths work in VS Code and Claude Code
- **Separate Git History**: Planning docs have independent version control
- **GitHub Wiki Integration**: Changes automatically sync to GitHub wiki interface
- **Team Friendly**: Simple one-time setup for new developers

#### 🔄 **Workflow Comparison**

**Before (Problematic)**:
```bash
# Files in two places - sync issues
reckie/docs/wiki/Epic-...                    # Copy 1
reckie.wiki/Epic-...                         # Copy 2 (source of truth)
```

**After (Clean)**:
```bash
# Single source of truth with convenient access
reckie/docs/wiki/ → ../reckie.wiki/          # Symlink
reckie.wiki/Epic-...                         # Only copy (source of truth)
```

### Common Operations

#### Adding New Planning Documents
```bash
# Create new document in wiki
cd docs/wiki
touch New-Feature-Planning.md
code New-Feature-Planning.md

# Commit to wiki repository
git add New-Feature-Planning.md
git commit -m "docs: add new feature planning document"
git push
```

#### Reviewing Planning Documents
```bash
# Read any planning document using familiar paths
# These work in Claude Code:
docs/wiki/Epic-User-LLM-Interaction-Framework.md
docs/wiki/Essential-Use-Cases-LLM-Interaction.md
docs/wiki/UI-Mockups-LLM-Interaction.md
```

#### Updating CLAUDE.md References
```bash
# Update file references when needed
# All docs/wiki/ paths work correctly
# No changes needed for existing references
```

### Troubleshooting

#### Symlink Issues
```bash
# Check if symlink is working
ls -la docs/wiki
# Should show: docs/wiki -> ../reckie.wiki

# Recreate if broken
rm docs/wiki
ln -s ../reckie.wiki docs/wiki
```

#### Missing Wiki Repository
```bash
# Re-clone wiki repository
git clone https://github.com/FreeSideNomad/reckie.wiki.git ../reckie.wiki
```

#### Git Confusion
```bash
# Check which repository you're in
pwd && git remote -v

# Main repository should show:
# origin: github.com:FreeSideNomad/reckie.git

# Wiki repository should show:
# origin: github.com:FreeSideNomad/reckie.wiki.git
```

### Team Onboarding

#### New Team Member Setup
1. Clone main repository: `git clone https://github.com/FreeSideNomad/reckie.git`
2. Run setup: `./scripts/setup-wiki.sh`
3. Verify: `ls docs/wiki/` should show planning documents

#### Documentation for New Developers
- Point them to this section of CLAUDE.md
- Emphasize the one-time setup requirement
- Explain the symlink concept and separate git repositories

## Quality Standards

### Code Quality
- **Test Coverage**: Minimum 90% for business logic with E2E tests using Playwright, 90% of code lines, branches
- **Code Review**: All changes require review via GitHub PR
- **Documentation**: Every public API documented
- **Performance**: Response times under 2 seconds for user interactions

### Development Quality
- **Linting**: Follow Python black formatting
- **Type Hints**: Use type annotations for better maintainability
- **Error Handling**: Comprehensive error handling and logging
- **Security**: Never expose secrets or API keys

## Current Project State

### Active Epic
**User-LLM Interaction Framework** - Located in `/docs/wiki/Epic-User-LLM-Interaction-Framework.md`
- Establishes foundational framework for user-LLM interactions
- PostgreSQL integration for conversation and context storage
- OpenAI API integration with proper error handling
- Web interface for collaborative document editing

### Development Branch
- **Active Branch**: `feature/walking-skeleton`
- **Status**: Planning phase complete, awaiting stakeholder approval of .md files
- **Next Step**: Domain modeling following development process guidelines

### Planning Documents (Ready for Review)
1. `/docs/wiki/Epic-User-LLM-Interaction-Framework.md`
2. `/docs/wiki/Essential-Use-Cases-LLM-Interaction.md`
3. `/docs/wiki/UI-Mockups-LLM-Interaction.md`

## AI Integration Guidelines

### OpenAI API Usage
- **Cost Management**: Monitor token usage and implement rate limiting
- **Error Handling**: Graceful degradation when API unavailable
- **Context Management**: Efficient prompt engineering for cost control
- **Security**: Secure API key storage and usage patterns

### Conversation Management
- **Logging**: Full conversation audit trail in PostgreSQL
- **Context**: Dynamic context retrieval for relevant responses
- **Privacy**: Secure handling of conversation data
- **Performance**: Optimize for response time and user experience

## Success Metrics

### Requirements Completeness
- Percentage of requirements requiring clarification during implementation
- Time from requirement completion to successful implementation
- Success rate of completing iterations without human intervention

### User Experience
- User satisfaction with delivered functionality
- Time to incorporate user feedback into next iteration
- Correlation between requirement characteristics and implementation success

## Common Pitfalls to Avoid

### Process Violations (from DEVELOPMENT_NOTES.md)
1. **Skipping Vision/Requirements Phase**: Never implement without consulting essential use cases
2. **No UI Design Consultation**: Create mockups before any UI implementation
3. **Feature Creep**: Validate business need before adding features
4. **Violating Domain-First Principle**: Start with core business domain, not UI/infrastructure

### Technical Mistakes
1. **Premature Optimization**: Focus on working functionality first
2. **Over-Engineering**: Keep solutions simple and maintainable
3. **Ignoring Test Coverage**: Maintain quality standards from the start
4. **Security Oversights**: Follow security best practices consistently

## Quick Reference Commands

### Development Setup
```bash
# Start development server
./scripts/dev.sh

# Run tests
pytest

# Code formatting
black .

# Type checking
mypy app/
```

### Database Commands
```bash
# Database migrations (when implemented)
alembic upgrade head

# Create new migration
alembic revision --autogenerate -m "description"
```

## Remember

**"Start simple, validate early, iterate based on feedback, and let the business domain drive technical decisions."**

Always prioritize:
1. User needs over technical elegance
2. Working software over perfect documentation
3. Stakeholder feedback over assumptions
4. Domain modeling over technical implementation
5. Security and quality over speed of delivery

---

*This file should be updated as the project evolves. Always refer to the source documents (`/docs/vision.md`, `/docs/development.md`, `/DEVELOPMENT_NOTES.md`) for complete details.*