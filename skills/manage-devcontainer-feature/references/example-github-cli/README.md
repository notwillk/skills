# GitHub CLI Devcontainer Feature

Installs the [GitHub CLI](https://cli.github.com/) (`gh`) for interacting with GitHub from the command line.

## Usage

```json
{
  "features": {
    "ghcr.io/your-username/devcontainer-features/github-cli": {
      "version": "latest"
    }
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Version of GitHub CLI to install |

## Architecture Support

- x86_64 (amd64)
- arm64 (aarch64)

## License

MIT
