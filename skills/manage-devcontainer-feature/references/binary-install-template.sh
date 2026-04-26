#!/usr/bin/env bash
# Binary Download Template
# Use for: CLI tools, standalone applications with GitHub releases or direct URLs
# Examples: GitHub CLI, 1Password CLI, jq, yq

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================
# Tool name (used for logging)
TOOL_NAME="{{TOOL_NAME}}"

# Version option (passed via devcontainer-feature.json options)
VERSION="${VERSION:-latest}"

# GitHub repository for releases (format: owner/repo)
GITHUB_REPO="{{GITHUB_REPO}}"

# Binary name in releases (may differ from tool name)
BINARY_NAME="{{BINARY_NAME}}"

# Installation target directory
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

# ============================================================================
# ARCHITECTURE DETECTION
# ============================================================================
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) TARGET_ARCH="x86_64" ;;           # Adjust per tool: amd64, x64
  aarch64|arm64) TARGET_ARCH="arm64" ;;     # Adjust per tool: aarch64
  armv7l|armv6l) TARGET_ARCH="armv7" ;;      # Rare - most tools don't support
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

# ============================================================================
# DEPENDENCIES
# ============================================================================
# Install required tools for download and extraction
apt-get update -y
apt-get install -y ca-certificates curl tar unzip
rm -rf /var/lib/apt/lists/*

# ============================================================================
# VERSION RESOLUTION
# ============================================================================
if [ "$VERSION" = "latest" ] || [ "$VERSION" = "current" ]; then
  # Fetch latest version from GitHub API
  RELEASE_API="https://api.github.com/repos/$GITHUB_REPO/releases/latest"
  release_json="$(curl -fsSL "$RELEASE_API")"
  
  # Extract version from tag_name
  VERSION="$(printf '%s' "$release_json" | sed -n 's/^ *"tag_name": *"v\?\([^"]*\)".*/\1/p' | head -n1)"
else
  # Strip leading 'v' if provided
  VERSION="${VERSION#v}"
fi

# ============================================================================
# DOWNLOAD URL CONSTRUCTION
# ============================================================================
# Common patterns - adjust based on actual release structure:
# Pattern 1: Direct binary in tarball
# ASSET_NAME="${BINARY_NAME}-v${VERSION}-linux-${TARGET_ARCH}.tar.gz"
# Pattern 2: Binary in zip
# ASSET_NAME="${BINARY_NAME}_${VERSION}_linux_${TARGET_ARCH}.zip"
# Pattern 3: Single binary (no archive)
# ASSET_NAME="${BINARY_NAME}-linux-${TARGET_ARCH}"

ASSET_NAME="{{ASSET_NAME_TEMPLATE}}"

# Construct download URL
# Common patterns:
# Pattern 1: GitHub releases
DOWNLOAD_URL="https://github.com/$GITHUB_REPO/releases/download/v${VERSION}/${ASSET_NAME}"
# Pattern 2: Custom CDN
# DOWNLOAD_URL="https://example.com/download/${VERSION}/${ASSET_NAME}"

# ============================================================================
# DOWNLOAD AND INSTALL
# ============================================================================
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading ${TOOL_NAME} v${VERSION} for ${TARGET_ARCH}..."
curl -fsSL "$DOWNLOAD_URL" -o "$TMP_DIR/download"

# Extract based on file type
case "$ASSET_NAME" in
  *.tar.gz|*.tgz)
    tar -xzf "$TMP_DIR/download" -C "$TMP_DIR"
    ;;
  *.tar.xz)
    tar -xJf "$TMP_DIR/download" -C "$TMP_DIR"
    ;;
  *.zip)
    unzip -q "$TMP_DIR/download" -d "$TMP_DIR"
    ;;
  *)
    # Single binary, no extraction needed
    mv "$TMP_DIR/download" "$TMP_DIR/$BINARY_NAME"
    ;;
esac

# Find binary in extraction directory (handles various structures)
BINARY_PATH="$(find "$TMP_DIR" -type f -name "$BINARY_NAME" | head -n1)"

if [ -z "$BINARY_PATH" ]; then
  echo "Error: Could not find $BINARY_NAME in downloaded archive" >&2
  ls -la "$TMP_DIR"
  exit 1
fi

# Install to target directory
mkdir -p "$INSTALL_DIR"
cp "$BINARY_PATH" "$INSTALL_DIR/$BINARY_NAME"
chmod +x "$INSTALL_DIR/$BINARY_NAME"

# ============================================================================
# VERIFICATION
# ============================================================================
echo "Verifying installation..."
"$INSTALL_DIR/$BINARY_NAME" --version

echo "${TOOL_NAME} v${VERSION} installed successfully!"
