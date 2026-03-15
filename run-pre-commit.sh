#!/bin/sh
# Pre-commit checks: ESLint, Semgrep
# (GitLeaks skipped - requires Docker locally)

set -e
# Redirect stdout to stderr so output shows when Git runs the hook (Windows)
exec 1>&2

echo "=== Pre-commit Security Checks ==="

# 1. ESLint
echo "" >&2
echo "[1/2] ESLint..." >&2
cd backend && npm run lint && cd ..
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
