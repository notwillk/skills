---
title: Extended Error Patterns
---

# Extended Devcontainer Error Patterns

## Dockerfile Build Errors

### Syntax Errors

**Unclosed quote:**
```
unexpected EOF while looking for matching `"'
```

**Invalid instruction:**
```
unknown instruction: XYZ
```

### COPY Failures

**File not found:**
```
COPY failed: file not found in build context
```
**Fix:** Check path is relative to build context

**Too many symlinks:**
```
too many levels of symbolic links
```

### Layer Cache Issues

**Corrupted layer:**
```
failed to export image: failed to create image: failed to get layer
```
**Fix:** Clear build cache: `docker buildx prune`

## Feature-Specific Errors

### Version Not Found

```
Failed to resolve feature version: 1.2.3
```
**Fix:** Check available versions on containers.dev

### Circular Dependencies

```
Circular dependency detected in feature installation
```
**Fix:** Review dependsOn and installsAfter in features

### Option Validation

```
Invalid option value for feature: expected boolean, got string
```
**Fix:** Check feature schema for option types

## Compose Errors

### Volume Mount Issues

```
Bind mount source path does not exist
```
**Fix:** Ensure host path exists before starting

### Network Conflicts

```
Network name already in use
```
**Fix:** Run `docker network prune` or use unique network names

### Service Dependencies

```
Service 'db' failed to start
```
**Fix:** Check service logs: `docker-compose logs db`

## Runtime Errors

### VS Code Server Failures

```
VS Code Server failed to start
```
**Diagnosis:**
- Check server logs in container
- Verify remoteUser has shell access
- Check for port conflicts

### Extension Installation Failures

```
Failed to install extension: ms-python.python
```
**Fix:** Install manually or check marketplace availability

### Git Credential Issues

```
Permission denied (publickey)
```
**Fix:** Forward SSH agent or use HTTPS with credential helper

## Platform-Specific Issues

### macOS File Watching

```
ENOSPC: System limit for number of file watchers reached
```
**Fix:** Increase inotify watchers on host (not container)

### Windows Path Issues

```
invalid mount config for type "bind": invalid mount path
```
**Fix:** Use WSL2 paths or proper Windows path format

### SELinux (Linux)

```
Permission denied on bind mount
```
**Fix:** Add `:z` or `:Z` to mount flags for SELinux relabeling
