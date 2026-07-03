#!/usr/bin/env bash
# Remove the user-level fable-consult install (mirror of install.sh).
# Only deletes the files install.sh creates; leaves everything else alone.
set -euo pipefail

CLAUDE="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

rm -rf "$CLAUDE/skills/fable"
for a in explore fable-planner verification; do
  rm -f "$CLAUDE/agents/$a.md"
done

echo "Removed /fable from $CLAUDE"
echo "Note: explore.md / verification.md are generic worker names — if you"
echo "installed other tools that shipped their own, re-add those as needed."
