#!/usr/bin/env bash
# Install fable-consult as a USER-LEVEL skill so it invokes as bare `/fable`
# (not the namespaced `/fable-consult:fable` you'd get from `/plugin install`).
#
# It copies the skill and its three agents into your Claude config dir:
#   skills/fable/        -> $CLAUDE/skills/fable/
#   agents/{explore,fable-planner,verification}.md -> $CLAUDE/agents/
#
# User skills/agents are not namespaced, so the command is `/fable` and the
# agents resolve by bare name (which is what SKILL.md and fable-planner.md use).
#
# FABLE_EFFORT (low|medium|high|xhigh|max, default high) tunes Fable's reasoning
# depth: it is written into the installed fable-planner agent's `effort:` frontmatter.
# Re-run install.sh with a new value to change it.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
FABLE_EFFORT="${FABLE_EFFORT:-high}"

mkdir -p "$CLAUDE/skills" "$CLAUDE/agents"

rm -rf "$CLAUDE/skills/fable"
cp -a "$SRC/skills/fable" "$CLAUDE/skills/fable"

for a in explore fable-planner verification; do
  cp -a "$SRC/agents/$a.md" "$CLAUDE/agents/$a.md"
done

# Pin Fable's effort into the installed agent frontmatter (BSD + GNU sed compatible).
sed -i.bak -E "s|^effort:.*|effort: ${FABLE_EFFORT}|" "$CLAUDE/agents/fable-planner.md"
rm -f "$CLAUDE/agents/fable-planner.md.bak"

echo "Installed /fable into $CLAUDE"
echo "  skill : $CLAUDE/skills/fable/SKILL.md"
echo "  agents: explore.md, fable-planner.md (effort: ${FABLE_EFFORT}), verification.md"
echo
echo "Restart / reload your Claude Code session, then run /fable on any task."
