#!/bin/bash
# Statusline for private Claude Code sessions.
#
# Rebuilt from a screenshot of the work setup's bar rather than copied from it -- the work
# config's statusline is a different one (emoji, no segments), and the PR segment it showed
# cannot exist here anyway: `gh` is off limits in the private space. Ahead/behind took its
# place because it answers the same end-of-day question -- is anything unpushed? -- without a
# network call and without touching the work account's hosts.yml.
#
# Reads the session JSON on stdin. Writes one line. Anything that cannot be determined is
# dropped rather than shown empty: a segment that is always present but sometimes blank reads
# as a bug in the bar. The guard segment is the one exception, and the comment there says why.

export LC_ALL=C

input=$(cat)

# One jq pass rather than one per field. The bar is redrawn on every turn and keystroke, so
# each process spawned here is paid over and over.
#
# Separated by the unit separator and not by a tab, and that is not a style choice. Tab is IFS
# whitespace, so bash collapses a run of them into one delimiter -- an empty field in the
# middle then shifts every later value one slot to the left. Measured with `.effort.level`
# absent: EFFORT came out holding the context percentage and the context segment vanished
# entirely. This is the same bug the version cache already taught, and it was sitting here
# undiscovered while that comment was being written a few lines below.
US=$'\037'
IFS="$US" read -r VERSION CURRENT_DIR MODEL EFFORT CTX_PCT COST <<<"$(printf '%s' "$input" | jq -r '
    [ .version // ""
    , .workspace.current_dir // ""
    , .model.display_name // ""
    , .effort.level // ""
    , (.context_window.used_percentage // "" | tostring)
    , (.cost.total_cost_usd // "" | tostring)
    ] | join("\u001f")')"

GRAY=$'\033[90m'
WHITE=$'\033[97m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
CYAN=$'\033[36m'
RED=$'\033[31m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

SEP="${GRAY} │ ${RESET}"

segments=()

# --- gather git state, in as few calls as possible -----------------------------------------
# Every git invocation costs ~45 ms on this machine and the bar is redrawn constantly, so the
# count matters more than the elegance. One porcelain call answers four questions at once: are
# we in a repo at all (its exit code), which branch, how far from upstream, and what is
# untracked -- the `?` lines are already in the output that has to be read anyway. A separate
# `git rev-parse` and `git ls-files` were both paying for answers this one already gives.
in_git=false
branch=""
ahead=""
behind=""
untracked=0
if status_out=$(git status --porcelain=v2 --branch 2>/dev/null); then
    in_git=true
    while IFS= read -r line; do
        case "$line" in
            "# branch.head "*) branch="${line#\# branch.head }" ;;
            "# branch.ab "*)
                ab="${line#\# branch.ab }"
                ahead="${ab%% *}"
                ahead="${ahead#+}"
                behind="${ab##* }"
                behind="${behind#-}"
                ;;
            "? "*) untracked=$((untracked + 1)) ;;
        esac
    done <<<"$status_out"
fi

# --- the guard --------------------------------------------------------------------------
# Shown in every state, including the good one. A marker that only appears when something is
# wrong cannot be told apart from a marker that stopped working, which is the same reason
# Nothing.tsx has three states and not two.
#
# Note what this can and cannot catch. The config-dir half is nearly decorative: this script
# lives under ~/.claude-private, so a session running the work config renders the work bar
# instead and never reaches this line. The user.email half is the one with teeth -- the
# override is repo-local by design, and if it is ever dropped the next commit silently
# carries the work address. That failure is invisible until someone reads the log.
guard=""
case "$CLAUDE_CONFIG_DIR" in
    *.claude-private) guard="${GREEN}●${RESET} ${GRAY}privat${RESET}" ;;
    *)                guard="${BOLD}${RED}▲ JOBBKONFIG${RESET}" ;;
esac
if [ "$in_git" = true ] && [ -z "$(git config --local user.email 2>/dev/null)" ]; then
    guard="${BOLD}${RED}▲ GLOBAL E-POST${RESET}"
fi
segments+=("$guard")

# --- version ------------------------------------------------------------------------------
[ -n "$VERSION" ] && segments+=("${GRAY}✻${RESET} ${WHITE}v${VERSION}${RESET}")

# --- a newer version is available -----------------------------------------------------
# Silent unless there is something to do, which is what was asked for. That makes it the one
# segment whose failure is invisible -- if the check breaks, the bar simply never mentions an
# update again. Acceptable here and nowhere else in this file: missing a version bump costs a
# day, while the guard above is about a commit going out under the wrong name.
#
# Nothing is fetched inline. The refresher runs detached at most every six hours and leaves a
# file behind; this only reads it. The touch before spawning claims the slot, so a burst of
# redraws cannot start a burst of checks.
CACHE_DIR="$HOME/.claude-private/cache"
CACHE="$CACHE_DIR/claude-version"
# One `find` rather than `date` plus `stat`: half the processes for the same answer, and it
# drops the BSD-only `stat -f`. 360 minutes is the six hours.
if [ ! -f "$CACHE" ] || [ -n "$(find "$CACHE" -mmin +360 2>/dev/null)" ]; then
    mkdir -p "$CACHE_DIR"
    touch "$CACHE"
    ("$HOME/.claude-private/bin/claude-version-check.sh" "$CACHE" >/dev/null 2>&1 &) 2>/dev/null
fi
INSTALLED=""
CASK=""
STABLE=""
# IFS='|' and not a tab: tab is IFS whitespace and a run of them collapses, so an empty
# field would shift every later value one slot to the left.
[ -s "$CACHE" ] && IFS='|' read -r INSTALLED CASK STABLE < "$CACHE"

# newer <a> <b> -- true when b sorts above a. sort -V and not a string compare: 2.1.24 is
# older than 2.1.231, while as text it looks newer because 4 beats 3 on the fifth character.
newer() {
    [ -n "$1" ] && [ -n "$2" ] && [ "$1" != "$2" ] &&
        [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -1)" = "$2" ]
}

# Three states, each naming exactly one thing to do -- and in the order you would do them.
# Brew first, because that is the only one that is actionable right now. Then the restart,
# which is what an upgrade leaves behind. Last, and only when the other two are quiet, the
# news that the stable channel has moved on without the cask: nothing to do, so it stays gray
# and does not name a command. `brew upgrade` would not fetch it, and pointing at a command
# that cannot help is the thing this codebase keeps deciding not to do.
if newer "$INSTALLED" "$CASK"; then
    segments+=("${BOLD}${YELLOW}${RESET} ${YELLOW}brew: ${CASK}${RESET}")
elif newer "$VERSION" "$INSTALLED"; then
    segments+=("${CYAN}⟳ starta om för ${INSTALLED}${RESET}")
elif newer "$INSTALLED" "$STABLE"; then
    segments+=("${GRAY} ${STABLE} ute${RESET}")
fi

# --- model and effort -----------------------------------------------------------------
# Not here to be read but to be noticed: .claude/settings.json pins a model, and a silent
# fallback to another one shows up nowhere else. "(1M context)" loses its noun to save width.
if [ -n "$MODEL" ]; then
    model_seg="${WHITE}${MODEL/ context/}${RESET}"
    [ -n "$EFFORT" ] && model_seg+=" ${GRAY}· ${EFFORT}${RESET}"
    segments+=("$model_seg")
fi

# --- context ------------------------------------------------------------------------------
# Gray while there is room. Green would read as an achievement, and a bar that reassures in
# color has nothing left to say with when it matters.
if [ -n "$CTX_PCT" ] && [ "$CTX_PCT" != "null" ]; then
    ctx_color="$GRAY"
    [ "$CTX_PCT" -ge 50 ] 2>/dev/null && ctx_color="$YELLOW"
    [ "$CTX_PCT" -ge 80 ] 2>/dev/null && ctx_color="$RED"
    segments+=("${ctx_color}${CTX_PCT}%${RESET}")
fi

# --- what the session has cost -------------------------------------------------------------
# Sits next to the context percentage because the two answer the same question from different
# sides: what this session has consumed. Everything after it is about place, not spend.
#
# Two decimals and not one. The work bar rounds to a single decimal, which prints `$0.0` for
# most of a morning -- a number that reads as "nothing" or as a broken segment, and there is
# no way to tell which. `$0.04` is the smaller lie.
#
# No threshold color, and that is the deliberate half. A gray-to-red scale would have to break
# at some number, and there is no budget here for that number to mean anything against -- an
# alarm whose comparison is invented is the failure mode the version segment already taught.
# The figure is here to be glanced at, not to be obeyed.
#
# Worth knowing what it is: inference runs through Vertex, so this is Claude Code's own
# estimate from tokens and a price list, not a bill anyone will send. It tracks the shape of a
# session's spend, not its accounting.
if [ -n "$COST" ] && [ "$COST" != "null" ]; then
    printf -v cost_fmt '%.2f' "$COST" 2>/dev/null &&
        segments+=("${GRAY}\$${RESET}${WHITE}${cost_fmt}${RESET}")
fi

# --- path ---------------------------------------------------------------------------------
# Truncated from the left, because the tail is what identifies a directory. The ellipsis is
# what says it was cut -- without it a shortened path looks like a real one. The cut is
# tighter than it was: four segments were added ahead of it and the line has to fit.
if [ -n "$CURRENT_DIR" ]; then
    tilde='~'
    path="${CURRENT_DIR/#$HOME/$tilde}"
    max=32
    if [ ${#path} -gt $max ]; then
        path="…${path: -$((max - 1))}"
    fi
    segments+=("${GRAY}${RESET} ${WHITE}${path}${RESET}")
fi

# --- git ------------------------------------------------------------------------------
if [ "$in_git" = true ]; then
    # A detached HEAD reports "(detached)", which is a state worth seeing rather than hiding.
    [ -n "$branch" ] && segments+=("${GRAY}${RESET} ${BOLD}${GREEN}${branch}${RESET}")

    # Uncommitted work against HEAD, plus the untracked count gathered above. The diff alone
    # was quietly blind to a new file -- it does not exist as far as `git diff` is concerned,
    # so a forgotten `git add` looked exactly like a clean tree.
    stat=$(git diff --shortstat HEAD 2>/dev/null)
    if [ -n "$stat" ] || [ "$untracked" != "0" ]; then
        diff_seg="${GRAY}${RESET}"
        if [ -n "$stat" ]; then
            files=$(printf '%s' "$stat" | sed -n 's/^ *\([0-9]*\) file.*/\1/p')
            added=$(printf '%s' "$stat" | sed -n 's/.*[^0-9]\([0-9]*\) insertion.*/\1/p')
            removed=$(printf '%s' "$stat" | sed -n 's/.*[^0-9]\([0-9]*\) deletion.*/\1/p')
            diff_seg+=" ${WHITE}${files}${RESET}"
            [ -n "$added" ] && diff_seg+=" ${GRAY}•${RESET} ${GREEN}+${added}${RESET}"
            [ -n "$removed" ] && diff_seg+=" ${RED}-${removed}${RESET}"
        fi
        [ "$untracked" != "0" ] && diff_seg+=" ${YELLOW}?${untracked}${RESET}"
        segments+=("$diff_seg")
    fi

    # Ahead/behind is only meaningful with an upstream; without one git omits branch.ab and
    # the segment disappears, which is the honest answer to "how far ahead of origin am I".
    if [ -n "$ahead" ] && [ -n "$behind" ]; then
        up="${GRAY}↑${ahead}${RESET}"
        [ "$ahead" != "0" ] && up="${YELLOW}↑${ahead}${RESET}"
        down="${GRAY}↓${behind}${RESET}"
        [ "$behind" != "0" ] && down="${CYAN}↓${behind}${RESET}"
        segments+=("${up} ${down}")
    fi
fi

out=""
for seg in "${segments[@]}"; do
    [ -n "$out" ] && out+="$SEP"
    out+="$seg"
done
printf '%s\n' "$out"
