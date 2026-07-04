#!/usr/bin/env bash
# Install fable-consult (manual /fable only — no auto layer): the skill plus
# the consultant and worker agents.
#
# Interactive install asks two questions:
#   1. Fable PLAN-consult effort?              (recommended: high)
#   2. Fable REVIEW / mid-consult effort?      (recommended: medium)
# Non-interactive: FABLE_EFFORT=high FABLE_REVIEW_EFFORT=medium ./install.sh
#
# Worker efforts are pinned in their frontmatter (speed/quality, no Fable
# cost): verifier+explorer low · coder medium ·
# engineer+reviewer+test-writer high. Edit the agent files to change.
set -euo pipefail

EFFORTS="low medium high xhigh max"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

ask() { # ask <prompt> <default> <valid...>
  local prompt="$1" def="$2"; shift 2
  local ans
  if [ ! -t 0 ]; then printf '%s' "$def"; return; fi
  while :; do
    printf '%s ' "$prompt" >&2
    read -r ans || { ans="$def"; break; }
    ans="${ans:-$def}"
    case " $* " in *" $ans "*) break ;; *) printf 'Invalid: %s\n' "$ans" >&2 ;; esac
  done
  printf '%s' "$ans"
}

PLAN_EFFORT="${FABLE_EFFORT:-$(ask 'Fable PLAN-consult effort? [low/medium/high/xhigh/max] (recommended: high)' high $EFFORTS)}"
REVIEW_EFFORT="${FABLE_REVIEW_EFFORT:-$(ask 'Fable REVIEW effort? [low/medium/high/xhigh/max] (recommended: medium)' medium $EFFORTS)}"
case " $EFFORTS " in *" $PLAN_EFFORT "*) ;; *) echo "FABLE_EFFORT must be one of: $EFFORTS" >&2; exit 1 ;; esac
case " $EFFORTS " in *" $REVIEW_EFFORT "*) ;; *) echo "FABLE_REVIEW_EFFORT must be one of: $EFFORTS" >&2; exit 1 ;; esac

mkdir -p "$CLAUDE/skills" "$CLAUDE/agents"

rm -rf "$CLAUDE/skills/fable"
cp -a "$SRC/skills/fable" "$CLAUDE/skills/fable"

for a in explorer oracle verifier coder engineer test-writer reviewer; do
  cp -a "$SRC/agents/$a.md" "$CLAUDE/agents/$a.md"
done

# Pin the two Fable efforts (BSD + GNU sed compatible).
sed -i.bak -E "s|^effort:.*|effort: ${PLAN_EFFORT}|" "$CLAUDE/agents/oracle.md"
sed -i.bak -E "s|effort down to \`[a-z]+\`|effort down to \`${REVIEW_EFFORT}\`|g; s|the same \`[a-z]+\` override|the same \`${REVIEW_EFFORT}\` override|g; s|Effort override \`[a-z]+\`|Effort override \`${REVIEW_EFFORT}\`|g" "$CLAUDE/skills/fable/SKILL.md"
rm -f "$CLAUDE/agents/oracle.md.bak" "$CLAUDE/skills/fable/SKILL.md.bak"

echo "Installed fable-consult (manual only) into $CLAUDE"
echo "  plan effort  : $PLAN_EFFORT    review effort: $REVIEW_EFFORT"
echo "  agents       : oracle + explorer, verifier, coder,"
echo "                 engineer, test-writer, reviewer"
echo
echo "Restart / reload your session, then run /fable on any task."
