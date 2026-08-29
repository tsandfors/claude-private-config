---
name: korrigera-inte-bara-komplettera
description: Jag kompletterar av reflex men korrigerar bara på uppmaning; påståenden jag redan gjort måste prövas mot verkligheten innan jag rapporterar klart
metadata: 
  type: feedback
  originSessionId: 053b15f7-c4a3-44ea-971f-bfe661272012
  modified: 2026-08-22T04:09:26.202Z
  scope: global
---

Att lägga till något gör jag av mig själv när ett arbete är klart. Att gå tillbaka och
**riva upp ett påstående jag redan gjort** gör jag inte, om inte någon frågar. Det är samma
lucka tre gånger under en enda dag (2026-08-22 i Byrå-CRM:et), och alla tre gångerna fanns
beviset redan hos mig:

1. Jag rapporterade felrutan som klar med "verifierat i browsern" och nämnde inte att jag
   inte skrivit ett enda test. Tomas fick fråga.
2. Accessibility-trädet visade fjorton namnlösa kontroller i händelsepanelen genom två
   browsergenomgångar. Jag läste förbi det bägge gångerna; ett jsdom-test hittade det.
3. Jag uppdaterade `BACKLOG.md` noggrant i fyra commits medan `CLAUDE.md`s *Här står vi*
   fortsatte påstå att ingenting av felhanteringen var byggt – det första en ny session läser.

**Varför:** ett avslutat arbete triggar frågan "vad ska jag lägga till?". Den frågan hittar
aldrig ett påstående som var sant i morse och blev falskt vid lunch. Ett dokument som beskriver
*nuläget* blir inte ofullständigt när något byggs, det blir osant, och ingenting påminner om
det. Samma sak med en rapport: "verifierat i browsern" är inte en lögn, men den låter färdig,
och det är effekten som räknas.

**How to apply:** Innan jag säger att något är klart, gör ett **motsägelsesvep** – inte "vad
kan jag komplettera?" utan **"vad har jag redan skrivit eller visat som inte längre stämmer?"**
Det gäller överlämningstexter, statusavsnitt, tidigare rapporter i samma session, och
siffror jag citerat. Och där det går: gör kontrollen mekanisk i stället för till en vana, precis
som namnsvepet blev ett test och regeln om *Här står vi* blev en rad under *Arbetssätt* i
projektets `CLAUDE.md`. En vana glömmer jag igen; ett test gör det inte.
Se även [[verifiering-hor-till-leveransen]] och [[utmana-oklarheter]].
