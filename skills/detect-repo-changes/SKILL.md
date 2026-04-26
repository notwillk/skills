---
name: detect-repo-changes
description: >
  Detect file changes in a repository using multiple strategies. Use when you need to 
  identify what files have been modified, added, or deleted for tasks like version 
  bumping, change logging, or selective testing. Also applies when the user asks 
  "what changed", "which files were modified", or describes needing to know the 
  current state of the workspace — even without explicit git references.
license: MIT
compatibility: Works with or without git repositories
metadata:
  author: agentskills
  version: "1.0.0"
  category: repository-tools
---

# Detect Repository Changes

Detect what files have changed in a repository using a cascade of detection methods:
1. Git commits since branch point (if git available with history)
2. Uncommitted changes (if git available, working tree dirty)
3. Agent's knowledge of recent modifications (fallback)

## Quick Start

To detect changes:

1. Check if git is available and has history
2. Try git-based detection (commits since branch, uncommitted changes)
3. Fall back to agent knowledge if git unavailable
4. Present changes to user for confirmation

## Detection Methods

### Method 1: Git Commits Since Branch

Detect changes by comparing current branch to its parent:

```bash
# Find merge base with main/master
git merge-base HEAD main

# Get commits since merge base
git log --oneline <merge-base>..HEAD

# Get changed files
git diff --name-only <merge-base>..HEAD
```

**Use when:** Repository has git history with meaningful branch structure.

### Method 2: Uncommitted Changes

Detect changes in working directory not yet committed:

```bash
# Check working tree status
git status --porcelain

# Get list of modified/new/deleted files
git status --porcelain | grep -E '^[ MADRC]'
```

**Use when:** Git is available but changes haven't been committed yet.

### Method 3: Agent Knowledge

Use the agent's internal tracking of file modifications:

- Files created during this session
- Files edited using write/edit tools
- Directories created

**Use when:** Git is not available or doesn't reflect the changes.

## Output Format

Return a simple list of changed files:

```
/workspaces/project/src/feature-a/install.sh (modified)
/workspaces/project/src/feature-a/devcontainer-feature.json (modified)
/workspaces/project/src/feature-b/test.sh (added)
```

Or workspace-relative:

```
src/feature-a/install.sh (modified)
src/feature-b/test.sh (added)
```

## Workflow

### Step 1: Check Git Availability

```bash
# Check if git exists and we're in a repo
git rev-parse --git-dir 2>/dev/null && echo "Git available" || echo "No git"
```

### Step 2: Try Git Detection

If git is available:

1. Check for uncommitted changes: `git status --porcelain`
2. Check for commits since branch: `git log --oneline main..HEAD 2>/dev/null`
3. Combine both sources

### Step 3: Fall Back to Agent Knowledge

If git is not available or returns no changes:

1. Query agent's file operation history
2. List files created/modified in current session
3. Note: This is best-effort and may not capture all changes

### Step 4: Present and Confirm

Present detected changes to user:

```
Detected changes:
- src/feature-a/install.sh (modified)
- src/feature-a/devcontainer-feature.json (modified)

Is this correct? (yes/no/manual)
```

If user says "no" or "manual", ask them to specify which files changed.

## Gotchas

- **Git not initialized:** Repository may exist but not be a git repo
- **No commits yet:** New repo has no history to compare against
- **Detached HEAD:** Can't determine branch point
- **Agent knowledge gaps:** Agent may not track all external modifications
- **Path formats:** Be consistent - use absolute or relative, not mixed

## Examples

### Example 1: Detect for Version Bump

User: "Bump the version for my feature"

1. Run detection cascade
2. Find: `src/my-feature/install.sh` and `src/my-feature/devcontainer-feature.json`
3. Present: "Detected changes in src/my-feature/"
4. Confirm: "Minor bump (install mechanism unchanged)?"
5. Proceed with version bump

### Example 2: No Git Available

User: "What changed in my feature?"

1. Try git - not available
2. Fall back to agent knowledge
3. Find: "src/feature/install.sh was modified in this session"
4. Note: "Limited to agent-tracked changes; external edits not captured"

### Example 3: Manual Override

User: "Actually, I also manually edited the README"

1. Show detected changes
2. User selects "manual"
3. Ask: "Which additional files changed?"
4. User provides: `README.md`
5. Add to list and proceed

## Resources

- `references/git-detection-patterns.md` - Detailed git command reference
- `references/agent-tracking-notes.md` - Limitations of agent knowledge
