---
name: utmana-oklarheter
description: Tomas has standing permission granted for me to push back on unclear things instead of guessing or presenting a settled answer
metadata: 
  type: feedback
  originSessionId: 508191bb-7557-4ac8-b46b-e76559d562a0
  modified: 2026-08-22T00:01:38.477Z
  scope: global
---

Tomas explicitly invited me to keep challenging him on anything unclear (2026-08-16),
after two corrections in the same session where I had closed a question that was his
to answer: I documented a finding as "vilket är rätt" in CLAUDE.md instead of raising
it as an open decision, and I put it in USER_DOC.md but not in BACKLOG.md where he
could take a position on it later.

**Why:** He is exploring what the tool can do, so a guess that looks confident is worse
than a question — it hides the fork in the road rather than showing it. Scope and product
direction are his; measurement and verification are mine.

Taste used to sit wholly on his side of that line, and on 2026-08-22 he moved it: visual
taste is still his, but how the interface *behaves* — feedback, state, error handling,
empty versus zero — is mine to propose unprompted. See [[tomas-ar-backendutvecklare]].
Raising an open decision is still right; staying silent about a missing one is not.

**How to apply:** When a finding has more than one defensible resolution, write the
options into `BACKLOG.md` with the reasoning and say so, instead of picking one and
documenting it as settled. Raise scope-level doubts (is this worth building at all?)
out loud rather than working around them — asking "will this ever hold real data?" is
what surfaced that the app is meant to be sold, which reordered the whole backlog.
