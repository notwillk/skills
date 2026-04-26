# Agent Knowledge Tracking - Limitations and Notes

## What the Agent Can Track

The agent has knowledge of file operations performed during the current conversation session:

### Tracked Operations
- **write tool**: Creating new files
- **edit tool**: Modifying existing files
- **bash tool with file creation**: Some file operations via shell

### NOT Tracked
- External file editors (vim, nano, code)
- Git operations (git checkout, git merge)
- Automated tools running outside agent context
- File system changes by other processes

## Best Practices for Detection

### When Git is Unavailable

1. **Check agent's file history**
   - List files created with write tool
   - List files modified with edit tool
   - Note directories created

2. **Inform user of limitations**
   - "Change detection limited to agent-tracked operations"
   - "External edits may not be captured"

3. **Ask for manual confirmation**
   - Present what agent knows
   - Ask: "Are there any other files that changed?"

### Confidence Levels

| Source | Confidence | Notes |
|--------|------------|-------|
| Git commits | High | Complete history, reliable |
| Git uncommitted | High | Current state, reliable |
| Agent tracked | Medium | Session-only, may miss external edits |
| User reported | Variable | Depends on user accuracy |

## Detecting by Feature

For devcontainer features, when git detection fails:

### Pattern 1: Check common feature paths

```bash
# List all features
ls -la src/*/devcontainer-feature.json 2>/dev/null || echo "No features found"

# Check for install.sh modifications
stat -c "%Y %n" src/*/install.sh 2>/dev/null | sort -rn | head -5
```

### Pattern 2: Ask about feature context

User wants to bump version for "my-feature":

1. Check if `src/my-feature/` exists
2. Look for `install.sh` and `devcontainer-feature.json`
3. Ask: "Did you modify install.sh, devcontainer-feature.json, or both?"

### Pattern 3: Timestamp comparison

If files exist, compare timestamps (if available in environment):

```bash
# Find recently modified files (if find/mtime available)
find src -type f -mtime -1 2>/dev/null
```

## Fallback Strategy

When all detection methods fail:

1. **State clearly**: "Automatic change detection was unsuccessful"
2. **Provide options**:
   - Manual file specification
   - Assume all features changed (conservative)
   - Skip detection (user manages manually)

3. **Version bump directly**:
   - Ask: "What type of version bump? (patch/minor/major)"
   - Don't require file detection for version bump
