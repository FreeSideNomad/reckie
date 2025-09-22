# Development Process Notes for Future Sessions

## ⚠️ CRITICAL PROCESS REMINDER

**NEVER implement UI or features without following the documented development process from `/docs/development.md`**

## Key Mistakes Made (Session 2024-09-21)

1. **Skipped Vision and Requirements Phase**: Implemented dashboard UI without consulting essential use cases
2. **No UI Design Consultation**: Created navigation structure without stakeholder approval
3. **Feature Creep**: Added comprehensive dashboard features without validating business need
4. **Violated Domain-First Principle**: Started with UI instead of core business domain

## Mandatory Process for Future Sessions

### Phase 1: ALWAYS START HERE
1. **Read and reference `/docs/development.md`** before any feature work
2. **Check for existing GitHub Wiki pages**:
   - `Project-Vision.md`
   - `Domain-Model.md`
   - `Essential-Use-Cases.md`
3. **If missing, STOP and request stakeholder input** before proceeding

### Phase 2: UI Design Process
1. **NEVER implement UI without mockups**
2. **Create structured mockups in YAML format** (see example in development.md lines 84-105)
3. **Present UI plans as GitHub Issues** with `needs-review` label
4. **Wait for stakeholder approval** before coding

### Phase 3: Essential Use Cases First
According to development.md, follow Alistair Cockburn's Essential Use Cases approach:
- Start with essential user goals and intentions
- Avoid technical implementation details initially
- Focus on "what" before "how"
- Progressive refinement through structured formats

### Phase 4: Domain-First Architecture
- **Core business domain comes first**
- Supporting domains (auth, user management) come later
- Start with business entity modeling
- Define core use cases before technical infrastructure
- Defer authentication until business logic is validated

## Required Questions Before Any Feature Work

1. **"What essential use case does this serve?"**
2. **"Have we validated this with stakeholders?"**
3. **"Is this core domain or supporting domain?"**
4. **"Do we have documented requirements for this?"**
5. **"What is the minimum viable implementation?"**

## Anti-Patterns to Avoid (from development.md)

- Complex SPA frameworks unless absolutely necessary
- Custom authentication when GitHub OAuth suffices
- Heavy AJAX/HTMX that complicates testing
- Multi-tenant architecture before business model validation
- Microservices for greenfield projects
- Over-engineered data access - use appropriate ORM for maintainability, avoid raw SQL for complex queries

## Current State Assessment

### What Was Implemented Prematurely:
- Comprehensive dashboard with stats and insights
- Full navigation system with 9+ pages
- AI Analysis, Smart Generation, and other advanced features
- Complex UI components and layouts

### What Should Have Been Done First:
1. **Essential Use Cases Documentation** - What are the core user goals?
2. **Domain Model Definition** - What are the core business entities?
3. **Minimal Walking Skeleton** - End-to-end functionality with minimal features
4. **Stakeholder Validation** - UI mockups reviewed and approved

## Recovery Actions for Current Session

1. **Do NOT add more features** without following process
2. **Focus on essential use cases** only
3. **Consider simplifying** existing UI to minimal viable interface
4. **Document current implementation** for stakeholder review

## Future Session Checklist

Before starting any development work:

- [ ] Read `/docs/development.md`
- [ ] Check for Vision, Domain Model, and Essential Use Cases documentation
- [ ] Identify if this is core domain or supporting domain work
- [ ] Create GitHub Issue for stakeholder review if doing UI work
- [ ] Confirm minimum viable implementation approach
- [ ] Validate with user needs, not technical elegance

## Key Development Principles to Remember

1. **Domain-First Architecture** - Business domain before technical infrastructure
2. **User-Centric Validation** - Validate every significant decision with users
3. **Essential Use Cases Methodology** - Focus on user goals, not technical details
4. **GitHub-Native Development** - Use GitHub as single source of truth

## Stakeholder Communication Protocol

### CLARIFIED DEVELOPMENT WORKFLOW (Updated 2024-09-21)

**Phase 1: Planning & Collaboration**
1. **Collaborate on .md files** - Work together on documentation and requirements
2. **Stakeholder review** - Present .md files for review and suggestions
3. **Wait for approval** - Get explicit approval before proceeding to implementation

**Phase 2: Issue Creation**
4. **Create GitHub Issues** - Based on approved .md files, create Epic, Feature, and User Story issues
5. **Issue-driven development** - Each user story becomes a development task

**Phase 3: Implementation Cycle (Per User Story)**
6. **Explicit approval required** - Get approval for each user story before starting
7. **Create feature branch** - Create branch for specific user story
8. **Implement & test** - Code until all tests pass
9. **Commit & merge** - Merge to remote main and fix build issues

**Phase 4: Validation & Iteration**
10. **Manual testing** - Stakeholder performs manual testing
11. **Issue creation** - Create GitHub issues for any problems found
12. **Fix & merge** - Implement fixes and merge code
13. **Repeat cycle** - Continue manual testing and feedback until user story is complete
14. **Move to next story** - Only then proceed to next user story

### CRITICAL RULE: NO CODE WITHOUT EXPLICIT APPROVAL
- ✅ Collaborate on .md files freely
- ❌ Never implement code without explicit stakeholder approval
- ❌ Never create GitHub issues without approved requirements
- ❌ Never merge code without passing tests and build validation

---

**REMEMBER: "Start simple, validate early, iterate based on feedback, and let the business domain drive technical decisions."**