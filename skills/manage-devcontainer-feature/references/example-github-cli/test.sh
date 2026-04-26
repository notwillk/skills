#!/bin/bash
set -e

source dev-container-features-test-lib

check "gh available" gh --version

if [ -n "${VERSION:-}" ] && [ "$VERSION" != "latest" ]; then
  EXPECTED="${VERSION#v}"
  check "matches version" bash -lc "gh --version | grep -F \"${EXPECTED}\""
fi

reportResults
