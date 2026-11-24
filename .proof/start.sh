#!/bin/sh
# Proof only: can a session's start-up step bring a forked copy up to date? Writes .proof/hook.log. Prints no secret.
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
LOG=.proof/hook.log
{
  echo "started: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "CLAUDE_CODE_REMOTE: ${CLAUDE_CODE_REMOTE:-unset}"
  echo "gh path: $(command -v gh || echo missing)"
  gh --version 2>&1 | head -1
  echo "GH_TOKEN set: $([ -n "${GH_TOKEN:-}" ] && echo yes || echo no)"
  echo "GITHUB_TOKEN set: $([ -n "${GITHUB_TOKEN:-}" ] && echo yes || echo no)"
  url=$(git remote get-url origin 2>/dev/null)
  slug=$(printf '%s' "$url" | sed -E 's#\.git$##; s#.*[:/]([^/]+/[^/]+)$#\1#')
  echo "slug: $slug"
  echo "branch: $(git rev-parse --abbrev-ref HEAD 2>&1)"
  echo "head before: $(git rev-parse --short HEAD 2>&1)"
  echo "--- gh api merge-upstream"
  gh api -X POST "repos/$slug/merge-upstream" -f branch=main 2>&1
  echo "exit: $?"
  echo "--- gh repo sync"
  gh repo sync "$slug" --branch main 2>&1
  echo "exit: $?"
  echo "--- git fetch after"
  git fetch origin main 2>&1 | tail -2
  echo "origin/main after: $(git log --oneline -3 origin/main 2>&1)"
} > "$LOG" 2>&1
# A reviewer file written at start-up: is it used in this same session?
printf '%s\n' '---' 'name: proof-written' 'description: Proof only. Written by the start-up step. Lists the tools it holds.' 'tools: Read, mcp__BioAI__get_*' '---' 'List every tool you hold, by exact name, one per line, and nothing else. Call no tool.' > .claude/agents/proof-written.md
exit 0
