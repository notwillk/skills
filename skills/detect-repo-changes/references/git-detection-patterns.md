# Git Detection Patterns

## Common Git Commands for Change Detection

### Check Git Availability

```bash
# Verify git is installed
git --version

# Verify we're in a git repository
git rev-parse --git-dir 2>/dev/null
# Returns path to .git directory or error
```

### Detect Uncommitted Changes

```bash
# Short format status (porcelain = machine readable)
git status --porcelain

# Output format:
# XY PATH or XY ORIG_PATH -> PATH
# X = index status, Y = working tree status
# M = modified, A = added, D = deleted, R = renamed, C = copied, U = updated but unmerged

# Get just the filenames
git status --porcelain | awk '{print $2}'

# Get only modified files
git status --porcelain | grep '^ M' | awk '{print $2}'

# Get only added files
git status --porcelain | grep '^A' | awk '{print $2}'
```

### Detect Committed Changes (Since Branch Point)

```bash
# Find merge base with main branch
git merge-base HEAD main

# Alternative: try origin/main if main not present locally
git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD main 2>/dev/null

# Get files changed since merge base
MERGE_BASE=$(git merge-base HEAD main)
git diff --name-only $MERGE_BASE..HEAD

# Get detailed diff stats
git diff --stat $MERGE_BASE..HEAD
```

### Handle New Repositories (No History)

```bash
# Check if there are any commits
git rev-parse HEAD 2>/dev/null
# Returns error if no commits yet

# List all tracked files in new repo
git ls-files

# Show first commit (if exists)
git log --oneline -1 2>/dev/null || echo "No commits yet"
```

### Handle Detached HEAD

```bash
# Check if in detached HEAD state
git symbolic-ref --short HEAD 2>/dev/null || echo "DETACHED"

# When detached, compare to main or use reflog
git diff --name-only main..HEAD 2>/dev/null || git diff --name-only HEAD@{1}..HEAD
```

### Combine Multiple Sources

```bash
# Get uncommitted changes
git status --porcelain | grep -E '^[ MADRC]' | awk '{print $2}' > /tmp/uncommitted.txt

# Get committed changes since branch
MERGE_BASE=$(git merge-base HEAD main 2>/dev/null || echo "")
if [ -n "$MERGE_BASE" ]; then
  git diff --name-only $MERGE_BASE..HEAD > /tmp/committed.txt
fi

# Combine and deduplicate
cat /tmp/uncommitted.txt /tmp/committed.txt 2>/dev/null | sort -u
```

## Change Classification

### File Status Codes

| Code | Meaning |
|------|---------|
| `M` | Modified |
| `A` | Added (staged) |
| `D` | Deleted |
| `R` | Renamed |
| `C` | Copied |
| `U` | Updated but unmerged |
| `??` | Untracked |
| `MM` | Staged and then modified again |

### Classify Changes by Path

```bash
# Group by feature (for devcontainer features)
git diff --name-only | grep '^src/' | cut -d'/' -f2 | sort -u

# Group by directory depth
git diff --name-only | awk -F'/' '{print $1}' | sort | uniq -c
```

## Error Handling

### Common Error Cases

```bash
# Not a git repository
git rev-parse --git-dir  # Returns: "fatal: not a git repository"

# No commits yet
git log --oneline        # Returns: "fatal: your current branch 'main' does not have any commits yet"

# No upstream branch
git merge-base HEAD main # Returns: "fatal: Not a valid object name main"
```

### Graceful Degradation

```bash
#!/bin/bash
set -e

# Try git detection
git_available=false
if git rev-parse --git-dir > /dev/null 2>&1; then
  git_available=true
fi

if [ "$git_available" = true ]; then
  # Try to get changes from git
  changes=$(git status --porcelain 2>/dev/null | awk '{print $2}' || true)
  
  if [ -z "$changes" ]; then
    # Try commits since branch
    merge_base=$(git merge-base HEAD main 2>/dev/null || git merge-base HEAD origin/main 2>/dev/null || true)
    if [ -n "$merge_base" ]; then
      changes=$(git diff --name-only $merge_base..HEAD 2>/dev/null || true)
    fi
  fi
  
  if [ -n "$changes" ]; then
    echo "$changes"
    exit 0
  fi
fi

# Fall back to agent knowledge
echo "Git detection unsuccessful, falling back to agent knowledge"
# ... agent knowledge retrieval ...
```
