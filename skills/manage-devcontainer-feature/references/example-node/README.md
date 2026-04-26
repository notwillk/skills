# Node.js Devcontainer Feature

Installs [Node.js](https://nodejs.org/) and npm from official distributions.

## Usage

```json
{
  "features": {
    "ghcr.io/your-username/devcontainer-features/node": {
      "version": "20"
    }
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Node.js version (latest, lts, 20, 18, 16) |

## Architecture Support

- x86_64 (x64)
- arm64 (arm64)
- armv7l (limited versions)

## License

MIT
