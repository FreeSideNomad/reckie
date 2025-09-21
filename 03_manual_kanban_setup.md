# Manual GitHub Projects Kanban Board Setup

## Overview
Complete these steps in the GitHub web interface to finalize your Reckie development board configuration. The CLI has already created custom fields, but the Status field columns need manual configuration.

**Project URL**: https://github.com/users/FreeSideNomad/projects/4

## Custom Fields Already Created ✅
- **Story Points** (Number) - For effort estimation
- **Iteration** (Single Select) - Current, Next, Future, Backlog
- **AI Review Status** (Single Select) - Pending, In Progress, Complete, Not Required
- **Approval Status** (Single Select) - Pending, Approved, Needs Changes, Rejected
- **Business Value** (Single Select) - High, Medium, Low

## Manual Setup Required

### 1. Configure Status Field (Kanban Columns)
Navigate to your project settings and update the **Status** field to have these options:

1. **Backlog**
   - Description: Future items not yet prioritized
   - Color: Gray

2. **Needs Review**
   - Description: Items awaiting stakeholder review
   - Color: Yellow
   - Automation: Auto-add items with "needs-review" label

3. **Needs Approval**
   - Description: Items awaiting final approval
   - Color: Purple
   - Automation: Auto-add items with "needs-approval" label

4. **Ready for Development**
   - Description: Approved items ready to start
   - Color: Green
   - Automation: Auto-add items with "approved" and "ready-for-dev" labels

5. **In Progress**
   - Description: Currently active work
   - Color: Blue
   - Automation: Auto-add items with "in-progress" label

6. **In Review**
   - Description: Code review and testing
   - Color: Orange
   - Automation: Auto-add pull requests

7. **Done**
   - Description: Completed work
   - Color: Green
   - Automation: Auto-add closed issues and merged PRs

### 2. Set Up Automations

#### Navigate to Project Settings → Workflows

**Add these automations:**

1. **Auto-add to project**
   - When: Item is created
   - Conditions: Label is any of `epic`, `feature`, `user-story`, `bug`
   - Actions: Add to project

2. **Move to Needs Review**
   - When: Item is labeled
   - Conditions: Label is `needs-review`
   - Actions: Set Status to "Needs Review"

3. **Move to Needs Approval**
   - When: Item is labeled
   - Conditions: Label is `needs-approval`
   - Actions: Set Status to "Needs Approval"

4. **Move to Ready for Development**
   - When: Item is labeled
   - Conditions: Label is `approved` AND `ready-for-dev`
   - Actions: Set Status to "Ready for Development"

5. **Move to In Progress**
   - When: Item is labeled
   - Conditions: Label is `in-progress`
   - Actions: Set Status to "In Progress"

6. **Move to In Review (PRs)**
   - When: Pull request is opened
   - Actions: Set Status to "In Review"

7. **Move to Done**
   - When: Item is closed
   - Actions: Set Status to "Done"

### 3. Configure Board Views

#### Create these saved views:

1. **Current Iteration Board**
   - Filter: Iteration = "Current"
   - Group by: Status
   - Sort: Priority (High to Low)

2. **Next Iteration Planning**
   - Filter: Iteration = "Next"
   - Group by: Status
   - Sort: Business Value (High to Low)

3. **Epic Overview**
   - Filter: Labels contains "epic"
   - Group by: Approval Status
   - Sort: Business Value (High to Low)

4. **AI Review Queue**
   - Filter: AI Review Status = "Pending" OR "In Progress"
   - Group by: AI Review Status
   - Sort: Priority (High to Low)

### 4. Set Default View
Set the **Current Iteration Board** as your default view so team members see active work immediately.

## Usage Examples

### Creating an Epic via CLI
```bash
gh issue create \
  --title "[EPIC] Requirements Management System" \
  --body "Large capability for capturing and managing requirements with AI assistance" \
  --label "epic,needs-review,high,current-iteration"
```

### Moving Items Through Workflow
```bash
# After stakeholder review
gh issue edit 123 --add-label "needs-approval" --remove-label "needs-review"

# After approval
gh issue edit 123 --add-label "approved,ready-for-dev" --remove-label "needs-approval"

# Start development
gh issue edit 123 --add-label "in-progress" --remove-label "ready-for-dev"
```

### Setting Custom Fields via Web Interface
1. Open issue in project board
2. Set Story Points: 5
3. Set Iteration: Current
4. Set AI Review Status: Complete
5. Set Approval Status: Approved
6. Set Business Value: High

## Integration with Development Process

### Issue Progression Flow
1. **Creation** → Backlog (auto)
2. **Review** → Needs Review (label: `needs-review`)
3. **Approval** → Needs Approval (label: `needs-approval`)
4. **Development** → Ready for Development (label: `approved` + `ready-for-dev`)
5. **Implementation** → In Progress (label: `in-progress`)
6. **Testing** → In Review (PR created)
7. **Completion** → Done (issue closed)

### AI Agent Integration
- Issues labeled `ai-reviewed` indicate AI completeness check passed
- AI Review Status tracks agent analysis progress
- Approval Status tracks human review workflow
- Automations move items based on label changes

## Verification Checklist

After setup, verify:
- [ ] All 7 Status columns are configured
- [ ] Automations are working (test with a sample issue)
- [ ] Custom fields appear on issues
- [ ] Saved views are created and functional
- [ ] Default view is set to Current Iteration Board
- [ ] GitHub workflow triggers properly add items to project

This configuration supports the complete Reckie development methodology with proper tracking from epic creation through implementation completion.