# Known Systems Reference

## Auto-Detected Dependencies

The skill analyzes `install.sh` for common patterns and suggests dependencies automatically.

## Language Runtimes

### Node.js / npm

**Pattern detected:**
- `npm install` or `npm i`
- `npx` usage
- `package.json` manipulation

**Suggested dependency:**
```json
{
  "installsAfter": [
    "ghcr.io/devcontainers/features/node"
  ]
}
```

**Action:** Ask user - "Add node feature as dependency?"

### Python / pip

**Pattern detected:**
- `pip install`
- `pip3 install`
- `python setup.py`

**Suggested dependency:**
```json
{
  "installsAfter": [
    "ghcr.io/devcontainers/features/python"
  ]
}
```

**Action:** Ask user - "Add python feature as dependency?"

### Rust / Cargo

**Pattern detected:**
- `cargo install`
- `cargo build`
- `rustc` usage

**Suggested dependency:**
```json
{
  "installsAfter": [
    "ghcr.io/devcontainers/features/rustup"
  ]
}
```

**Action:** Ask user - "Add rustup feature as dependency?"

### Go

**Pattern detected:**
- `go install`
- `go get`
- `go build`

**Suggested dependency:**
```json
{
  "installsAfter": [
    "ghcr.io/devcontainers/features/go"
  ]
}
```

**Action:** Ask user - "Add go feature as dependency?"

### Ruby / Gem

**Pattern detected:**
- `gem install`
- `bundle install`

**Suggested dependency:**
```json
{
  "installsAfter": [
    "ghcr.io/devcontainers/features/ruby"
  ]
}
```

## Package Managers

### apt (Debian/Ubuntu)

**Pattern:** `apt-get install`

**Action:** No dependency needed - system package manager available in base images

### yum/dnf (Fedora/RHEL)

**Pattern:** `yum install`, `dnf install`

**Action:** No dependency needed - system package manager

### apk (Alpine)

**Pattern:** `apk add`

**Action:** No dependency needed - system package manager

## Exotic Patterns (Prompt User)

When encountering these patterns, ask the user for guidance:

### Custom curl/wget scripts

```bash
curl -fsSL https://example.com/install.sh | bash
wget -qO- https://example.com/install | sh
```

**Prompt:** "This downloads and executes a remote script. Options:
1. Refactor to use direct binary download (recommended)
2. Keep as-is (may have security implications)
3. Document the dependency on external tool"

### Language-specific global installs

```bash
npm install -g some-package
pip install some-tool
```

**Prompt:** "Detected global package install via npm/pip. Options:
1. Add node/python feature as dependency
2. Create separate feature for this package
3. Keep as-is (feature will only work with node/python present)"

### Complex build systems

```bash
make && make install
meson setup build
./configure --prefix=/usr/local
```

**Prompt:** "Build system detected. Verify all build dependencies are available in base image or add as feature dependencies."

### Docker-in-Docker patterns

```bash
docker run ...
docker build ...
```

**Prompt:** "Docker commands detected. Consider adding docker-in-docker feature as dependency."

## Common Feature IDs

Official devcontainer features:

| Feature | ID |
|---------|-----|
| Node.js | `ghcr.io/devcontainers/features/node` |
| Python | `ghcr.io/devcontainers/features/python` |
| Go | `ghcr.io/devcontainers/features/go` |
| Rust | `ghcr.io/devcontainers/features/rust` |
| Ruby | `ghcr.io/devcontainers/features/ruby` |
| Java | `ghcr.io/devcontainers/features/java` |
| Docker-in-Docker | `ghcr.io/devcontainers/features/docker-in-docker` |
| Docker-outside | `ghcr.io/devcontainers/features/docker-outside-of-docker` |
| Git | `ghcr.io/devcontainers/features/git` |
| GitHub CLI | `ghcr.io/devcontainers/features/github-cli` |
| AWS CLI | `ghcr.io/devcontainers/features/aws-cli` |
| Azure CLI | `ghcr.io/devcontainers/features/azure-cli` |
| Terraform | `ghcr.io/devcontainers/features/terraform` |
| kubectl | `ghcr.io/devcontainers/features/kubectl-helm-minikube` |

## Dependency Decision Tree

```
install.sh contains:
├── npm / node → Suggest node feature
├── pip / python → Suggest python feature
├── cargo / rustc → Suggest rustup feature
├── go → Suggest go feature
├── gem / ruby → Suggest ruby feature
├── apt-get / yum / apk → No dependency (system)
├── curl custom script → Ask user
├── wget install.sh | bash → Ask user
└── Other → No suggestion
```
