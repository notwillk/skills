#!/usr/bin/env bash
# Node.js Feature Installation
# Pattern: Binary download from nodejs.org

set -euo pipefail

VERSION="${VERSION:-latest}"

# Install dependencies
apt-get update -y
apt-get install -y ca-certificates curl xz-utils
rm -rf /var/lib/apt/lists/*

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) NODE_ARCH="x64" ;;
  aarch64|arm64) NODE_ARCH="arm64" ;;
  armv7l) NODE_ARCH="armv7l" ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

# Resolve version
if [ "$VERSION" = "latest" ] || [ "$VERSION" = "current" ]; then
  # Get latest from Node.js index
  VERSION="$(curl -fsSL https://nodejs.org/dist/index.tab | awk 'NR==2{v=$1;sub(/^v/, "", v); print v}')"
else
  VERSION="${VERSION#v}"
fi

# Download URL
TARBALL="node-v${VERSION}-linux-${NODE_ARCH}.tar.xz"
URL="https://nodejs.org/dist/v${VERSION}/${TARBALL}"

# Download and extract
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading Node.js v${VERSION} for ${NODE_ARCH}..."
curl -fsSL "$URL" | tar -xJf - -C "$TMP_DIR" --strip-components=1

# Install
INSTALL_DIR="/usr/local/node-v${VERSION}"
mkdir -p "$INSTALL_DIR"
cp -r "$TMP_DIR"/* "$INSTALL_DIR/"

# Create symlinks
ln -sf "$INSTALL_DIR/bin/node" /usr/local/bin/node
ln -sf "$INSTALL_DIR/bin/npm" /usr/local/bin/npm
ln -sf "$INSTALL_DIR/bin/npx" /usr/local/bin/npx

# Verify
node -v
npm -v
