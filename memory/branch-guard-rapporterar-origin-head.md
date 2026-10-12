---
name: branch-guard-rapporterar-origin-head
description: "att-gora: branch-guard.py rapporterar en falsk lokal branch 'origin' när lokal main ligger efter origin/main – känd bugg, olagad 2026-10-09"
metadata:
  node_type: memory
  type: project
  scope: att-gora
  originSessionId: ee6fd1c8-4f20-4089-b427-044278a03605
  modified: 2026-10-09T12:56:04.549Z
---

`.claude/hooks/branch-guard.py`, funktionen `unmerged`, läser `for-each-ref` med
`%(refname:short)`. Git förkortar `refs/remotes/origin/HEAD` till bara `origin`, men koden
filtrerar på strängen `origin/HEAD` – så remotens HEAD slinker igenom som en lokal branch som
heter `origin`, med lika många commits som lokal `main` ligger efter. Samma eftersläpning gör att
redan ihopslagna brancher (2026-10-09: `toem-konto`) rapporteras som obemärgat arbete, eftersom
basen är lokal `main` och inte `origin/main`.

**Why:** Sett vid sessionsstart 2026-10-09 och utrett samma dag; Tomas fick frågan om lagning men
den togs inte upp. Står inte i `BACKLOG.md`.

**How to apply:** Ser du "origin — N commits, bara lokal" vid start: det är den här buggen, kör
`git pull` på main och läs om. Lagningen är att filtrera `origin` också (eller läsa
`%(refname)` och strippa själv), plus ett test i `tests/unit/test_bash_guard.py`; jämför
eventuellt mot `origin/<base>`. Fråga Tomas innan, och väg den mot regeln om enmansföretagaren –
den påverkar arbetsflödet, inte appen.
