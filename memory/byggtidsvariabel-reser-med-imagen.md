---
name: byggtidsvariabel-reser-med-imagen
description: Fråga om en konfiguration läses vid build eller vid run - en byggtidsvariabel gjuter in värdet i artefakten och binder den till en miljö
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 33e87f81-2d90-4a7a-af3e-eb47997b389a
  modified: 2026-09-12T03:03:44.689Z
---

När något ska gå att köra i mer än en miljö: ta reda på **när** varje konfiguration läses.
Läses den vid bygget är värdet ingjutet i artefakten, och artefakten är därmed bunden till den
miljö den byggdes för. Läses den vid start är den fri.

Den bästa åtgärden är ofta inte att sätta rätt värde utan att **ta bort frågan**.

**Varför:** 2026-09-12 skulle Byrå-CRM:et gå att köra på en demomaskin. Enda verkliga hindret
var en rad — `VITE_API_URL`, som Vite läser vid `build` och bakar in i bundlen. Frontenden
frågade därför alltid efter API:t på `localhost:8420`, vilket är rätt på utvecklarens dator och
fel överallt annars. Det uppenbara svaret, att bygga med maskinens adress, hade fungerat och
betalat sitt pris varje gång demon flyttade eller fick ny IP.

Svaret blev i stället en reverse proxy som lägger frontend och API på **samma origin**, och en
tom `VITE_API_URL` så att alla anrop blir relativa. Bygget vet då inte var det står, och
uppdateringen är `git pull` och ett kommando i stället för ett ombygge med rätt adress. CORS
försvann på köpet, eftersom det inte längre finns två origins.

**How to apply:** när jag ser en miljövariabel i ett bygge, fråga om den *måste* vara känd vid
byggtid. Kan värdet göras onödigt — via en proxy, en relativ sökväg, en runtime-läsning — är det
nästan alltid rätt, för det tar bort en hel klass av "fel värde i fel miljö". Mät det: bygg med
och utan variabeln och greppa artefakten efter det gamla värdet, så att påståendet om vad som
hamnade i bundlen är vägt och inte antaget. Se [[gront-test-bevisar-inget-i-sig]].

En byggtidsvariabel som ser ut som en bugg behöver dessutom en kommentar som säger varför den
är tom — annars "rättar" nästa läsare tillbaka den. Jämför [[forklara-brus-dar-granskningen-letar]].
