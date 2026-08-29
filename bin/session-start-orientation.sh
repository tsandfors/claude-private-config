#!/bin/bash
# SessionStart hook: inject a private project's "Var man börjar" section into context.
#
# The convention this establishes: a private repo may put a "## Var man börjar" section at the
# top of BACKLOG.md, and that section — and only that section — is loaded automatically at
# session start. The point is that reading order is a rule the harness enforces rather than a
# sentence in CLAUDE.md that a session can skip. att-gora is the repo it was written for; the
# hook is silent everywhere the convention is absent, so adopting it elsewhere is one heading.
#
# Deliberately not the whole file. BACKLOG.md is 65 kB in att-gora against CLAUDE.md's 73 kB,
# so importing it wholesale would roughly double what every session pays before it starts.
set -uo pipefail

MAX_LINES=120
root="${CLAUDE_PROJECT_DIR:-$PWD}"
backlog="$root/BACKLOG.md"

[ -r "$backlog" ] || exit 0

section=$(awk '
  /^## Var man börjar[[:space:]]*$/ { found = 1; next }
  found && /^## / { exit }
  found && /^---[[:space:]]*$/ { exit }
  found { print }
' "$backlog")

# Strip leading and trailing blank lines so the injected block has no ragged edges.
section=$(printf '%s\n' "$section" | sed -e '/./,$!d' -e :a -e '/^\n*$/{$d;N;ba' -e '}')

[ -n "$section" ] || exit 0

total=$(printf '%s\n' "$section" | wc -l | tr -d ' ')
truncated=""
if [ "$total" -gt "$MAX_LINES" ]; then
  section=$(printf '%s\n' "$section" | head -n "$MAX_LINES")
  truncated="

[Avklippt efter $MAX_LINES av $total rader. Resten står i BACKLOG.md.]"
fi

cat <<EOF
Ur $backlog, sektionen "Var man börjar" — injicerad av en SessionStart-hook, inte läst av mig.
Resten av filen är oläst; läs den innan du tar en punkt härifrån.

$section$truncated
EOF
