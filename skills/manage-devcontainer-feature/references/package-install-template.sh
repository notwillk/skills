#!/usr/bin/env bash
# Package Manager Installation Template
# Use for: Installing via system package managers or language-specific tools
# Examples: apt packages, npm global installs, pip packages, cargo crates

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================
TOOL_NAME="{{TOOL_NAME}}"
PACKAGE_NAME="{{PACKAGE_NAME}}"  # May differ from tool name
VERSION="${VERSION:-latest}"

# Package manager type: apt, npm, pip, cargo, gem, etc
PACKAGE_MANAGER="{{PACKAGE_MANAGER}}"

# ============================================================================
# PACKAGE MANAGER SETUP
# ============================================================================
case "$PACKAGE_MANAGER" in
  apt)
    # System package manager (Debian/Ubuntu)
    apt-get update -y
    
    if [ "$VERSION" = "latest" ]; then
      apt-get install -y "$PACKAGE_NAME"
    else
      # Try to install specific version
      apt-get install -y "${PACKAGE_NAME}=${VERSION}"
    fi
    
    rm -rf /var/lib/apt/lists/*
    ;;
    
  npm)
    # Node.js packages
    # Assumes node/npm are available (should have node feature as dependency)
    
    if [ "$VERSION" = "latest" ]; then
      npm install -g "$PACKAGE_NAME"
    else
      npm install -g "${PACKAGE_NAME}@${VERSION}"
    fi
    ;;
    
  pip)
    # Python packages
    # Assumes python/pip are available
    
    if [ "$VERSION" = "latest" ]; then
      pip install "$PACKAGE_NAME"
    else
      pip install "${PACKAGE_NAME}==${VERSION}"
    fi
    ;;
    
  pipx)
    # Python applications (isolated)
    # Assumes pipx is available
    
    if [ "$VERSION" = "latest" ]; then
      pipx install "$PACKAGE_NAME"
    else
      pipx install "${PACKAGE_NAME}==${VERSION}"
    fi
    ;;
    
  cargo)
    # Rust crates
    # Assumes cargo is available (should have rustup feature as dependency)
    
    if [ "$VERSION" = "latest" ]; then
      cargo install "$PACKAGE_NAME"
    else
      cargo install --version "$VERSION" "$PACKAGE_NAME"
    fi
    
    # Ensure cargo bin is in PATH
    if [ -d "$HOME/.cargo/bin" ]; then
      ln -sf "$HOME/.cargo/bin/{{BINARY_NAME}}" /usr/local/bin/{{BINARY_NAME}} 2>/dev/null || true
    fi
    ;;
    
  gem)
    # Ruby gems
    # Assumes ruby/gem are available
    
    if [ "$VERSION" = "latest" ]; then
      gem install "$PACKAGE_NAME"
    else
      gem install "$PACKAGE_NAME" -v "$VERSION"
    fi
    ;;
    
  go)
    # Go modules (install command)
    # Assumes go is available
    
    if [ "$VERSION" = "latest" ]; then
      go install "github.com/{{OWNER}}/{{REPO}}@latest"
    else
      go install "github.com/{{OWNER}}/{{REPO}}@v${VERSION}"
    fi
    
    # Ensure go bin is in PATH
    if [ -d "$HOME/go/bin" ]; then
      ln -sf "$HOME/go/bin/{{BINARY_NAME}}" /usr/local/bin/{{BINARY_NAME}} 2>/dev/null || true
    fi
    ;;
    
  *)
    echo "Unsupported package manager: $PACKAGE_MANAGER" >&2
    exit 1
    ;;
esac

# ============================================================================
# VERIFICATION
# ============================================================================
echo "Verifying installation..."
which "{{BINARY_NAME}}" || { echo "Binary not in PATH"; exit 1; }

# Version check (may need adjustment based on tool's --version output)
"{{BINARY_NAME}}" --version || "{{BINARY_NAME}}" -v || echo "Version check skipped"

echo "${TOOL_NAME} installed successfully via ${PACKAGE_MANAGER}!"
