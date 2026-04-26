#!/bin/bash
# Simple Smoke Test Template
# Use for: Basic verification that tool installed correctly

set -e

# Source the devcontainer test library
source dev-container-features-test-lib

# ============================================================================
# BASIC AVAILABILITY TEST
# ============================================================================
# Check that the main binary is available and executable
check "{{FEATURE_ID}} available" {{BINARY_NAME}} --version

# ============================================================================
# VERSION CHECK (Optional)
# ============================================================================
# If a specific version was requested, verify it matches
if [ -n "${VERSION:-}" ] && [ "$VERSION" != "latest" ]; then
  EXPECTED_VERSION="${VERSION#v}"  # Strip leading v if present
  check "matches requested version" bash -lc "{{BINARY_NAME}} --version | grep -F \"${EXPECTED_VERSION}\""
fi

# ============================================================================
# ADDITIONAL TESTS (Optional)
# ============================================================================
# Add specific tests based on the tool:

# Example: Check that a config file was created
# check "config file exists" test -f /etc/{{FEATURE_ID}}/config

# Example: Check that a service can start
# check "service can start" bash -lc "{{BINARY_NAME}} --help | grep -q 'start'"

# Example: Check permissions
# check "binary is executable" test -x "$(which {{BINARY_NAME}})"

# ============================================================================
# REPORT RESULTS
# ============================================================================
reportResults
