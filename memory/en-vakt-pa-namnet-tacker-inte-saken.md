---
name: en-vakt-pa-namnet-tacker-inte-saken
description: "En spärr som villkoras på kommandonamnet skyddar namnet och inte saken - räkna ingångarna till det som skyddas, inte sätten jag brukar nå det"
metadata:
  type: feedback
  originSessionId: 7479e10e-9fb7-4bb0-9e7c-cd73abc3d077
  scope: global
  modified: 2026-09-05T06:30:00.000Z
---

Skottet mellan Byrå-CRM:et och jobbets konfiguration vilade på en `claude()`-funktion i zsh:
står du i projektträdet sätts `CLAUDE_CONFIG_DIR` till den privata katalogen. Den ersatte ett
alias, med motiveringen att *ett alias kräver att man minns att skriva det*.

2026-09-05 visade sig argumentet gälla funktionen själv. `~/bin/claude-latest` pekade på en
andra installation i `~/.local/bin` och nådde binären utan att gå genom funktionen. En hel
session i det privata repot kördes därför på jobbets konfiguration – jobbets `CLAUDE.md`,
jobbets minneslager, jobbets PR-hook, och sessionsdatan skriven i jobbets katalog. Den
upptäcktes inifrån sig själv, av en fråga om något helt annat.

**Why:** Ett alias kräver att man minns att skriva det; **en funktion kräver att man minns att
inte skriva något annat.** Bägge villkorar på *namnet jag brukar använda* i stället för på
*saken som ska skyddas*, och skillnaden syns inte förrän det finns ett andra namn. Skottet
hade dessutom granskats åt bägge håll några dagar tidigare – vad läcker in, vad läcker ut –
utan att någon ställde frågan *finns det en väg till?*. Det är samma tomrum som
[[backup-svarar-inte-pa-vad-som-blev-kvar]] beskriver: verifieringen täckte den sida där ett
facit fanns.

**How to apply:** När jag bygger en spärr eller en isolering, fråga **hur skyddat objektet kan
nås, inte hur jag brukar nå det** – räkna ingångarna (andra binärer, symlänkar, wrappers,
`command`, en absolut sökväg) innan jag skriver villkoret. Villkora hellre på något som inte
kan dupliceras: här flyttades det från kommandonamnet till *katalogen*, som täcker varje
ingång inklusive nästa. Lägg inte till en gren per namn – det är att räkna upp namn igen.

Och lägg ett upptäckande lager där det inte kan tystna: vakten som märker att skottet är
brutet måste bo i det lager som alltid läses, för en vakt inuti det som inte lästes kan
omöjligt säga ifrån. Se [[instruktion-ar-ingen-sparr]] och [[tystnad-ar-tvetydig]].
