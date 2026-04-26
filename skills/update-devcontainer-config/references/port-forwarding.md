---
title: Port Forwarding Configuration
---

# Port Forwarding Configuration

## Auto-Forwarding (Default)

By default, VS Code auto-detects ports from process output:
```
Listening on port 3000...
Server running at http://localhost:8080
```

**No configuration needed** for basic cases.

## Manual Port Forwarding

### Simple Array
```json
"forwardPorts": [3000, 5432, 8080]
```

### Host:Port Mapping
```json
"forwardPorts": ["db:5432", "cache:6379"]
```
Useful for Docker Compose multi-container setups.

## Port Attributes

### Basic Label
```json
"portsAttributes": {
  "3000": {
    "label": "Web Application"
  }
}
```

### Auto-Open Browser
```json
"portsAttributes": {
  "3000": {
    "label": "Web App",
    "onAutoForward": "openBrowser"
  }
}
```

Options:
- `notify` - Show notification (default)
- `openBrowser` - Open system browser
- `openBrowserOnce` - Open only first time
- `openPreview` - Open in VS Code preview
- `silent` - No action
- `ignore` - Don't forward

### Protocol Configuration
```json
"portsAttributes": {
  "3000": {
    "protocol": "http"
  },
  "3443": {
    "protocol": "https"
  }
}
```

### Privileged Ports
```json
"portsAttributes": {
  "443": {
    "elevateIfNeeded": true
  }
}
```
Required for ports < 1024 on some systems.

## Default Attributes

Apply to all non-configured ports:
```json
"otherPortsAttributes": {
  "onAutoForward": "silent"
}
```

## Port Ranges

```json
"portsAttributes": {
  "3000-3100": {
    "label": "App Ports",
    "onAutoForward": "notify"
  }
}
```

## Regex Patterns

```json
"portsAttributes": {
  ".*\\/server\\.js": {
    "label": "Node Server"
  }
}
```
Match by process command line.

## Common Patterns

### Web Application
```json
"forwardPorts": [3000],
"portsAttributes": {
  "3000": {
    "label": "Web App",
    "onAutoForward": "openBrowser"
  }
}
```

### Database + App
```json
"forwardPorts": [3000, 5432],
"portsAttributes": {
  "3000": {
    "label": "Application",
    "onAutoForward": "openBrowser"
  },
  "5432": {
    "label": "PostgreSQL",
    "onAutoForward": "silent"
  }
}
```

### Multiple Services (Compose)
```json
"forwardPorts": ["web:3000", "api:8080", "db:5432"]
```

## Publishing vs Forwarding

### Publishing (appPort - Legacy)
```json
"appPort": 3000
```
- Container publishes port
- May require app to listen on 0.0.0.0
- Less secure (broader exposure)

### Forwarding (forwardPorts - Recommended)
```json
"forwardPorts": [3000]
```
- Secure tunnel from host to container
- App can listen on localhost
- No additional exposure

**Prefer `forwardPorts`** over `appPort`.

## Troubleshooting

### Port Not Forwarding
- Check if port is actually listening
- Verify process output format
- Check firewall settings
- Try manual forwardPorts configuration

### Port Already in Use
- Use `requireLocalPort: false` to allow alternate port
- Or choose different local port

### Browser Not Opening
- Check `onAutoForward` setting
- Verify protocol (http vs https)
- Check browser/OS permissions

## Best Practices

1. **Use forwardPorts** instead of appPort
2. **Label ports** for clarity in UI
3. **Set onAutoForward** appropriately
4. **Forward only needed ports** (security)
5. **Use ranges** for dynamic port allocation
