#!/usr/bin/env bash
# Remove the user-level fable-consult install (mirror of install.sh).
set -euo pipefail

CLAUDE="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

rm -rf "$CLAUDE/skills/fable"
for a in explorer oracle verifier coder engineer test-writer reviewer; do
  rm -f "$CLAUDE/agents/$a.md"
done

echo "Removed fable-consult from $CLAUDE"
echo "Note: explorer.md / verifier.md are generic worker names — if you"
echo "installed other tools that shipped their own, re-add those as needed."
