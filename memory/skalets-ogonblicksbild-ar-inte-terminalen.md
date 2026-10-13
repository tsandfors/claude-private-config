---
name: skalets-ogonblicksbild-ar-inte-terminalen
description: Claude Codes Bash kör en ögonblicksbild av skalfunktionerna från sessionsstart, utan funktioner som börjar med _; en ändring i skalprofilen provas från en ny session, inte i zsh -f
metadata:
  type: reference
  scope: global
  originSessionId: 8419c0ef-d795-4eee-839a-b2535877b1e6
  modified: 2026-10-12T20:29:21.898Z
---

Claude Code sourcar inte `~/.zshrc` vid varje Bash-anrop. Vid sessionsstart skriver den en
ögonblicksbild till `<config>/shell-snapshots/`, och **funktioner vars namn börjar med `_` kommer
inte med** (zsh:s kompletteringsfunktioner filtreras bort på det sättet). Mätt 2026-10-12:
`gh ()` fanns i ögonblicksbilden men inte hjälpfunktionen `_private_tree` som den anropade.
Varje `gh` svarade `command not found`, villkoret blev falskt, och i det privata trädet gick
`gh` förbi tokenen. Lagat i `~/.claude-private` commit `7e5973c` genom att döpa om till
`private_tree`. Detaljerna står i `SKOTT.md`.

**Why:** ett prov i `env -i zsh -f` mätte terminalen och var grönt. Sessionen kör ett annat
skal. Det syntes först som brus i en jobbsession.

**How to apply:** en funktion som en skalfunktion i profilen anropar får inte heta `_…`. Prova
en ändring i skalprofilen från en ny session (`claude -p "… type <funktion> …" --allowedTools
Bash`). Prompten ska stå före `--allowedTools`, som annars äter upp den. Sessioner som redan är
igång behåller den gamla ögonblicksbilden tills de startas om. Se också
[[en-matning-kan-vara-inaktuell-eller-stympad]].
