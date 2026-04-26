#!/usr/bin/env bash
# Multi-Step Installation Template
# Use for: Compiling from source, complex multi-stage setups
# Examples: Custom tools requiring build dependencies, modified binaries

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================
TOOL_NAME="{{TOOL_NAME}}"
VERSION="${VERSION:-latest}"
INSTALL_DIR="${INSTALL_DIR:-/usr/local}"

# Build directory
BUILD_DIR="/tmp/build-${TOOL_NAME}"

# ============================================================================
# DEPENDENCIES
# ============================================================================
echo "Installing build dependencies..."
apt-get update -y

# Essential build tools
apt-get install -y \
  build-essential \
  ca-certificates \
  curl \
  git \
  pkg-config \
  cmake \
  autoconf \
  automake \
  libtool

# Tool-specific dependencies (adjust as needed)
# apt-get install -y libssl-dev libcurl4-openssl-dev

rm -rf /var/lib/apt/lists/*

# ============================================================================
# SOURCE ACQUISITION
# ============================================================================
echo "Acquiring source code..."

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Clone or download source
# Option 1: Clone from git
# git clone --depth 1 --branch "v${VERSION}" "https://github.com/{{OWNER}}/{{REPO}}.git" .

# Option 2: Download source tarball
# curl -fsSL "https://github.com/{{OWNER}}/{{REPO}}/archive/refs/tags/v${VERSION}.tar.gz" | tar -xz --strip-components=1

# Option 3: Download and extract specific source
# curl -fsSL "{{SOURCE_URL}}/v${VERSION}.tar.gz" -o source.tar.gz
# tar -xzf source.tar.gz --strip-components=1

# ============================================================================
# BUILD PROCESS
# ============================================================================
echo "Building ${TOOL_NAME}..."

# Common build patterns - uncomment and adjust as needed:

# Pattern 1: Autotools (./configure && make)
# ./configure --prefix="$INSTALL_DIR"
# make -j"$(nproc)"
# make install

# Pattern 2: CMake
# cmake -B build -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"
# cmake --build build --parallel "$(nproc)"
# cmake --install build

# Pattern 3: Make only
# make -j"$(nproc)" PREFIX="$INSTALL_DIR"
# make install PREFIX="$INSTALL_DIR"

# Pattern 4: Language-specific (Rust, Go)
# cargo build --release
# cp target/release/{{BINARY}} "$INSTALL_DIR/bin/"

# go build -o "$INSTALL_DIR/bin/{{BINARY}}"

# Pattern 5: Custom build script
# ./build.sh --prefix="$INSTALL_DIR"

echo "Build complete!"

# ============================================================================
# POST-INSTALL CONFIGURATION
# ============================================================================
# Add to PATH if needed
# echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> /etc/profile.d/${TOOL_NAME}.sh

# Set up environment variables
# echo "export ${TOOL_NAME_UPPER}_HOME=\"$INSTALL_DIR\"" >> /etc/profile.d/${TOOL_NAME}.sh

# Create symlinks if binary name differs
# ln -sf "$INSTALL_DIR/bin/actual-binary-name" "$INSTALL_DIR/bin/alias-name"

# Set up man pages
# if [ -d "$BUILD_DIR/man" ]; then
#   cp -r "$BUILD_DIR/man" "$INSTALL_DIR/share/"
# fi

# ============================================================================
# CLEANUP
# ============================================================================
echo "Cleaning up build artifacts..."
cd /
rm -rf "$BUILD_DIR"

# ============================================================================
# VERIFICATION
# ============================================================================
echo "Verifying installation..."
which "{{BINARY_NAME}}" || { echo "Binary not in PATH"; exit 1; }
"{{BINARY_NAME}}" --version

echo "${TOOL_NAME} installed successfully!"
