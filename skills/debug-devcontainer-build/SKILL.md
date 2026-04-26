---
name: debug-devcontainer-build
description: >
  Diagnose devcontainer build failures and startup issues by analyzing error logs and 
  identifying root causes. Use when container builds fail, feature installations error, 
  startup crashes occur, or when the user pastes build logs showing errors. Also 
  applies for "permission denied" issues, network timeouts, "failed to create" errors, 
  or any devcontainer troubleshooting scenario — even if described as "my container won't 
  start", "build is failing", or "feature won't install" without explicit log mentions.
license: MIT
compatibility: Requires build error logs or symptom description
metadata:
  author: agentskills
  version: "1.0.0"
  category: devcontainer-troubleshooting
---

# Debug Devcontainer Build

Analyze build logs and diagnose devcontainer failures. This skill helps identify common issues and provides remediation steps.

## Quick Diagnosis (No Logs Required)

Before analyzing logs, check these common issues:

### Docker Daemon Not Running
**Symptoms:** 
- "Cannot connect to Docker daemon"
- "Docker is not running"

**Fix:**
```bash
# macOS/Windows
# Start Docker Desktop application

# Linux
sudo systemctl start docker
```

### Insufficient Disk Space
**Symptoms:**
- "no space left on device"
- Build fails during layer creation

**Fix:**
```bash
# Clean up Docker
docker system prune -a

# Check disk space
df -h
```

### Permission Issues
**Symptoms:**
- "permission denied" on bind mounts
- Files not accessible in container

**Check:**
- Verify `remoteUser` and `containerUser` settings
- Check `updateRemoteUserUID` is `true` (default)
- Review file ownership on host

### Network/Proxy Issues
**Symptoms:**
- "Failed to fetch" package manager errors
- Timeout downloading images

**Check:**
- Corporate proxy configuration
- DNS resolution in container
- VPN interference

## Log Analysis

### Log Parsing

Use the log extraction script to identify relevant error sections:

```bash
python scripts/extract-errors.py /path/to/build.log
```

Or paste relevant sections of the log and I'll analyze them.

### Common Error Patterns

#### 1. Dockerfile Build Failures

**Pattern:** `RUN apt-get install` fails
```
E: Unable to locate package xyz
```

**Diagnosis:**
- Package name incorrect
- Package repository not updated
- Base image doesn't use apt (e.g., Alpine uses apk)

**Fix:**
```dockerfile
# For Debian/Ubuntu
RUN apt-get update && apt-get install -y package-name

# For Alpine
RUN apk add --no-cache package-name
```

---

**Pattern:** Build stage not found
```
failed to solve with frontend dockerfile.v0: failed to build LLB
```

**Diagnosis:**
- Invalid base image name
- Private registry requires authentication
- Image not accessible

**Fix:**
- Verify image name and tag
- Check registry authentication
- Use public image for testing

---

#### 2. Feature Installation Failures

**Pattern:** Feature not found
```
Failed to download feature ghcr.io/...: 404
```

**Diagnosis:**
- Feature ID incorrect
- Feature doesn't exist in registry
- Version tag invalid

**Fix:**
- Verify feature ID from containers.dev
- Check for typos in feature name
- Try without version tag (uses latest)

---

**Pattern:** Feature install script fails
```
ERROR: Feature "xyz" failed to install
```

**Diagnosis:**
- Feature incompatible with base image
- Missing dependencies in base image
- Feature options invalid

**Fix:**
- Check feature documentation for base image requirements
- Verify option values are valid
- Try common-utils feature first for basic tools

---

#### 3. Lifecycle Script Failures

**Pattern:** postCreateCommand exits with error
```
Exit code 1 from postCreateCommand
```

**Diagnosis:**
- Command not found in container
- Command references wrong path
- Dependency not yet installed

**Fix:**
```json
"postCreateCommand": "bash -c 'npm install'"
```

Or use array syntax to avoid shell issues:
```json
"postCreateCommand": ["npm", "install"]
```

---

#### 4. Permission Issues

**Pattern:** Permission denied on bind mount
```
Error: EACCES: permission denied, open '/workspace/file'
```

**Diagnosis:**
- UID/GID mismatch between host and container
- Files created as wrong user
- Bind mount permissions

**Fix:**
Ensure `updateRemoteUserUID` is true:
```json
{
  "remoteUser": "vscode",
  "updateRemoteUserUID": true
}
```

Or set workspace mount with proper permissions:
```json
"workspaceMount": "source=${localWorkspaceFolder},target=/workspace,type=bind,consistency=cached",
"workspaceFolder": "/workspace"
```

---

#### 5. Network/Timeout Issues

**Pattern:** Package download timeouts
```
Connection timed out
Failed to connect to archive.ubuntu.com
```

**Diagnosis:**
- Corporate proxy blocking requests
- Slow network connection
- DNS resolution failure

**Fix:**
Configure proxy in devcontainer.json:
```json
"containerEnv": {
  "HTTP_PROXY": "http://proxy.company.com:8080",
  "HTTPS_PROXY": "http://proxy.company.com:8080"
}
```

Or in Dockerfile:
```dockerfile
ENV HTTP_PROXY=http://proxy.company.com:8080
RUN apt-get update
```

---

#### 6. Compose Service Issues

**Pattern:** Service not found
```
Service 'xyz' not found in docker-compose.yml
```

**Diagnosis:**
- Service name mismatch
- Wrong docker-compose file referenced
- Service not defined

**Fix:**
Verify service name matches:
```json
"dockerComposeFile": "docker-compose.yml",
"service": "app",
"runServices": ["app", "db"]
```

---

#### 7. Image Pull Failures

**Pattern:** Authentication required
```
unauthorized: authentication required
```

**Diagnosis:**
- Private registry needs login
- Image doesn't exist
- Registry access denied

**Fix:**
Login to registry:
```bash
docker login ghcr.io -u USERNAME
```

Or use public image for testing.

---

## Troubleshooting Workflow

### Step 1: Identify Error Location

Where in the build process did it fail?

- **Image pull** - Check image name, registry access
- **Dockerfile build** - Check Dockerfile syntax, base image
- **Feature install** - Check feature ID, compatibility
- **Container start** - Check lifecycle scripts, permissions
- **Post-attach** - Check VS Code server, extensions

### Step 2: Extract Relevant Log Section

Look for:
- Error messages with "ERROR", "FAIL", "failed"
- Exit codes (non-zero)
- Stack traces
- File paths mentioned in errors

### Step 3: Match to Known Pattern

Compare error to patterns above.

### Step 4: Apply Fix

Try the recommended fix.

### Step 5: Rebuild and Verify

```bash
devcontainer rebuild
```

Or in VS Code: "Dev Containers: Rebuild Container"

---

## Self-Improvement: Identifying Skill Gaps

**If you encounter a build error not covered by this skill:**

### Step 1: Document the Error

- What error message appeared?
- What was the context (build stage, feature install, etc.)?
- What base image was used?
- What fixed the issue?

### Step 2: Analyze the Gap

- Is this a new error pattern?
- Would a diagnosis checklist catch this earlier?
- What information would have helped identify this faster?

### Step 3: Suggest Skill Enhancement

**Suggest adding to this skill:**

```
New Error Pattern: [brief description]
Context: [when does it occur]
Diagnosis: [how to identify]
Remediation: [steps to fix]
Example Log Snippet: [anonymized example]
```

Share these observations to improve this skill over time.

---

## Common Diagnostic Commands

### Check Container Status
```bash
docker ps -a
docker logs <container-id>
```

### Inspect Image
```bash
docker images | grep <image-name>
docker inspect <image-name>
```

### Clean Build Cache
```bash
docker buildx prune
# Or full clean:
docker system prune -a
```

### Test Dockerfile Build
```bash
cd .devcontainer
docker build -t test-build .
```

### Check Feature Availability
```bash
devcontainer features info <feature-id>
```

---

## When to Seek Additional Help

If the error persists after trying fixes above:

1. **Check devcontainer spec issues:** https://github.com/devcontainers/spec/issues
2. **Review feature documentation:** containers.dev/features
3. **Check base image issues:** Docker Hub or registry page
4. **Test with minimal config:** Start fresh and add incrementally

---

## Resources

- `references/error-patterns.md` - Extended error pattern catalog
- `scripts/extract-errors.py` - Log extraction tool
- containers.dev - Official documentation
