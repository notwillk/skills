#!/usr/bin/env bash
# Python Feature Installation
# Pattern: Package manager (deadsnakes PPA) with fallback to source

set -euo pipefail

VERSION="${VERSION:-latest}"

# Install dependencies
apt-get update -y
apt-get install -y ca-certificates curl software-properties-common
rm -rf /var/lib/apt/lists/*

# Resolve version
if [ "$VERSION" = "latest" ]; then
  VERSION="3.12"
fi
VERSION="${VERSION#python}"  # Strip 'python' prefix if provided

# Try deadsnakes PPA first
if grep -q "Ubuntu" /etc/os-release 2>/dev/null; then
  echo "Adding deadsnakes PPA..."
  add-apt-repository -y ppa:deadsnakes/ppa || true
  apt-get update -y
  
  PYTHON_PKG="python${VERSION}"
  apt-get install -y "${PYTHON_PKG}" "${PYTHON_PKG}-venv" "${PYTHON_PKG}-pip" || {
    echo "Failed to install from PPA, falling back to build from source..."
    apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
      libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils \
      tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    
    # Build from source
    TMP_DIR="$(mktemp -d)"
    cd "$TMP_DIR"
    curl -fsSL "https://www.python.org/ftp/python/${VERSION}.0/Python-${VERSION}.0.tar.xz" | tar -xJf -
    cd "Python-${VERSION}.0"
    ./configure --prefix="/opt/python${VERSION}"
    make -j"$(nproc)"
    make install
    
    ln -sf "/opt/python${VERSION}/bin/python${VERSION%.*}" /usr/local/bin/python
    ln -sf "/opt/python${VERSION}/bin/pip${VERSION%.*}" /usr/local/bin/pip
    
    cd /
    rm -rf "$TMP_DIR"
  }
  
  # Create symlinks if not already present
  ln -sf "/usr/bin/${PYTHON_PKG}" /usr/local/bin/python 2>/dev/null || true
  ln -sf "/usr/bin/${PYTHON_PKG}-config" /usr/local/bin/python-config 2>/dev/null || true
else
  echo "Non-Ubuntu system, installing python3 from system repos..."
  apt-get install -y python3 python3-pip python3-venv
fi

rm -rf /var/lib/apt/lists/*

# Verify
python --version
pip --version
