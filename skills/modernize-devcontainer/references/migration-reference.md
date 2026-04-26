---
title: Migration Reference
---

# Devcontainer Migration Reference

## Schema Version History

### Pre-1.0 (Legacy)
- No explicit version field
- Direct `extensions` and `settings` properties
- GitHub Release URLs for features

### 1.0+ (Current)
- Spec-based (no explicit version needed)
- `customizations` namespace for tool settings
- OCI registry URLs for features

## Deprecated Properties Reference

### Fully Deprecated

| Property | Replaced By | Removal Version |
|----------|-------------|-----------------|
| `devPort` | `forwardPorts` | Pre-1.0 |
| `workspaceMount` + missing `workspaceFolder` | Both required | 1.0 |

### Migrated to Customizations

| Property | New Location | Notes |
|----------|--------------|-------|
| `extensions` | `customizations.vscode.extensions` | Tool-specific |
| `settings` | `customizations.vscode.settings` | Tool-specific |

### Format Changes

| Old Format | New Format | Example |
|------------|------------|---------|
| `appPort: 3000` | `forwardPorts: [3000]` | Array of ports |
| `runArgs: ["--privileged"]` | `privileged: true` | Direct property |

## Feature ID Evolution

### GitHub Release URLs (Deprecated)
```
https://github.com/OWNER/REPO/releases/download/VERSION/feature.tgz
```

### OCI Registry (Current)
```
ghcr.io/OWNER/NAMESPACE/NAME:VERSION
```

### Examples

**Old:**
```json
"features": {
  "https://github.com/devcontainers/features/releases/download/v1/node.tgz": {}
}
```

**New:**
```json
"features": {
  "ghcr.io/devcontainers/features/node:1": {}
}
```

## Common Migration Scenarios

### Scenario 1: Simple VS Code Setup

**Legacy:**
```json
{
  "name": "Node.js Project",
  "image": "node:18",
  "extensions": ["dbaeumer.vscode-eslint"],
  "settings": {
    "editor.formatOnSave": true
  }
}
```

**Modern:**
```json
{
  "name": "Node.js Project",
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

### Scenario 2: Port Forwarding

**Legacy:**
```json
{
  "appPort": [3000, "db:5432"]
}
```

**Modern:**
```json
{
  "forwardPorts": [3000, "db:5432"],
  "portsAttributes": {
    "3000": {
      "label": "Web App"
    }
  }
}
```

### Scenario 3: Features with Legacy URLs

**Legacy:**
```json
{
  "features": {
    "https://github.com/user/features/releases/download/v1.0.0/python.tgz": {}
  }
}
```

**Modern:**
```json
{
  "features": {
    "ghcr.io/user/features/python:1.0.0": {}
  }
}
```

## Breaking Changes by Version

### v1.0
- `extensions` moved to `customizations.vscode.extensions`
- `settings` moved to `customizations.vscode.settings`
- GitHub Release URLs deprecated for features
- `appPort` deprecated in favor of `forwardPorts`

### Migration Priority

**Critical (breaking):**
1. Feature ID format
2. Customizations namespace

**Recommended:**
1. Port forwarding format
2. Lifecycle command format

**Optional:**
1. String to array conversion
2. Property reordering
