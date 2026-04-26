---
name: create-devcontainer-config
description: >
  Create a new devcontainer.json from scratch for projects without existing devcontainer 
  configuration. Bootstrap minimal working setups using pre-built images, Dockerfiles, 
  or Docker Compose. Use when initializing devcontainers for new projects, setting up 
  a devcontainer for the first time, or when no .devcontainer/devcontainer.json exists. 
  Also applies when the user says "I need a devcontainer", "setup devcontainers for my 
  project", or describes starting fresh — even without explicit "devcontainer.json" mentions.
license: MIT
compatibility: Requires project directory write access
metadata:
  author: agentskills
  version: "1.0.0"
  category: devcontainer-bootstrap
---

# Create Devcontainer Configuration

Bootstrap a new devcontainer from scratch. This skill creates a minimal working configuration, then delegates to `update-devcontainer-config` for customization.

## Quick Start

To create a new devcontainer:

1. Choose base approach (image, Dockerfile, or Docker Compose)
2. Create minimal devcontainer.json
3. Delegate to `update-devcontainer-config` for customization

## Bootstrap Approach

### Step 1: Choose Base Type

**Option A: Pre-built Image (Fastest)**
Use when you want a standard development environment.

```json
{
  "name": "My Project",
  "image": "mcr.microsoft.com/devcontainers/universal:2"
}
```

**Option B: Dockerfile (Customizable)**
Use when you need custom system packages or configuration.

```json
{
  "name": "My Project",
  "build": {
    "dockerfile": "Dockerfile",
    "context": "."
  }
}
```

**Option C: Docker Compose (Multi-container)**
Use when you need additional services like databases.

```json
{
  "name": "My Project",
  "dockerComposeFile": "docker-compose.yml",
  "service": "app",
  "workspaceFolder": "/workspace"
}
```

### Step 2: Create Configuration

Create `.devcontainer/devcontainer.json` with minimal config:

```json
{
  "name": "${PROJECT_NAME}",
  "image": "${BASE_IMAGE}",
  "forwardPorts": []
}
```

### Step 3: Delegate to Update Skill

After bootstrap, immediately invoke `update-devcontainer-config`:

```markdown
Basic devcontainer.json created. Now let's customize it:
- Add features you need (languages, databases, tools)
- Configure port forwarding for your services
- Set up environment variables
- Add lifecycle scripts

What would you like to add?
```

## Generic Templates

### Image-Based Template

```json
{
  "name": "Dev Container",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "forwardPorts": [],
  "postCreateCommand": "",
  "customizations": {
    "vscode": {
      "settings": {},
      "extensions": []
    }
  }
}
```

### Dockerfile-Based Template

```json
{
  "name": "Dev Container",
  "build": {
    "dockerfile": "Dockerfile",
    "context": "."
  },
  "forwardPorts": [],
  "postCreateCommand": ""
}
```

**With accompanying Dockerfile:**
```dockerfile
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install additional packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace
```

### Docker Compose Template

```json
{
  "name": "Dev Container",
  "dockerComposeFile": "docker-compose.yml",
  "service": "app",
  "workspaceFolder": "/workspace",
  "forwardPorts": []
}
```

**With accompanying docker-compose.yml:**
```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - ..:/workspace:cached
    command: sleep infinity
```

## Bootstrap Workflow

### 1. Detect Current Environment

Check what exists in project:
- Programming language (from package.json, requirements.txt, etc.)
- Existing Docker configuration
- Special requirements (databases, services)

### 2. Recommend Base Type

**Default recommendation:** Start with image-based for simplicity.

Use Dockerfile if:
- Need custom system packages
- Complex build requirements
- Specific OS requirements

Use Compose if:
- Need databases or services
- Multi-container architecture
- External dependencies

### 3. Create Minimal Config

Create the smallest working configuration:
- Name (use project name)
- Base (image/build/compose)
- Empty forwardPorts array
- Empty postCreateCommand

### 4. Create Supporting Files (if needed)

For Dockerfile approach:
```dockerfile
FROM mcr.microsoft.com/devcontainers/base:ubuntu
WORKDIR /workspace
```

For Compose approach:
```yaml
version: '3.8'
services:
  app:
    build: .
    volumes:
      - ..:/workspace:cached
    command: sleep infinity
```

### 5. Delegate to Update Skill

```markdown
✅ Created minimal devcontainer.json

Now let's customize it for your project:
1. Add language runtime (Node, Python, Go, etc.)
2. Configure database or services
3. Set up port forwarding
4. Add development tools

What would you like to add first?
```

Transfer to `update-devcontainer-config` skill for customization.

## Project Type Detection

### Node.js Projects
**Signs:** package.json, node_modules, .js/.ts files

**Suggested base:**
```json
{
  "image": "mcr.microsoft.com/devcontainers/node:18"
}
```

### Python Projects
**Signs:** requirements.txt, pyproject.toml, .py files

**Suggested base:**
```json
{
  "image": "mcr.microsoft.com/devcontainers/python:3.11"
}
```

### Go Projects
**Signs:** go.mod, go.sum, .go files

**Suggested base:**
```json
{
  "image": "mcr.microsoft.com/devcontainers/go:1.21"
}
```

### Rust Projects
**Signs:** Cargo.toml, Cargo.lock, .rs files

**Suggested base:**
```json
{
  "image": "mcr.microsoft.com/devcontainers/rust:1"
}
```

### Generic Projects
**Use universal image:**
```json
{
  "image": "mcr.microsoft.com/devcontainers/universal:2"
}
```

## Gotchas

- **Start minimal:** Don't add everything at once
- **Universal image:** Good default when unsure
- **Base images:** Use mcr.microsoft.com/devcontainers/ registry
- **Dockerfile path:** Must be relative to devcontainer.json
- **Compose service:** Must match service name in docker-compose.yml
- **Workspace mount:** Automatically handled for image/Dockerfile, manual for Compose

## Validation After Bootstrap

After creating config, validate:
- [ ] JSON is valid syntax
- [ ] devcontainer.json is in correct location
- [ ] Base image is accessible
- [ ] Dockerfile/Compose files exist (if using)
- [ ] Can rebuild successfully

## Next Steps After Bootstrap

1. **Rebuild container** to test basic setup
2. **Call update-devcontainer-config** to add features
3. **Test configuration** with actual project
4. **Iterate** based on needs

## Resources

- `update-devcontainer-config` - Customize the bootstrapped configuration
- `find-devcontainer-feature` - Discover features to add
- `references/base-images.md` - Available base images
- `references/templates.md` - Extended template options
