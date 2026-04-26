# Python Devcontainer Feature

Installs [Python](https://www.python.org/) with pip and venv support.

## Usage

```json
{
  "features": {
    "ghcr.io/your-username/devcontainer-features/python": {
      "version": "3.11"
    }
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Python version (3.12, 3.11, 3.10, etc.) |

## Installation Method

On Ubuntu:
1. Uses [deadsnakes PPA](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa) for specific versions
2. Falls back to building from source if PPA unavailable

Other systems:
- Uses system package manager

## Architecture Support

- x86_64
- arm64 (may require source build)

## License

MIT
