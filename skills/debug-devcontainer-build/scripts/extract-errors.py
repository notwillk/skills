#!/usr/bin/env python3
# /// script
# dependencies = []
# requires-python: ">=3.8"
# ///

"""
Extract error sections from devcontainer build logs.

Usage:
    python extract-errors.py /path/to/build.log
    cat build.log | python extract-errors.py
"""

import sys
import re
from pathlib import Path


def extract_errors(log_content: str) -> list:
    """Extract error sections from build log."""
    errors = []
    lines = log_content.split('\n')
    
    # Patterns to identify errors
    error_patterns = [
        r'error[:\s]',
        r'ERROR[:\s]',
        r'failed[:\s]',
        r'FAILED',
        r'exception',
        r'EXCEPTION',
        r'fatal',
        r'FATAL',
        r'cannot',
        r'Cannot',
        r'unable',
        r'Unable',
        r'permission denied',
        r'Permission denied',
        r'exit code [1-9]',
        r'no such file',
        r'not found',
        r'timeout',
        r'connection refused',
        r'unauthorized',
    ]
    
    # Keywords that indicate context
    context_keywords = [
        'FROM',
        'RUN',
        'COPY',
        'ADD',
        'installing feature',
        'postCreateCommand',
        'postStartCommand',
        '=> ERROR',
        'Step',
    ]
    
    for i, line in enumerate(lines):
        # Check if line matches error pattern
        for pattern in error_patterns:
            if re.search(pattern, line, re.IGNORECASE):
                # Get context (3 lines before, error line, 2 lines after)
                start = max(0, i - 3)
                end = min(len(lines), i + 3)
                context = '\n'.join(lines[start:end])
                
                errors.append({
                    'line_number': i + 1,
                    'error_text': line.strip(),
                    'context': context,
                    'pattern_matched': pattern
                })
                break
    
    return errors


def summarize_errors(errors: list) -> dict:
    """Create summary of errors found."""
    if not errors:
        return {
            'total_errors': 0,
            'summary': 'No clear errors found in log',
            'recommendation': 'Check for warnings or paste full log for analysis'
        }
    
    # Categorize errors
    categories = {
        'dockerfile_build': 0,
        'feature_install': 0,
        'lifecycle_script': 0,
        'permission': 0,
        'network': 0,
        'other': 0
    }
    
    for error in errors:
        text = error['error_text'].lower()
        if any(kw in text for kw in ['dockerfile', 'from', 'run', 'copy']):
            categories['dockerfile_build'] += 1
        elif any(kw in text for kw in ['feature', 'installing feature']):
            categories['feature_install'] += 1
        elif any(kw in text for kw in ['postcreate', 'poststart', 'lifecycle']):
            categories['lifecycle_script'] += 1
        elif any(kw in text for kw in ['permission', 'denied', 'eacces']):
            categories['permission'] += 1
        elif any(kw in text for kw in ['timeout', 'connection', 'network', 'unauthorized']):
            categories['network'] += 1
        else:
            categories['other'] += 1
    
    # Find primary category
    primary = max(categories, key=categories.get)
    
    return {
        'total_errors': len(errors),
        'categories': categories,
        'primary_category': primary,
        'unique_error_count': len(set(e['error_text'] for e in errors))
    }


def main():
    # Read from file or stdin
    if len(sys.argv) > 1:
        log_path = Path(sys.argv[1])
        if not log_path.exists():
            print(f"Error: File not found: {log_path}", file=sys.stderr)
            sys.exit(1)
        log_content = log_path.read_text()
    else:
        log_content = sys.stdin.read()
    
    if not log_content.strip():
        print("Error: No log content provided", file=sys.stderr)
        sys.exit(1)
    
    # Extract errors
    errors = extract_errors(log_content)
    summary = summarize_errors(errors)
    
    # Output results
    import json
    result = {
        'summary': summary,
        'errors': errors[:10]  # Limit to first 10 errors
    }
    
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
