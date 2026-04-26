#!/bin/bash
set -e

source dev-container-features-test-lib

check "python available" python --version
check "pip available" pip --version

if [ -n "${VERSION:-}" ] && [ "$VERSION" != "latest" ]; then
  EXPECTED="${VERSION#python}"
  check "matches version" bash -lc "python --version 2>&1 | grep -F \"${EXPECTED}\""
fi

reportResults
