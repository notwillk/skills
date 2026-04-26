# Devcontainer Feature JSON Schema Reference

## Required Properties

| Property | Type | Description |
|----------|------|-------------|
| `id` | string | Feature identifier, must match directory name |
| `version` | string | Semantic version (MAJOR.MINOR.PATCH) |
| `name` | string | Human-readable display name |

## Optional Properties

| Property | Type | Description |
|----------|------|-------------|
| `description` | string | Brief description of the feature |
| `documentationURL` | string | URL to feature documentation |
| `licenseURL` | string | URL to license file |
| `keywords` | array | Search terms for discovery |
| `options` | object | User-configurable options |
| `containerEnv` | object | Environment variables to set |
| `privileged` | boolean | Run container in privileged mode |
| `init` | boolean | Add --init to container |
| `capAdd` | array | Add Linux capabilities |
| `securityOpt` | array | Security options |
| `entrypoint` | string | Custom entrypoint script |
| `customizations` | object | Tool-specific settings |
| `dependsOn` | object | Hard dependencies (must be satisfied) |
| `installsAfter` | array | Soft dependencies (ordering hint) |
| `legacyIds` | array | Previous names for this feature |
| `deprecated` | boolean | Mark feature as deprecated |
| `mounts` | array | Additional volume mounts |
| `onCreateCommand` | string/array | Lifecycle hook |
| `updateContentCommand` | string/array | Lifecycle hook |
| `postCreateCommand` | string/array | Lifecycle hook |
| `postStartCommand` | string/array | Lifecycle hook |
| `postAttachCommand` | string/array | Lifecycle hook |

## Options Format

```json
{
  "options": {
    "optionName": {
      "type": "string" | "boolean",
      "default": "default-value",
      "description": "What this option does",
      "proposals": ["suggested", "values"],
      "enum": ["only", "allowed", "values"]
    }
  }
}
```

## Example: Complete Feature Definition

```json
{
  "id": "my-feature",
  "version": "1.2.0",
  "name": "My Feature",
  "description": "Installs and configures My Tool",
  "documentationURL": "https://example.com/docs",
  "keywords": ["tool", "cli", "productivity"],
  "options": {
    "version": {
      "type": "string",
      "default": "latest",
      "description": "Version to install",
      "proposals": ["latest", "1.0.0"]
    },
    "installPath": {
      "type": "string",
      "default": "/usr/local/bin",
      "description": "Where to install the binary"
    }
  },
  "containerEnv": {
    "MY_TOOL_HOME": "/usr/local/share/my-tool"
  },
  "installsAfter": [
    "ghcr.io/devcontainers/features/common-utils"
  ],
  "customizations": {
    "vscode": {
      "extensions": ["my-extension.publisher"]
    }
  }
}
```

## Environment Variable Resolution

Options become environment variables in `install.sh`:

| Option Name | Environment Variable |
|-------------|---------------------|
| `version` | `VERSION` |
| `installPath` | `INSTALLPATH` |
| `enableFeature` | `ENABLEFEATURE` |

Rules:
- Converted to UPPERCASE
- Non-alphanumeric characters replaced with `_`
- Leading digits replaced with `_`

## DependsOn vs InstallsAfter

### dependsOn (Hard Dependencies)

```json
{
  "dependsOn": {
    "ghcr.io/devcontainers/features/node": {
      "version": "18"
    },
    "ghcr.io/other/feature": {}
  }
}
```

- Feature **will not install** until dependencies are satisfied
- Can specify options for dependencies
- Evaluated recursively
- Can reference by ID only if in same repo

### installsAfter (Soft Dependencies)

```json
{
  "installsAfter": [
    "ghcr.io/devcontainers/features/common-utils",
    "ghcr.io/other/feature"
  ]
}
```

- Only affects **ordering** if both features are being installed
- Cannot specify options
- Not evaluated recursively
- Dependency may not be installed at all

## Version Format

Must follow [Semantic Versioning](https://semver.org/):

```
MAJOR.MINOR.PATCH
```

- **MAJOR**: Breaking changes (rare for features)
- **MINOR**: New functionality, options, dependencies
- **PATCH**: Bug fixes, content updates

Examples: `1.0.0`, `2.1.3`, `0.5.0-beta`

## Legacy IDs (Renaming Features)

When renaming a feature:

```json
{
  "id": "new-feature-name",
  "version": "1.0.1",
  "legacyIds": [
    "old-feature-name"
  ]
}
```

- Continue version sequence (don't reset to 1.0.0)
- Add old ID to `legacyIds`
- Both IDs resolve to same feature
