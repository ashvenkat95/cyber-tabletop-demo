#!/bin/sh
# Pre-commit checks: ESLint, Semgrep
# (GitLeaks skipped - requires Docker locally)
# Output to stderr so it shows in Git Bash on Windows

set -e
echo "=== Pre-commit Security Checks ===" >&2

# 1. ESLint
echo "" >&2
echo "[1/2] ESLint..." >&2
cd backend && npx eslint . && cd ..
echo "  ESLint passed ✓" >&2

# 2. Semgrep (skip if not installed - requires pip or Docker on Windows)
echo "" >&2
echo "[2/2] Semgrep..." >&2
if command -v semgrep >/dev/null 2>&1; then
  semgrep --config=p/security-audit .
  echo "  Semgrep passed ✓" >&2
else
  echo "  Semgrep skipped (not installed - will run in GitHub Actions)" >&2
fi

echo "" >&2
echo "=== Pre-commit checks passed ===" >&2
