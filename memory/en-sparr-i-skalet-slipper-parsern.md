---
name: en-sparr-i-skalet-slipper-parsern
description: "En spärr mot ett kommando kan ligga i en skalfunktion i stället för i en PreToolUse-hook – skalet har redan tolkat raden, så ingen parser behövs och ingen kopia kan glida isär; hålen blir andra, inte färre"
metadata:
  node_type: memory
  type: feedback
  scope: global
  originSessionId: db7278f7-c89c-4582-9cd0-1b87847a7481
  modified: 2026-10-13T09:47:46.586Z
---

En `PreToolUse`-hook får kommandoraden som en sträng och måste gissa vad skalet kommer att
köra: `git commit -m "… gh auth login …"` ska släppas igenom, `x && gh auth token` ska inte.
att-goras `bash-guard.py` bär sextio rader parser för just det. En funktion med samma namn som
kommandot (`gh()` i `~/.claude-private/shell/functions.zsh`) anropas däremot bara när
kommandot faktiskt körs, och `"$@"` är argumenten som de blev – skalet har redan gjort jobbet.

Upptäckt 2026-10-13 när att-goras regel 3 skulle flytta till konfigrepot. Förslaget var först
att kopiera parsern dit, och Tomas avvisade det: två parsrar som måste tycka likadant är den
glidning vi drabbats av flera gånger. Funktionen fanns redan, gällde redan i rätt träd och
versionerades redan.

**Why:** en spärr som behöver en kopia av något för att kunna flytta är en spärr på fel lager.
Frågan "var har raden redan tolkats?" hittade lagret.

**How to apply:** när en Bash-spärr ska gälla i fler repon än ett, eller kräver tolkning av
kommandoraden – fråga först om det finns en skalfunktion eller ett omslag där kommandot redan
passerar. Skriv ut hålen ärligt, för de byts och försvinner inte: `command gh`, absolut sökväg
och `bash -c` går förbi en funktion (hooken fångade dem), medan `eval`, variabler och alias
fångas (hooken såg dem inte). Provet i en riktig session kör Tomas själv med `!` i en **ny**
session – sessionens skal är en ögonblicksbild från start ([[skalets-ogonblicksbild-ar-inte-terminalen]]),
och auto-lägets klassificerare nekar en kapslad `claude -p` som kör ett credential-kommando,
påhittat mål eller inte. Rikta provet mot ett påhittat mål ([[prov-far-inte-orsaka-skadan]]).
Se också [[instruktion-ar-ingen-sparr]] och [[en-vakt-pa-namnet-tacker-inte-saken]].
