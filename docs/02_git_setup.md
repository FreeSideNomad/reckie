# GitHub Repository Configuration for Reckie

## Overview
This document provides step-by-step instructions for configuring GitHub repository features to support the Reckie development process, including issue templates, labels, and project boards for managing epics, features, user stories, and approval workflows.

## 1. Issue Templates Setup

### Create .github/ISSUE_TEMPLATE/ Directory Structure
```bash
mkdir -p .github/ISSUE_TEMPLATE
```

### Epic Template
Create `.github/ISSUE_TEMPLATE/epic.yml`:
```yaml
name: Epic
description: Large feature or capability that spans multiple iterations
title: "[EPIC] "
labels: ["epic", "needs-review"]
assignees: []
body:
  - type: markdown
    attributes:
      value: |
        ## Epic Overview
        Use this template for large features or capabilities that will be broken down into multiple user stories and span multiple iterations.

  - type: input
    id: epic_title
    attributes:
      label: Epic Title
      description: Brief, descriptive title for this epic
      placeholder: "User Authentication and Authorization"
    validations:
      required: true

  - type: textarea
    id: business_value
    attributes:
      label: Business Value
      description: What business problem does this epic solve?
      placeholder: "Enables secure user access to platform features..."
    validations:
      required: true

  - type: textarea
    id: user_personas
    attributes:
      label: Target User Personas
      description: Which user types will benefit from this epic?
      placeholder: "- Developers\n- Product Managers\n- AI Agents"
    validations:
      required: true

  - type: textarea
    id: acceptance_criteria
    attributes:
      label: Epic Acceptance Criteria
      description: High-level criteria for epic completion
      placeholder: "- [ ] Users can create accounts\n- [ ] Users can authenticate\n- [ ] Access control works"
    validations:
      required: true

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      description: Business priority level
      options:
        - "Critical"
        - "High"
        - "Medium"
        - "Low"
    validations:
      required: true

  - type: dropdown
    id: iteration_target
    attributes:
      label: Target Iteration
      description: When should this epic be completed?
      options:
        - "Current Iteration"
        - "Next Iteration"
        - "Future Iteration"
        - "Backlog"
    validations:
      required: true

  - type: textarea
    id: dependencies
    attributes:
      label: Dependencies
      description: What other epics or external dependencies are required?
      placeholder: "- Depends on Infrastructure Epic\n- Requires OAuth provider setup"

  - type: textarea
    id: success_metrics
    attributes:
      label: Success Metrics
      description: How will we measure success of this epic?
      placeholder: "- User activation rate > 80%\n- Authentication errors < 1%"
```

### Feature Template
Create `.github/ISSUE_TEMPLATE/feature.yml`:
```yaml
name: Feature
description: Specific functionality within an epic
title: "[FEATURE] "
labels: ["feature", "needs-review"]
assignees: []
body:
  - type: markdown
    attributes:
      value: |
        ## Feature Overview
        Use this template for specific functionality that can be implemented within a single iteration.

  - type: input
    id: parent_epic
    attributes:
      label: Parent Epic
      description: Link to the epic this feature belongs to (use #issue_number)
      placeholder: "#123"
    validations:
      required: true

  - type: input
    id: feature_title
    attributes:
      label: Feature Title
      description: Clear, specific title for this feature
      placeholder: "GitHub OAuth Integration"
    validations:
      required: true

  - type: textarea
    id: user_story
    attributes:
      label: User Story
      description: "As a [user type], I want [functionality] so that [benefit]"
      placeholder: "As a developer, I want to authenticate with GitHub so that I can access my repositories"
    validations:
      required: true

  - type: textarea
    id: detailed_description
    attributes:
      label: Detailed Description
      description: Complete description of the feature functionality
      placeholder: "This feature implements GitHub OAuth2 authentication flow..."
    validations:
      required: true

  - type: textarea
    id: acceptance_criteria
    attributes:
      label: Acceptance Criteria
      description: Specific, testable criteria for feature completion
      placeholder: "- [ ] User can click 'Login with GitHub' button\n- [ ] OAuth flow redirects correctly\n- [ ] User session is established"
    validations:
      required: true

  - type: textarea
    id: technical_requirements
    attributes:
      label: Technical Requirements
      description: Technical specifications and constraints
      placeholder: "- Use GitHub Apps framework\n- Store tokens securely\n- Handle token refresh"

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      description: Feature priority within the epic
      options:
        - "Critical"
        - "High"
        - "Medium"
        - "Low"
    validations:
      required: true

  - type: dropdown
    id: complexity
    attributes:
      label: Complexity Estimate
      description: Development complexity estimate
      options:
        - "1 - Simple (1-2 days)"
        - "2 - Moderate (3-5 days)"
        - "3 - Complex (1-2 weeks)"
        - "5 - Very Complex (2+ weeks)"
    validations:
      required: true

  - type: textarea
    id: edge_cases
    attributes:
      label: Edge Cases & Error Handling
      description: Known edge cases and error scenarios
      placeholder: "- OAuth provider is down\n- User denies permission\n- Token expires during session"

  - type: textarea
    id: testing_notes
    attributes:
      label: Testing Requirements
      description: Specific testing requirements and scenarios
      placeholder: "- Unit tests for OAuth flow\n- Integration tests with GitHub API\n- E2E tests for login flow"
```

### User Story Template
Create `.github/ISSUE_TEMPLATE/user_story.yml`:
```yaml
name: User Story
description: Small, implementable piece of functionality
title: "[STORY] "
labels: ["user-story", "needs-review"]
assignees: []
body:
  - type: markdown
    attributes:
      value: |
        ## User Story Overview
        Use this template for small, implementable pieces of functionality that can be completed in 1-3 days.

  - type: input
    id: parent_feature
    attributes:
      label: Parent Feature
      description: Link to the feature this story belongs to (use #issue_number)
      placeholder: "#456"
    validations:
      required: true

  - type: textarea
    id: user_story
    attributes:
      label: User Story
      description: "As a [user type], I want [specific action] so that [immediate benefit]"
      placeholder: "As a developer, I want to see a 'Login with GitHub' button so that I can start the authentication process"
    validations:
      required: true

  - type: textarea
    id: acceptance_criteria
    attributes:
      label: Acceptance Criteria
      description: Specific, testable criteria (Given/When/Then format preferred)
      placeholder: "Given I am on the login page\nWhen I click the 'Login with GitHub' button\nThen I am redirected to GitHub OAuth page"
    validations:
      required: true

  - type: textarea
    id: implementation_notes
    attributes:
      label: Implementation Notes
      description: Technical details and approach
      placeholder: "- Add OAuth button component\n- Configure GitHub App credentials\n- Implement redirect handler"

  - type: dropdown
    id: story_points
    attributes:
      label: Story Points
      description: Effort estimate in story points
      options:
        - "1 - Very Small"
        - "2 - Small"
        - "3 - Medium"
        - "5 - Large"
        - "8 - Very Large"
    validations:
      required: true

  - type: textarea
    id: definition_of_done
    attributes:
      label: Definition of Done
      description: Checklist for story completion
      placeholder: "- [ ] Code implemented\n- [ ] Unit tests written\n- [ ] Code reviewed\n- [ ] Feature tested\n- [ ] Documentation updated"
    validations:
      required: true
```

### Bug Report Template
Create `.github/ISSUE_TEMPLATE/bug.yml`:
```yaml
name: Bug Report
description: Report a bug or issue
title: "[BUG] "
labels: ["bug", "needs-triage"]
assignees: []
body:
  - type: textarea
    id: description
    attributes:
      label: Bug Description
      description: Clear description of the bug
    validations:
      required: true

  - type: textarea
    id: steps
    attributes:
      label: Steps to Reproduce
      description: Step-by-step instructions to reproduce the bug
      placeholder: "1. Go to...\n2. Click on...\n3. See error"
    validations:
      required: true

  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
      description: What should happen
    validations:
      required: true

  - type: textarea
    id: actual
    attributes:
      label: Actual Behavior
      description: What actually happens
    validations:
      required: true

  - type: dropdown
    id: severity
    attributes:
      label: Severity
      options:
        - "Critical - System unusable"
        - "High - Major functionality broken"
        - "Medium - Minor functionality affected"
        - "Low - Cosmetic or enhancement"
    validations:
      required: true
```

## 2. GitHub Labels Configuration

### Priority Labels
```bash
gh label create "critical" --description "Critical priority" --color "b60205"
gh label create "high" --description "High priority" --color "d93f0b"
gh label create "medium" --description "Medium priority" --color "fbca04"
gh label create "low" --description "Low priority" --color "0e8a16"
```

### Type Labels
```bash
gh label create "epic" --description "Large feature spanning multiple iterations" --color "5319e7"
gh label create "feature" --description "Specific functionality within an epic" --color "0052cc"
gh label create "user-story" --description "Small implementable functionality" --color "1d76db"
gh label create "bug" --description "Bug report" --color "d73a4a"
gh label create "spike" --description "Investigation or research task" --color "e99695"
```

### Status Labels
```bash
gh label create "needs-review" --description "Requires stakeholder review" --color "fbca04"
gh label create "needs-approval" --description "Awaiting approval" --color "d4c5f9"
gh label create "approved" --description "Approved for implementation" --color "0e8a16"
gh label create "in-progress" --description "Currently being worked on" --color "1d76db"
gh label create "blocked" --description "Blocked by dependency" --color "b60205"
gh label create "ready-for-dev" --description "Ready for development" --color "0e8a16"
gh label create "ready-for-test" --description "Ready for testing" --color "5319e7"
gh label create "ai-reviewed" --description "Reviewed by AI agent for completeness" --color "0052cc"
```

### Domain Labels
```bash
gh label create "ui" --description "User interface related" --color "c5def5"
gh label create "api" --description "API or backend related" --color "f9d0c4"
gh label create "docs" --description "Documentation" --color "fef2c0"
gh label create "infrastructure" --description "Infrastructure and deployment" --color "d4c5f9"
gh label create "ai-integration" --description "AI/ML integration" --color "0052cc"
```

### Iteration Labels
```bash
gh label create "current-iteration" --description "Current iteration work" --color "0e8a16"
gh label create "next-iteration" --description "Next iteration planned" --color "fbca04"
gh label create "future-iteration" --description "Future iteration backlog" --color "e99695"
gh label create "backlog" --description "Product backlog" --color "cccccc"
```

## 3. GitHub Projects Board Setup

### Create New Project
1. Go to repository ’ Projects tab
2. Click "New project"
3. Choose "Board" layout
4. Name: "Reckie Development Board"

### Configure Board Columns
Set up the following columns with automation:

1. **Backlog**
   - Automation: None
   - Purpose: Future items not yet prioritized

2. **Needs Review**
   - Automation: Auto-add items with "needs-review" label
   - Purpose: Items awaiting stakeholder review

3. **Needs Approval**
   - Automation: Auto-add items with "needs-approval" label
   - Purpose: Items awaiting final approval

4. **Ready for Development**
   - Automation: Auto-add items with "approved" and "ready-for-dev" labels
   - Purpose: Approved items ready to start

5. **In Progress**
   - Automation: Auto-add items with "in-progress" label
   - Auto-move when status changes to "in progress"
   - Purpose: Currently active work

6. **In Review**
   - Automation: Auto-add pull requests
   - Purpose: Code review and testing

7. **Done**
   - Automation: Auto-add closed issues and merged PRs
   - Purpose: Completed work

### Custom Fields Configuration
Add these custom fields to track additional information:

1. **Story Points** (Number)
   - For effort estimation

2. **Iteration** (Select)
   - Options: Current, Next, Future, Backlog

3. **AI Review Status** (Select)
   - Options: Pending, In Progress, Complete, Not Required

4. **Approval Status** (Select)
   - Options: Pending, Approved, Needs Changes, Rejected

5. **Business Value** (Select)
   - Options: High, Medium, Low

## 4. Workflow Configuration

### Issue Workflow States
Configure issue progression through these states:

1. **Creation** ’ `needs-review`
2. **Review** ’ `needs-approval` or `needs-changes`
3. **Approval** ’ `approved` + `ready-for-dev`
4. **Development** ’ `in-progress`
5. **Testing** ’ `ready-for-test`
6. **Completion** ’ `closed`

### Automated Actions Setup
Use GitHub Actions for automation:

```yaml
# .github/workflows/issue-management.yml
name: Issue Management
on:
  issues:
    types: [labeled, unlabeled]

jobs:
  manage-labels:
    runs-on: ubuntu-latest
    steps:
      - name: Auto-assign to project
        if: contains(github.event.label.name, 'epic') || contains(github.event.label.name, 'feature') || contains(github.event.label.name, 'user-story')
        uses: actions/add-to-project@v0.4.0
        with:
          project-url: https://github.com/users/FreeSideNomad/projects/1
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

## 5. AI Agent Integration Fields

### Repository Secrets Configuration
Configure these secrets for AI agent integration:

1. **OPENAI_API_KEY** - For AI review capabilities
2. **GITHUB_TOKEN** - For repository access
3. **AI_REVIEW_WEBHOOK_URL** - For AI agent notifications

### AI Review Workflow
1. New issues automatically trigger AI review
2. AI agents analyze for completeness
3. Missing criteria flagged with comments
4. AI review status updated in custom fields

## 6. Usage Instructions

### Creating an Epic
1. Use Epic template
2. Fill all required fields
3. Issue automatically gets `epic` and `needs-review` labels
4. Added to project board in "Needs Review" column

### Breaking Down Epics
1. Create Feature issues linked to Epic
2. Create User Stories linked to Features
3. Use parent issue references (#123)
4. Maintain traceability chain

### Approval Process
1. Stakeholders review in "Needs Review"
2. Move to "Needs Approval" after review
3. Final approval moves to "Ready for Development"
4. AI agents can begin implementation

### Iteration Planning
1. Use iteration labels to organize work
2. Current iteration items are implementation-ready
3. Future items remain high-level until promoted
4. Regular grooming sessions to promote items

This configuration supports the GitHub-native development approach outlined in the Development Process, enabling efficient tracking of epics, features, and user stories with proper approval workflows and AI agent integration.