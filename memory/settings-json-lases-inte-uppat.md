---
name: settings-json-lases-inte-uppat
description: "Claude Code läser CLAUDE.md i varje förälder men .claude/settings.json bara i startkatalogen – en hook i en förälder gäller inte i barnkatalogerna, med eller utan git; mätt 2026-10-12"
metadata:
  type: reference
  scope: global
  originSessionId: 20abbf4f-a53f-41a2-91a4-450f3ed9ad24
  modified: 2026-10-12T18:53:20.702Z
---

`CLAUDE.md` läses uppåt genom varje förälder till roten, och det är därför jobbets fil en gång
kom in som projektfil (se `~/.claude-private/SKOTT.md`). **`.claude/settings.json` gör inte
det.** Mätt 2026-10-12 med en SessionStart-hook i en förälders `.claude/settings.json` och
`claude -p` från tre kataloger: den körde i föräldern själv (positiv kontroll), men varken i ett
barn med eget git eller i ett barn utan git.

Följden: en hook eller inställning som ska gälla "alla projekt under en katalog" kan inte
ligga i den katalogen. Den måste ligga i användarnivån eller kopieras in i varje repo – och
användarnivån är fel ställe för en vakt mot fel konfiguration, för den läses inte just när
konfigurationen är fel. Det var skälet att varningen för `~/ts_projects` hamnade i jobbets
`settings.json`.

Analogin till [[en-underkatalogs-claude-md-laddas-bara-vid-read]]: harnesset laddar olika
filer på olika villkor, och antagandet att de följer samma regel är det som ska mätas först.

Provet behöver en positiv kontroll. Utan körningen i föräldern hade två tysta barn kunnat
betyda att hooken var trasig, och inte att den inte ärvdes. `timeout` finns inte på macOS:
exit 127 från provet betyder att ingenting kördes.
