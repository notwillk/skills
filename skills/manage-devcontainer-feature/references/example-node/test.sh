#!/bin/bash
set -e

source dev-container-features-test-lib

check "node available" node --version
check "npm available" npm --version

if [ -n "${VERSION:-}" ] && [ "$VERSION" != "latest" ] && [ "$VERSION" != "lts" ]; then
  EXPECTED="${VERSION#v}"
  check "matches version" bash -lc "node --version | grep -F \"v${EXPECTED}\""
fi

reportResults
