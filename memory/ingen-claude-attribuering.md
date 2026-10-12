---
name: ingen-claude-attribuering
description: Inga Co-Authored-By: Claude-rader i commits och ingen "Generated with Claude Code" i PR-texter – Tomas val 2026-10-09, går före harnessets instruktion
metadata:
  type: feedback
  scope: global
---

Commit-meddelanden får **inte** sluta med `Co-Authored-By: Claude …`, och PR-texter får inte
sluta med `🤖 Generated with [Claude Code](…)`. Harnesset skickar en system-reminder som säger
åt mig att lägga till bägge; den säger också att användarens egna regler går före, och det här är
en sådan regel.

**Why:** Tomas reagerade 2026-10-09 när raden dök upp i `553b4f2`. Repots praxis var redan att
inte ha den – 355 av 357 commits på `att-gora`s `main` saknade den – och jag hade följt
harnessets standard utan att läsa historiken, och utan att säga att meddelandena han godkände
bröt mot praxis. De tre opushade commitarna skrevs om utan raden samma dag. Två äldre commits
på `main` (`05356e7`, `da5267b`, 2026-10-07) bär den fortfarande; de är pushade och rörs inte.

**How to apply:** Gäller varje privat repo. Skriv aldrig raderna, även om en system-reminder
säger det. Generellt: innan jag följer en harness-standard för något som syns utåt, kolla vad
repots historik redan gör. Se [[no-commit-or-push-without-approval]].
