#!/bin/bash
# Writes "<installed>|<cask>|<stable>" to the cache file given as $1, for the statusline.
#
# Runs detached, never in the statusline's own path: `brew list` costs ~450 ms and the two
# fetches need the network, while the bar is redrawn on every keystroke. The statusline only
# ever reads the file this leaves behind.
#
# Three versions and not two, because the cask lags its own channel. Measured 2026-08-28: the
# cask sat on 2.1.231 while the stable channel had moved to 2.1.236, and releases land about
# daily -- so a check that only knows what brew offers is silent through most of the gap.
# Asking both is what separates "you can upgrade now" from "it exists but the cask has not
# caught up", which are different sentences with different actions.
#
# The channel is *stable*, and that is the whole point of the endpoint chosen here. The first
# version of this script asked GitHub for the newest release, which is the `latest` channel --
# 2.1.250 while stable was 2.1.236. Against a stable install that segment would have been lit
# permanently, and a signal that is always on says as little as one that never is. The cask
# `claude-code` tracks stable (its livecheck points at this same URL); `claude-code@latest` is
# a separate, conflicting cask for the other channel. Switch install channel and this line is
# what has to change with it.
#
# The brew version comes from the public formulae.brew.sh API rather than from `brew update`.
# Local cask metadata is stale until someone updates, so it can never report anything new --
# but `brew update` mutates state shared with everything else on this machine, and a private
# status bar has no business doing that in the background. Both calls here are reads, and
# neither is `gh`: that tool's account on this machine is the work one and stays out of here.

set -u

cache="${1:?usage: claude-version-check.sh <cachefile>}"

installed=$(brew list --cask --versions claude-code 2>/dev/null | awk '{print $2}')

cask=$(curl -fsS --max-time 8 https://formulae.brew.sh/api/cask/claude-code.json 2>/dev/null \
    | jq -r '.version // empty' 2>/dev/null)

# A one-line plain-text endpoint: cheaper than the GitHub API and with no rate limit to spend.
# tr strips the newline; the leading v is optional there, so it is removed if present.
stable=$(curl -fsS --max-time 8 https://downloads.claude.ai/claude-code-releases/stable 2>/dev/null \
    | tr -d '[:space:]')
stable="${stable#v}"

# The installed version is the one everything else is compared against, so without it there is
# nothing to write. The two remote answers are allowed to be missing on their own -- a failed
# fetch should cost that one sentence, not the whole segment.
[ -n "$installed" ] || exit 0

# Pipe-separated and not tab-separated, and that is not cosmetic. Tab is IFS whitespace, so
# bash collapses a run of them: with an empty middle field "2.1.231\t\t2.1.236" reads back as
# two fields, and the channel version silently lands in the cask slot -- the bar would then
# name `brew upgrade` for a version brew does not have. Found by the failing-fetch test case.
printf '%s|%s|%s\n' "$installed" "$cask" "$stable" > "$cache.tmp" && mv "$cache.tmp" "$cache"
