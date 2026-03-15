# DevSecOps Flow Overview

This document explains what happens at each stage of the development and merge process.

---

## What is the "Workflow"?

The **workflow** is the GitHub Actions pipeline defined in:

```
.github/workflows/security-pipeline.yml
```

It runs automatically on GitHub when you push or open a Pull Request. It executes these security tools: ESLint, Snyk, SonarCloud, Semgrep, and GitLeaks.

---

## 1. When You `git commit` (Local)

**Command:** `git add .` → `git commit -m "message"`

**What happens:**
1. Git triggers the pre-commit hook (Husky).
2. Husky runs `run-pre-commit.sh`, which executes:
   - **ESLint** – lints your JavaScript in `backend/`
   - **Semgrep** – skipped locally on Windows (only runs in CI)
3. If either check fails → the commit is **blocked** and you see errors.
4. If both pass → the commit completes and is saved to your local branch.

**Where:** Your machine (Git Bash)  
**Output:** Pre-commit messages appear in your terminal.

---

## 2. When You `git push` (Local → GitHub)

**Command:** `git push origin changes`

**What happens:**
1. Git uploads your local commits on `changes` to GitHub.
2. GitHub stores them and updates the `changes` branch.
3. If configured to run on push for that branch, the **workflow** starts (see `.github/workflows/security-pipeline.yml`).

**Note:** Your current workflow runs on `push` to `main` and on `pull_request`. A push to `changes` may not trigger it until you open a PR.

**Where:** Between your machine and GitHub  
**Output:** Push status in your terminal; workflow runs on GitHub (if triggered).

---

## 3. When You Create a Pull Request (GitHub)

**Action:** Click "Compare & pull request" on GitHub (from `changes` into `main`)

**What happens:**
1. GitHub creates the PR comparing `changes` to `main`.
2. The **workflow** runs automatically on the PR:
   - **ESLint** – linting
   - **Snyk** – dependency vulnerabilities
   - **SonarCloud** – code quality + security analysis
   - **Semgrep** – SAST (pattern-based security)
   - **GitLeaks** – secret detection (via Docker)
3. Results appear on the PR:
   - ✓ Green if all pass
   - ✗ Red if any fail (click "Details" to see logs)

**Where:** GitHub  
**Output:** Check results on the PR page (below the description).

---

## 4. When You Merge the PR (GitHub)

**Action:** Click "Merge pull request" on GitHub

**What happens:**
1. GitHub merges the commits from `changes` into `main`.
2. `main` now includes your changes.
3. If the workflow is configured for push to `main`, it runs again.
4. You can delete the `changes` branch (optional).

**Where:** GitHub  
**Output:** Merged PR; `main` is updated.

---

## Summary Table

| Stage | Where | What runs |
|-------|-------|-----------|
| **Commit** | Your machine | Pre-commit: ESLint (Semgrep skipped on Windows) |
| **Push** | Local → GitHub | Sends commits; workflow may run if configured |
| **PR created** | GitHub | Workflow: ESLint, Snyk, SonarCloud, Semgrep, GitLeaks |
| **Merge** | GitHub | Merges code into `main`; workflow may run on `main` |

---

## Visual Flow

```
Local:
  Edit code → git add → git commit  [Pre-commit: ESLint]
       ↓
  git push origin changes  [Commits sent to GitHub]
       ↓
GitHub:
  Create PR (changes → main)  [Workflow: ESLint, Snyk, SonarCloud, Semgrep, GitLeaks]
       ↓
  All checks pass? → Merge  [Code merged into main]
```

---

## Workflow File Reference

| File | Purpose |
|------|---------|
| `.github/workflows/security-pipeline.yml` | GitHub Actions workflow – runs all security scans |
