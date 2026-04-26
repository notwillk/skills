---
title: Feature Installation Patterns
---

# Feature Installation Patterns

## Common Feature Categories

### Language Runtimes
- **Node.js:** `ghcr.io/devcontainers/features/node`
  - Options: `version` (18, 20, latest)
  
- **Python:** `ghcr.io/devcontainers/features/python`
  - Options: `version` (3.11, 3.12)
  - Includes pip, setuptools
  
- **Go:** `ghcr.io/devcontainers/features/go`
  - Options: `version` (1.21, 1.22)

- **Rust:** `ghcr.io/devcontainers/features/rust`
  - Options: `version` (stable, nightly)

### Development Tools
- **Git:** `ghcr.io/devcontainers/features/git`
  - Usually pre-installed, use for specific version

- **GitHub CLI:** `ghcr.io/devcontainers/features/github-cli`
  - Includes `gh` command

- **Docker-in-Docker:** `ghcr.io/devcontainers/features/docker-in-docker`
  - Requires privileged mode

### Databases
- **PostgreSQL:** `ghcr.io/devcontainers/features/postgres`
  - Runs server in container

- **Redis:** `ghcr.io/devcontainers/features/redis`
  - Options: `version`

### Utilities
- **Common Utils:** `ghcr.io/devcontainers/features/common-utils`
  - Zsh, curl, wget, nano, etc.

- **Oh My Zsh:** `ghcr.io/devcontainers/features/oh-my-zsh`
  - Shell customization

## Feature ID Formats

### Official Features
```
ghcr.io/devcontainers/features/<name>[:version]
```

### Community Features
```
ghcr.io/<username>/devcontainer-features/<name>[:version]
```

### Docker Hub
```
docker.io/<username>/<name>[:version]
```

## Option Patterns

### Version Selection
```json
"ghcr.io/devcontainers/features/node": {
  "version": "18"
}
```

### Boolean Options
```json
"ghcr.io/devcontainers/features/python": {
  "installTools": true,
  "enablePipx": true
}
```

### Multiple Options
```json
"ghcr.io/devcontainers/features/docker-in-docker": {
  "version": "latest",
  "moby": true,
  "dockerDashComposeVersion": "v2"
}
```

## Installation Order

Features install automatically in order based on dependencies:

1. `dependsOn` - Hard dependencies (must be satisfied first)
2. `installsAfter` - Soft dependencies (prefer this order)
3. Automatic ordering based on internal dependency graph

Override with:
```json
"overrideFeatureInstallOrder": [
  "ghcr.io/devcontainers/features/common-utils",
  "ghcr.io/devcontainers/features/node"
]
```

## Troubleshooting Features

### Feature Not Found
- Check feature ID spelling
- Verify registry is accessible
- Check if feature exists in catalog

### Feature Installation Fails
- Check base image compatibility
- Review feature documentation
- Check for required options
- Try specific version instead of "latest"

### Conflicts Between Features
- Use `overrideFeatureInstallOrder` to control sequence
- Check if features modify same files
- Consider separate containers with Compose

## Best Practices

1. **Pin versions:** Use specific versions rather than "latest"
2. **Check compatibility:** Verify feature works with your base image
3. **Minimize features:** Only install what you need
4. **Test locally:** Verify feature works before committing
5. **Read docs:** Each feature has specific options and requirements
