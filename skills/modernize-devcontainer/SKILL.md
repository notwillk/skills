---
name: modernize-devcontainer
description: >
  Migrate and update legacy devcontainer configurations to current standards. Handle 
  schema version upgrades, deprecated property conversions (appPort to forwardPorts, 
  extensions to customizations), and legacy feature ID modernizations. Use when 
  updating old devcontainer.json files, converting deprecated formats, or aligning 
  with current spec versions. Also applies for "update my old devcontainer", "migrate 
  deprecated settings", or when working with configurations showing schema warnings.
license: MIT
compatibility: Requires existing devcontainer.json to modernize
metadata:
  author: agentskills
  version: "1.0.0"
  category: devcontainer-migration
---

# Modernize Devcontainer Configuration

Update legacy devcontainer configurations to current standards. This skill handles schema version upgrades, deprecated property migrations, and format conversions.

## Quick Start

To modernize a devcontainer:

1. Read existing `devcontainer.json`
2. Identify schema version and deprecated properties
3. Apply migrations
4. Validate updated configuration
5. Test rebuild

## Modernization Scenarios

### Schema Version Upgrade

**Detect current version:**
- No version field: Pre-1.0 schema
- `"version": "1.0"`: Legacy format
- Modern: No explicit version (spec-based)

**Migration steps:**
1. Update property names to current spec
2. Convert legacy formats
3. Remove deprecated fields
4. Add required fields if missing

### Deprecated Property Migration

#### `runArgs` to Orchestrator Properties

**Old:**
```json
"runArgs": ["--privileged"]
```

**New:**
```json
"privileged": true
```

#### `appPort` to `forwardPorts`

**Old:**
```json
"appPort": 3000
```

**New:**
```json
"forwardPorts": [3000]
```

#### `extensions` to `customizations`

**Old:**
```json
"extensions": ["dbaeumer.vscode-eslint"]
```

**New:**
```json
"customizations": {
  "vscode": {
    "extensions": ["dbaeumer.vscode-eslint"]
  }
}
```

#### `settings` to `customizations`

**Old:**
```json
"settings": {
  "editor.formatOnSave": true
}
```

**New:**
```json
"customizations": {
  "vscode": {
    "settings": {
      "editor.formatOnSave": true
    }
  }
}
```

### Feature ID Modernization

#### GitHub Releases to OCI Registry

**Old:**
```json
"features": {
  "https://github.com/owner/features/releases/download/v1.0.0/feature.tgz": {}
}
```

**New:**
```json
"features": {
  "ghcr.io/owner/features/name:1.0.0": {}
}
```

#### Docker Hub to OCI (if applicable)

**Old:**
```json
"features": {
  "docker.io/namespace/feature:1.0": {}
}
```

**New:**
```json
"features": {
  "ghcr.io/namespace/feature:1.0": {}
}
```

### Property Migration Table

| Deprecated Property | Modern Replacement | Notes |
|--------------------|---------------------|-------|
| `appPort` | `forwardPorts` | Array instead of single port |
| `extensions` | `customizations.vscode.extensions` | Namespaced under tool |
| `settings` | `customizations.vscode.settings` | Namespaced under tool |
| `devPort` | `forwardPorts` with attributes | Use port configuration |
| `userEnvProbe` | Same, but check valid values | Valid: none, interactiveShell, loginShell, loginInteractiveShell |

### Format Conversions

#### String Lifecycle Commands to Array

**Old:**
```json
"postCreateCommand": "npm install && npm run build"
```

**New (recommended):**
```json
"postCreateCommand": ["npm", "install"]
```

Or keep string if shell features needed:
```json
"postCreateCommand": "bash -c 'npm install && npm run build'"
```

## Modernization Workflow

### Step 1: Analyze Current Configuration

Read and identify:
- Schema version indicators
- Deprecated property usage
- Legacy feature IDs
- Outdated patterns

### Step 2: Plan Migrations

Create migration plan:
```markdown
## Migration Plan for devcontainer.json

### Properties to Update:
- [ ] appPort → forwardPorts
- [ ] extensions → customizations.vscode.extensions
- [ ] settings → customizations.vscode.settings

### Feature IDs to Update:
- [ ] https://github.com/... → ghcr.io/...:version

### Validations:
- [ ] Check for trailing commas
- [ ] Verify all migrations applied
- [ ] Test JSON validity
```

### Step 3: Apply Migrations

Apply changes one category at a time:
1. Property name updates
2. Feature ID conversions
3. Format changes
4. Add missing required fields

### Step 4: Validate Post-Migration

Check after migration:
- [ ] JSON is valid
- [ ] No deprecated properties remain
- [ ] Feature IDs use current format
- [ ] Required fields present
- [ ] No trailing commas

### Step 5: Test Rebuild

```bash
devcontainer rebuild
```

Verify:
- Container builds successfully
- Features install correctly
- Configuration applies as expected

## Common Modernization Patterns

### VS Code Settings Migration

**Before:**
```json
{
  "name": "My Project",
  "image": "mcr.microsoft.com/devcontainers/node:18",
  "extensions": ["dbaeumer.vscode-eslint"],
  "settings": {
    "editor.formatOnSave": true
  }
}
```

**After:**
```json
{
  "name": "My Project",
  "image": "mcr.microsoft.com/devcontainers/node:18",
  "customizations": {
    "vscode": {
      "extensions": ["dbaeumer.vscode-eslint"],
      "settings": {
        "editor.formatOnSave": true
      }
    }
  }
}
```

### Port Publishing to Forwarding

**Before:**
```json
{
  "image": "mcr.microsoft.com/devcontainers/node:18",
  "appPort": [3000, 3001]
}
```

**After:**
```json
{
  "image": "mcr.microsoft.com/devcontainers/node:18",
  "forwardPorts": [3000, 3001],
  "portsAttributes": {
    "3000": {
      "label": "Application"
    },
    "3001": {
      "label": "API"
    }
  }
}
```

### Feature Modernization

**Before:**
```json
{
  "features": {
    "https://github.com/devcontainers/features/releases/download/v1.0.0/node.tgz": {}
  }
}
```

**After:**
```json
{
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "18"
    }
  }
}
```

## Gotchas

- **Backup first:** Always backup before migration
- **One change at a time:** Test each migration
- **Feature versions:** Legacy features may not have exact version mapping
- **Customizations nesting:** VS Code settings now under `customizations.vscode`
- **Port array format:** `forwardPorts` accepts integers and strings
- **Lifecycle format:** Arrays preferred over strings for direct execution

## Pre-Migration Checklist

Before starting:
- [ ] Backup current devcontainer.json
- [ ] Check current rebuild works
- [ ] Note current feature versions
- [ ] Document current port setup
- [ ] List extensions currently installed

## Post-Migration Validation

After migration:
- [ ] JSON syntax valid
- [ ] No deprecated properties
- [ ] Feature IDs use OCI format
- [ ] Ports properly configured
- [ ] Extensions in customizations
- [ ] Settings in customizations
- [ ] Container rebuilds successfully
- [ ] All functionality preserved

## Resources

- containers.dev - Current specification
- `update-devcontainer-config` - Update after modernization
- `debug-devcontainer-build` - Troubleshoot migration issues
