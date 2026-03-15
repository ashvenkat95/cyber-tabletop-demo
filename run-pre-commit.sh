#!/bin/sh
# Pre-commit checks: ESLint, Semgrep
# (GitLeaks skipped - requires Docker locally)

set -e
echo "=== Pre-commit Security Checks ==="

# 1. ESLint
echo ""
echo "[1/2] ESLint..."
cd backend && npx eslint . && cd ..
echo "  ESLint passed ✓"

# 2. Semgrep (skip if not installed - requires pip or Docker on Windows)
echo ""
echo "[2/2] Semgrep..."
if command -v semgrep >/dev/null 2>&1; then
  semgrep --config=p/security-audit .
  echo "  Semgrep passed ✓"
else
  echo "  Semgrep skipped (not installed - will run in GitHub Actions)"
fi

echo ""
echo "=== Pre-commit checks passed ==="
