---
name: manage-devcontainer-feature
description: >
  Create and update devcontainer features following containers.dev specification. Use when 
  creating new features, updating existing features with version bumps, adding configurable 
  options, or managing feature dependencies. Automatically detects changes and determines 
  version bump type (patch for content changes, minor for mechanism/dependency changes). 
  Also applies when the user mentions "create a feature", "update my feature", "bump 
  version", "add options to my feature", or describes maintaining devcontainer features 
  for distribution via OCI registries like ghcr.io.
license: MIT
compatibility: Requires directory write access, works with or without git
metadata:
  author: agentskills
  version: "1.0.0"
  category: devcontainer-authoring
---

# Manage Devcontainer Feature

Create, update, and maintain devcontainer features following best practices from the [containers.dev specification](https://containers.dev/implementors/features/).

## Quick Start

To create a new feature:

1. Detect repository structure (single or multi-feature)
2. Validate feature ID (unique, valid format)
3. Create `src/<id>/` directory structure
4. Generate `devcontainer-feature.json` with version 1.0.0
5. Generate `install.sh` from appropriate template
6. Generate `test.sh` (simple smoke test by default)
7. Optionally generate README.md
8. Ask about publishing workflow → delegate to `create-github-action`

To update a feature:

1. Detect changes using `detect-repo-changes`
2. Determine version bump type:
   - **Patch**: install.sh content changes (same mechanism), config updates
   - **Minor**: install mechanism changes, new options, dependency changes
3. Confirm with user
4. Update `devcontainer-feature.json` version
5. Document changes

## Feature Structure

```
src/<feature-id>/
├── devcontainer-feature.json    # Metadata and configuration
├── install.sh                   # Installation script (executable)
├── test.sh                      # Test script (optional but recommended)
└── README.md                    # Documentation (optional)
```

## Creating a Feature

### Step 1: Detect Repository Type

Check if this is a single feature or multi-feature repository:

```bash
# Check for existing src/ directory
ls -la src/ 2>/dev/null || echo "No src directory"

# Check for existing features
ls src/*/devcontainer-feature.json 2>/dev/null | wc -l
```

**Multi-feature repo:** Has `src/` directory with multiple feature subdirectories  
**Single feature repo:** Create `src/<id>/` at project root

### Step 2: Validate Feature ID

Rules for feature ID:
- Must be unique in repository
- Valid characters: alphanumeric, hyphens
- No spaces or special characters
- Must match directory name

```bash
# Check if ID already exists
grep -r "\"id\": \"$FEATURE_ID\"" src/*/devcontainer-feature.json 2>/dev/null
```

### Step 3: Choose Install Template

**Template A: Binary Download (Default)**  
Use when installing pre-built binaries from GitHub releases or URLs.

Examples: CLI tools, standalone applications

**Template B: Multi-Step Installation**  
Use when compiling from source or complex setup required.

Examples: Tools requiring build dependencies

**Template C: Package Manager**  
Use when installing via apt, npm, pip, cargo, etc.

Examples: Language-specific packages

### Step 4: Generate Files

**devcontainer-feature.json:**

```json
{
  "id": "your-feature",
  "version": "1.0.0",
  "name": "Your Feature Name",
  "description": "Brief description of what this feature installs",
  "options": {
    "version": {
      "type": "string",
      "default": "latest",
      "description": "Version to install"
    }
  }
}
```

**install.sh:**

```bash
#!/usr/bin/env bash
set -euo pipefail

# Options are passed as environment variables
VERSION="${VERSION:-latest}"

# Your installation logic here
# ...

# Verify installation
your-binary --version
```

**test.sh (Simple Smoke Test):**

```bash
#!/bin/bash
set -e
source dev-container-features-test-lib
check "<id> available" <main-binary> --version
reportResults
```

### Step 5: Handle Dependencies (Smart Detection)

Analyze `install.sh` for known patterns:

| Pattern | Auto-Action |
|---------|-------------|
| `npm` | Add `ghcr.io/devcontainers/features/node` to `installsAfter` |
| `pip` | Add `ghcr.io/devcontainers/features/python` to `installsAfter` |
| `cargo` | Add `ghcr.io/devcontainers/features/rustup` to `installsAfter` |
| `go get` | Add `ghcr.io/devcontainers/features/go` to `installsAfter` |
| `apt-get` | No dependency needed |
| Exotic (curl custom scripts) | Prompt user for guidance |

**Prompt for exotic commands:**

```
Detected command: npm install -g <package>
Options:
1. Add 'node' feature as dependency (recommended)
2. Handle differently (explain)
3. Leave as-is (may fail in minimal containers)
```

### Step 6: Scaffolding Complete

Ask user: "Would you like me to set up the publishing workflow?"

If yes → **Delegate to `create-github-action`** with devcontainer-publish template

Default workflow name: `publish-features.yml`

## Updating a Feature (Version Bump)

### Step 1: Detect Changes

Call `detect-repo-changes` focusing on `src/<feature-id>/`:

```bash
# Get changes for this feature only
git diff --name-only | grep "^src/$FEATURE_ID/" || echo "No changes detected"
```

### Step 2: Determine Bump Type

Analyze what changed:

| Change | Bump Type | Examples |
|--------|-----------|----------|
| `install.sh` - content fix, same mechanism | **Patch** | Fixed typo in URL, updated version |
| `install.sh` - mechanism change | **Minor** | Changed from curl to npm install |
| `devcontainer-feature.json` - config/description | **Patch** | Updated description |
| `devcontainer-feature.json` - new options | **Minor** | Added `version` option |
| `devcontainer-feature.json` - dependencies changed | **Minor** | Added `dependsOn` |
| `test.sh` - test changes | **Patch** | Fixed test assertion |

### Step 3: Confirm with User

Present detection results:

```
Detected changes in src/my-feature/:
- install.sh (mechanism: still uses curl download)
- devcontainer-feature.json (added version option)

Recommended: Minor bump (1.0.0 → 1.1.0)
Reason: New option added

Confirm? (yes/no/major/specify)
```

### Step 4: Apply Version Bump

Update `devcontainer-feature.json`:

```json
{
  "version": "1.1.0"  // Bumped from 1.0.0
}
```

### Step 5: Fallback (No Detection)

If `detect-repo-changes` fails:

```
Automatic change detection was unsuccessful.

Please specify version bump:
- patch (bugfixes, small changes)
- minor (new options, mechanism changes)
- major (breaking changes - rare)
- specify exact version
```

## Adding Options

### Step 1: Parse Existing Options

Read current `devcontainer-feature.json` options section.

### Step 2: Add New Option

```json
{
  "options": {
    "existingOption": { ... },
    "newOption": {
      "type": "string",  // or "boolean"
      "default": "default-value",
      "description": "What this option controls",
      "proposals": ["value1", "value2"]  // Optional suggestions
      // or "enum": ["strict1", "strict2"] for strict values
    }
  }
}
```

### Step 3: Update install.sh

Access option via environment variable (uppercase):

```bash
NEW_OPTION="${NEW_OPTION:-default-value}"

if [ "$NEW_OPTION" = "special-value" ]; then
  # Handle special case
fi
```

### Step 4: Bump Version

Adding an option is a **minor** change.

## Adding Dependencies

### Hard Dependencies (dependsOn)

Feature won't install until dependency is satisfied:

```json
{
  "dependsOn": {
    "ghcr.io/devcontainers/features/node": {}
  }
}
```

### Soft Dependencies (installsAfter)

Feature installs after another if both are present:

```json
{
  "installsAfter": [
    "ghcr.io/devcontainers/features/common-utils"
  ]
}
```

Always **bump minor version** when adding/changing dependencies.

## Complete Examples

See `references/example-github-cli/`, `references/example-node/`, `references/example-python/` for complete, working feature implementations.

## Gotchas

- **Version must always bump:** Never leave version unchanged when modifying files
- **ID must match directory:** `id` in JSON must equal folder name
- **install.sh must be executable:** chmod +x required
- **Architecture handling:** Always handle x86_64 and arm64/aarch64
- **Clean up:** Remove temp files and apt lists in install.sh
- **Verify at end:** install.sh should verify installation succeeded
- **Options become env vars:** `version` option → `VERSION` env var

## Resources

- `references/binary-install-template.sh` - Binary download pattern
- `references/multistep-install-template.sh` - Complex installation pattern
- `references/package-install-template.sh` - Package manager pattern
- `references/simple-test-template.sh` - Smoke test scaffold
- `references/devcontainer-feature-schema.md` - Full JSON schema
- `references/versioning-guide.md` - Detailed version bump rules
- `references/known-systems-reference.md` - Auto-detected dependencies
- `references/example-github-cli/` - Complete feature example
- `references/example-node/` - Complete feature example
- `references/example-python/` - Complete feature example

## Integration with Other Skills

**When creating a feature:**
- Use `detect-repo-changes` to verify what was created
- Delegate to `create-github-action` for publishing workflow

**When updating a feature:**
- Use `detect-repo-changes` to find what changed
- Determines version bump automatically
