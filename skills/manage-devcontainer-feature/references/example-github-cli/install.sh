#!/usr/bin/env bash
# GitHub CLI Feature Installation
# Pattern: Binary download from GitHub releases

set -euo pipefail

VERSION="${VERSION:-latest}"

# Install dependencies
apt-get update -y
apt-get install -y ca-certificates curl
rm -rf /var/lib/apt/lists/*

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) GH_ARCH="amd64" ;;
  aarch64|arm64) GH_ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

# Resolve version
if [ "$VERSION" = "latest" ]; then
  release_json="$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest)"
  VERSION="$(printf '%s' "$release_json" | sed -n 's/^ *"tag_name": *"v\?\([^"]*\)".*/\1/p' | head -n1)"
else
  VERSION="${VERSION#v}"
fi

# Download URL
DOWNLOAD_URL="https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_${GH_ARCH}.tar.gz"

# Download and extract
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading GitHub CLI v${VERSION} for ${GH_ARCH}..."
curl -fsSL "$DOWNLOAD_URL" | tar -xz -C "$TMP_DIR" --strip-components=1

# Install
mkdir -p /usr/local/bin
mv "$TMP_DIR/bin/gh" /usr/local/bin/
cp -r "$TMP_DIR/share" /usr/local/ || true

# Verify
git --version
