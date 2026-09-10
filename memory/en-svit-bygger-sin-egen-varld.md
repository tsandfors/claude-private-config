---
name: en-svit-bygger-sin-egen-varld
description: "En grön svit mäter världen sviten själv byggde, inte den miljö som sedan öppnas – migrationer, volymer och containrar faller utanför"
metadata: 
  node_type: memory
  scope: global
  type: feedback
  originSessionId: 9052740c-6e5c-4db0-946f-b5697cfb863a
  modified: 2026-09-10T02:06:29.172Z
---

En testsvit som reser sin egen stack och sitt eget tomma schema kan inte säga något om
tillståndet i den miljö som faktiskt körs efteråt. Grönt betyder *koden stämmer med sviten*,
aldrig *utvecklingsmiljön är i takt med koden*.

**Why:** I att-gora låg `0015_invitations` skriven och committad men aldrig körd mot
dev-databasen. Hela sviten var grön ett dygn – den bygger `attgora_test` från ett tomt schema
vid varje körning, så migrationen kördes där varje gång och saknades bara i den databas jag
skulle demonstrera i. Felet syntes först som en 500 i browsern: *relation "app_invitation"
does not exist*. Samma lucka gäller allt som lever utanför sviten: körande containrar byggda
ur en gammal image, volymer, cacher, seedad data som åldrats.

**How to apply:** När föregående session lagt till en modell, en migration eller ett nytt
beroende – kontrollera den körande miljön separat innan du öppnar appen eller drar en slutsats
ur att något "fungerar". `showmigrations`, `docker ps` med bildtagg, eller ett enda anrop mot
den riktiga endpointen. Frågan att ställa efter en grön svit är **vilken värld var det som
mättes**, och det är alltid den sviten själv reste.

Skilj det här från [[gront-test-bevisar-inget-i-sig]], som handlar om hur starkt ett påstående
är. Det här handlar om hur brett det räcker.
