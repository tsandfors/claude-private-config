---
name: sviten-kor-inte-alla-grindar
description: "En grön testsvit säger ingenting om de kontroller den inte kör – typkollen, lintern, bygget – och den som gäller vid merge är sällan den jag körde"
metadata:
  node_type: memory
  scope: global
  type: feedback
  originSessionId: b9224132-60ef-4cda-8b3d-ba0788044efa
  modified: 2026-10-01T03:27:00.579Z
---

Ett projekt har nästan alltid flera grindar – tester, typkontroll, linter, bygge – och
testkommandot kör bara sin egen. "Grönt" betyder *den grind jag råkade köra släppte igenom*,
inte *koden är hel*.

**Why:** I att-gora kör `yarn test:full` vitest och pytest men inte `tsc`. Jag skrev en ny
testfil som importerade `node:fs`, vars typer inte låg i projektet, körde sviten, fick grönt
och committade ett brutet bygge. Bygget *hade* körts den dagen – men före filen fanns, och
ingenting kopplade de två. Felet var dessutom i en testfil, alltså i den sortens fil man lätt
antar ligger utanför kompileringen; här typkollas de med resten, med avsikt.

**How to apply:** Räkna upp grindarna en gång per projekt i stället för att lita på
testkommandots namn – läs CI-konfigurationen eller `package.json`-skripten, för det är de som
avgör vad som gäller vid merge. Kör sedan den grind som **rör det jag ändrat**: en ny eller
ändrad fil under ett typkollat träd kräver ett bygge även om bara tester ändrats. Och ett
bygge som kördes *före* den sista filen skrevs har inte sett den – ordningen räknas, inte att
kommandot förekom någon gång under sessionen.

Besläktat med [[en-svit-bygger-sin-egen-varld]], som handlar om vilken *värld* sviten mätte.
Det här handlar om vilket *verktyg* som mätte den.
