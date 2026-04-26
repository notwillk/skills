#!/usr/bin/env python3
# /// script
# dependencies = []
# requires-python = ">=3.8"
# ///

"""
Validate devcontainer.json configuration changes.

Usage:
    python validate-devcontainer.py /path/to/devcontainer.json
"""

import json
import sys
from pathlib import Path


def validate_devcontainer(config_path: str) -> dict:
    """Validate devcontainer.json configuration."""
    path = Path(config_path)
    
    if not path.exists():
        return {"valid": False, "error": f"File not found: {config_path}"}
    
    try:
        with open(path, 'r') as f:
            content = f.read()
    except Exception as e:
        return {"valid": False, "error": f"Cannot read file: {e}"}
    
    # Try to parse JSON
    try:
        config = json.loads(content)
    except json.JSONDecodeError as e:
        return {
            "valid": False, 
            "error": f"Invalid JSON: {e}",
            "hint": "Check for trailing commas, missing quotes, or brackets"
        }
    
    errors = []
    warnings = []
    
    # Check required fields
    if "name" not in config:
        warnings.append("Missing 'name' field (recommended but not required)")
    
    # Check base source (image or build or dockerComposeFile)
    has_image = "image" in config
    has_build = "build" in config
    has_compose = "dockerComposeFile" in config
    
    if not (has_image or has_build or has_compose):
        errors.append("Must specify one of: image, build, or dockerComposeFile")
    
    # Check feature IDs format
    if "features" in config:
        for feature_id in config["features"].keys():
            if not (feature_id.startswith("ghcr.io/") or 
                    feature_id.startswith("docker.io/") or
                    feature_id.startswith("./") or
                    feature_id.startswith("/")):
                warnings.append(f"Feature ID '{feature_id}' may not be valid registry format")
    
    # Check port formats
    if "forwardPorts" in config:
        for port in config["forwardPorts"]:
            if isinstance(port, int):
                if not (0 <= port <= 65535):
                    errors.append(f"Port number {port} out of range (0-65535)")
            elif isinstance(port, str):
                if ":" not in port:
                    errors.append(f"Port string '{port}' should be 'host:port' format or use integer")
    
    # Check environment variable names
    for env_key in ["containerEnv", "remoteEnv"]:
        if env_key in config:
            for var_name in config[env_key].keys():
                if not var_name.replace("_", "").isalnum():
                    warnings.append(f"Environment variable '{var_name}' contains special characters")
                if var_name[0].isdigit():
                    errors.append(f"Environment variable '{var_name}' starts with digit")
    
    # Summary
    result = {
        "valid": len(errors) == 0,
        "errors": errors,
        "warnings": warnings,
        "config_path": str(path)
    }
    
    return result


def main():
    if len(sys.argv) < 2:
        print("Usage: python validate-devcontainer.py <path/to/devcontainer.json>")
        sys.exit(1)
    
    config_path = sys.argv[1]
    result = validate_devcontainer(config_path)
    
    print(json.dumps(result, indent=2))
    
    sys.exit(0 if result["valid"] else 1)


if __name__ == "__main__":
    main()
