#!/bin/bash
# Writes "<installed>|<cask>|<stable>" to the cache file given as $1, for the statusline.
#
# Runs detached, never in the statusline's own path: `brew list` costs ~450 ms and the two
# fetches need the network, while the bar is redrawn on every keystroke. The statusline only
# ever reads the file this leaves behind.
#
# Brew is asked twice -- what is installed and what the cask offers -- because the cask lags
# its own channel. Measured 2026-08-28: the cask sat on 2.1.231 while the stable channel had
# moved to 2.1.236, and releases land about daily, so a check that only knows what brew offers
# is silent through most of the gap. Asking both is what separates "you can upgrade now" from
# "it exists but the cask has not caught up", which are different sentences with different
# actions.
#
# Both channels are fetched, and which one applies is worked out by the statusline from the
# running version rather than assumed here. That is the 2026-09-06 correction, and it is worth
# the paragraph because the first two attempts each failed in the opposite direction.
#
# Attempt one asked GitHub for the newest release, which is the `latest` channel -- 2.1.250
# while stable was 2.1.236. Against a stable install that segment would have been lit
# permanently, and a signal that is always on says as little as one that never is. So attempt
# two asked only for stable, with a note saying "switch install channel and this line is what
# has to change with it".
#
# The channel was switched and the line did not change. Measured 2026-09-06: `~/bin/claude-latest`
# -> `~/.local/bin/claude` was running 2.1.263 while this script reported on Homebrew's
# `claude-code` at 2.1.236, all three cached fields equal, segment silent. It was not silent
# because nothing was available -- it was silent because it was reporting on a binary nobody
# starts, and it would have stayed silent forever.
#
# Both mistakes are one mistake: the reference point was whatever this script could reach
# easily, rather than the thing being asked about. The running version is the only honest
# reference, and only the statusline knows it -- the harness hands it over on stdin. So this
# script stops deciding and just reports what exists: what brew has installed, what brew could
# install, and where each of the two channels stands.
#
# The cask `claude-code` tracks stable (its livecheck points at that URL); `claude-code@latest`
# is a separate, conflicting cask for the other channel.
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

# One-line plain-text endpoints: cheaper than the GitHub API and with no rate limit to spend.
# tr strips the newline; the leading v is optional there, so it is removed if present.
channel() {
    local answer
    answer=$(curl -fsS --max-time 8 "https://downloads.claude.ai/claude-code-releases/$1" \
        2>/dev/null | tr -d '[:space:]')
    printf '%s' "${answer#v}"
}

stable=$(channel stable)
latest=$(channel latest)

# Nothing here is the reference point any more, so nothing here is individually required: the
# statusline compares against the running version and simply says less when a field is empty.
# Bail only when every field is empty, which means the network was down and there is no news
# to write -- overwriting a good cache with four blanks would turn a stale answer into no
# answer. A failed fetch should cost one sentence, not the whole segment.
[ -n "$installed$cask$stable$latest" ] || exit 0

# Pipe-separated and not tab-separated, and that is not cosmetic. Tab is IFS whitespace, so
# bash collapses a run of them: with an empty middle field "2.1.231\t\t2.1.236" reads back as
# two fields, and the channel version silently lands in the cask slot -- the bar would then
# name `brew upgrade` for a version brew does not have. Found by the failing-fetch test case.
printf '%s|%s|%s|%s\n' "$installed" "$cask" "$stable" "$latest" > "$cache.tmp" \
    && mv "$cache.tmp" "$cache"
