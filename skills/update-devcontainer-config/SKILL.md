---
name: update-devcontainer-config
description: >
  Modify existing devcontainer configurations — add features (languages, databases, tools), 
  configure port forwarding, set environment variables, update base images, or modify 
  lifecycle scripts. Use when extending a current devcontainer setup with new capabilities 
  or changing existing configuration. Also applies when the user mentions "adding Redis to 
  my devcontainer", "configure ports", "update my devcontainer image", or describes 
  modifications to an existing setup — even if they don't explicitly mention 
  "devcontainer.json".
license: MIT
compatibility: Requires access to devcontainer.json file
metadata:
  author: agentskills
  version: "1.0.0"
  category: devcontainer-management
---

# Update Devcontainer Configuration

This skill helps you safely modify and extend existing `devcontainer.json` configurations. It reads your current setup, suggests appropriate additions, and validates changes.

## Quick Start

To update your devcontainer:

1. Read the existing `devcontainer.json` file
2. Identify what needs to be added or modified
3. For features: Ask permission, then call `find-devcontainer-feature` if needed
4. Make safe modifications (preserve existing config)
5. Validate the updated configuration

## Common Update Scenarios

### Adding a Feature

**When user specifies feature ID:**
```json
"features": {
  "ghcr.io/devcontainers/features/node": {
    "version": "18"
  }
}
```

**When user doesn't specify feature ID:**
1. Ask: "Would you like me to search for available features?"
2. If yes: Call `find-devcontainer-feature` with the tool/service description
3. Present options and let user select
4. Add selected feature with appropriate options

### Adding Port Forwarding

Add to `forwardPorts` array:
```json
"forwardPorts": [3000, 5432, "db:5432"]
```

Or configure with attributes:
```json
"portsAttributes": {
  "3000": {
    "label": "Application",
    "onAutoForward": "openBrowser"
  }
}
```

### Adding Environment Variables

Use `containerEnv` for all processes:
```json
"containerEnv": {
  "DATABASE_URL": "postgres://localhost:5432/mydb"
}
```

Use `remoteEnv` for tool-specific variables:
```json
"remoteEnv": {
  "EDITOR": "code"
}
```

### Updating Base Image

Change the `image` property:
```json
"image": "mcr.microsoft.com/devcontainers/python:3.11"
```

Or update Dockerfile reference:
```json
"build": {
  "dockerfile": "Dockerfile",
  "args": {
    "PYTHON_VERSION": "3.11"
  }
}
```

### Modifying Lifecycle Scripts

Append to existing or add new:
```json
"postCreateCommand": "npm install && npm run build",
"postStartCommand": "npm start"
```

## Workflow

### Step 1: Read Current Configuration

Always start by reading the existing `devcontainer.json`:

```bash
# Check common locations
cat .devcontainer/devcontainer.json 2>/dev/null || \
cat .devcontainer.json 2>/dev/null || \
cat .devcontainer/*/devcontainer.json 2>/dev/null
```

### Step 2: Analyze Structure

Identify what's already configured:
- Base image or Dockerfile
- Existing features
- Port forwarding setup
- Environment variables
- Lifecycle scripts
- Customizations

### Step 3: Plan Modifications

**Before making changes:**
1. Explain what will be added/modified
2. Show the current vs. proposed state
3. Ask for confirmation

**Safe modification principles:**
- Append to arrays (don't overwrite)
- Add new properties (don't remove existing)
- Preserve user customizations
- Maintain proper JSON structure

### Step 4: Feature Lookup (When Needed)

If user requests a feature but doesn't provide ID:

**Ask permission:**
"Would you like me to search for available [tool] features?"

**If yes, call sub-skill:**
```
Use find-devcontainer-feature to search for: [tool description]
```

**Present results:**
- Show feature ID, description, and source
- Let user select preferred option
- Proceed with installation

### Step 5: Validate Changes

After modifications, validate:

1. **JSON syntax:** Must be valid JSON (no trailing commas)
2. **Required fields:** Check `name` is present
3. **Image/Dockerfile:** At least one base source
4. **Feature IDs:** Valid format (ghcr.io/..., docker.io/...)
5. **Port formats:** Valid port numbers or "host:port" strings

### Step 6: Apply and Test

```bash
# Rebuild devcontainer
devcontainer rebuild

# Or reload window in VS Code
# Command palette: "Dev Containers: Rebuild Container"
```

## Gotchas

- **workspaceFolder requires workspaceMount:** If setting custom `workspaceFolder`, you must also set `workspaceMount`
- **containerEnv vs remoteEnv:** containerEnv sets for all processes; remoteEnv only for IDE/tools
- **Feature versions:** Omit version for "latest", but pinned versions are safer
- **Lifecycle script order:** initializeCommand (host) → onCreateCommand → updateContentCommand → postCreateCommand → postStartCommand → postAttachCommand
- **Array syntax matters:** `["cmd", "arg"]` vs `"cmd arg"` (shell vs direct execution)
- **Port conflicts:** If local port is in use, forwarding may fail silently or use alternate port

## Environment Variable Selection Guide

**Use `containerEnv` when:**
- Variable needed by all container processes
- Database connections, API endpoints
- Static for container lifetime
- Example: `DATABASE_URL`, `NODE_ENV`

**Use `remoteEnv` when:**
- Variable only for IDE/tools
- User-specific settings
- May change without rebuild
- Example: `EDITOR`, `SHELL`

## Port Forwarding Decision Tree

**Auto-forward (default behavior):**
- Processes that log "Listening on port X"
- VS Code auto-detects and forwards
- No config needed for simple cases

**Manual forwardPorts:**
- Services starting before IDE connects
- Non-standard port detection
- Need specific host:port mapping

**With attributes:**
- Need specific labels
- Want auto-open browser
- Require privileged ports

## Validation Checklist

Before applying changes:

- [ ] JSON syntax is valid (no trailing commas)
- [ ] Required fields present (name, image/build)
- [ ] Feature IDs use valid registry format
- [ ] Port numbers are valid (0-65535)
- [ ] Environment variable names are valid (no spaces, special chars)
- [ ] Lifecycle scripts reference valid paths
- [ ] Changes preserve existing configuration

## Examples

### Add Node.js Feature

**Before:**
```json
{
  "name": "My Project",
  "image": "mcr.microsoft.com/devcontainers/python:3.11"
}
```

**After:**
```json
{
  "name": "My Project",
  "image": "mcr.microsoft.com/devcontainers/python:3.11",
  "features": {
    "ghcr.io/devcontainers/features/node": {
      "version": "18"
    }
  }
}
```

### Add Port with Label

**Before:**
```json
{
  "forwardPorts": [3000]
}
```

**After:**
```json
{
  "forwardPorts": [3000, 5432],
  "portsAttributes": {
    "3000": {
      "label": "Web App",
      "onAutoForward": "openBrowser"
    },
    "5432": {
      "label": "PostgreSQL",
      "onAutoForward": "silent"
    }
  }
}
```

### Update Post-Create Command

**Before:**
```json
{
  "postCreateCommand": "pip install -r requirements.txt"
}
```

**After:**
```json
{
  "postCreateCommand": "pip install -r requirements.txt && python setup.py"
}
```

## Resources

- `references/devcontainer-properties.md` - Complete property reference
- `references/feature-installation.md` - Feature installation details
- `references/port-forwarding.md` - Port configuration patterns
- `find-devcontainer-feature` - Search for available features
- `debug-devcontainer-build` - Troubleshoot build issues
