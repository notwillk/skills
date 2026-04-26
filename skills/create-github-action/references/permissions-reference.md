# GitHub Actions Permissions Reference

## Overview

GitHub Actions permissions control what the workflow can access. Use principle of least privilege.

## Permission Scopes

### contents

Repository content access.

```yaml
permissions:
  contents: read    # Checkout code
  contents: write   # Push commits, create releases
```

Use cases:
- `read`: Checkout code, read files
- `write`: Push changes, create releases

### packages

GitHub Packages / Container Registry.

```yaml
permissions:
  packages: read    # Pull containers
  packages: write   # Push containers
  packages: none    # No access
```

Use cases:
- Publishing devcontainer features
- Pushing Docker images
- Downloading private packages

### actions

Workflow artifacts and caches.

```yaml
permissions:
  actions: read     # Download artifacts
  actions: write    # Upload artifacts
```

Use cases:
- Upload/download build artifacts
- Cache dependencies

### id-token

OIDC token for cloud provider authentication.

```yaml
permissions:
  id-token: write   # Required for OIDC
```

Use cases:
- AWS/GCP/Azure authentication without secrets

### pull-requests

Pull request operations.

```yaml
permissions:
  pull-requests: read    # Read PR data
  pull-requests: write   # Comment, label, merge
```

Use cases:
- Auto-comment on PRs
- Auto-merge PRs
- Label PRs

### issues

Issue operations.

```yaml
permissions:
  issues: write    # Create/update issues
```

Use cases:
- Create issue from workflow
- Auto-label issues

### security-events

Security alerts and code scanning.

```yaml
permissions:
  security-events: write   # Upload SARIF
```

Use cases:
- Upload security scan results

### deployments

Deployment operations.

```yaml
permissions:
  deployments: write   # Create deployments
```

Use cases:
- Deploy to environments

### checks

Check runs and results.

```yaml
permissions:
  checks: write    # Create/update checks
```

Use cases:
- Report test results
- Post check annotations

## Common Permission Sets

### Minimal (Read-only)

```yaml
permissions:
  contents: read
```

### Devcontainer Feature Publishing

```yaml
permissions:
  contents: read
  packages: write
```

### Build and Test

```yaml
permissions:
  contents: read
  actions: write
```

### Deploy to GitHub Pages

```yaml
permissions:
  contents: read
  pages: write
  id-token: write
```

### Release Creation

```yaml
permissions:
  contents: write
  packages: write
```

### Full Access

```yaml
permissions: write-all
```

**Not recommended** for security reasons.

## Permission Levels

| Level | Description |
|-------|-------------|
| `none` | No access |
| `read` | Read-only access |
| `write` | Read and write access |

## Workflow vs Job Permissions

### Workflow-level (applies to all jobs)

```yaml
permissions:
  contents: read
  packages: write

jobs:
  build:
    runs-on: ubuntu-latest
    # Inherits workflow permissions
```

### Job-level (overrides workflow)

```yaml
permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest
    # Uses workflow permissions
    
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write    # Additional permission
    # Job-specific permissions
```

## Default Permissions

### Open source repositories

```yaml
permissions:
  contents: read
```

### Private repositories

```yaml
permissions: write-all  # Everything!
```

**Recommendation:** Always specify explicit permissions.

## GITHUB_TOKEN Permissions

The `GITHUB_TOKEN` secret is automatically provided.

Default permissions based on:
- Repository type (public/private)
- `permissions` in workflow
- Repository/organization settings

Access scopes:
- Current repository only
- No access to other repositories
- No access to organization secrets

## Best Practices

1. **Always specify permissions** - Don't rely on defaults
2. **Use job-level for variation** - Different jobs need different access
3. **Start with minimal** - Add permissions as needed
4. **Document why** - Comment unusual permission needs
5. **Prefer read over write** - Only write when necessary

## Examples

### Safe default for most workflows

```yaml
permissions:
  contents: read
```

### Publishing workflow

```yaml
permissions:
  contents: read
  packages: write
```

### Release workflow

```yaml
permissions:
  contents: write    # Create release
  packages: write    # Push container
```

### PR automation

```yaml
permissions:
  contents: read
  pull-requests: write
  issues: write
```
