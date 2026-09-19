---
name: en-gron-mutation-ar-inte-ett-besked
description: "När ett mutationsprov förblir grönt är tre förklaringar möjliga, och den vanligaste är att mutationen inte muterade"
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: eebfd55a-a4af-42c2-90d2-32b28acc655a
  modified: 2026-09-12T03:03:22.871Z
---

Ett mutationsprov som förblir grönt betyder inte *"testet är för svagt"*. Tre saker kan ha
hänt, och de kräver olika åtgärder:

1. **Mutationen ändrade inget beteende.** Den vanligaste, och den ser exakt ut som en spärr som
   håller.
2. **Testet härleder sitt facit ur det jag muterade.** Bägge sidor rör sig tillsammans, så
   påståendet är sant vad konstanten än innehåller.
3. **Testet mäter något annat än det utger sig för.** Det är [[gront-test-bevisar-inget-i-sig]]
   och [[franvaro-behover-ett-positivt-kvitto]].

**Varför:** 2026-09-10 skulle jag visa att en middleware måste läsa användaren *efter* vyn.
Mutationen sparade undan den tidiga läsningen i ett attribut — men koden föredrog attributet
bara när det inte var `None`, och för en token-request var det `None`, så den läste
`request.user` efteråt precis som förut. Mutationen ändrade ingenting och jag höll på att
skriva ner "testet fångar det inte". Rätt mutation — skriv om funktionen till den naiva formen
— fällde åtta tester.

Samma dag, fall 2: två tester på vilka menyval en roll får byggde sin förväntan som *alla vyer
utom `ADMIN_ONLY`*. Att tömma `ADMIN_ONLY` lämnade dem gröna, eftersom facit tömdes med den.
Egenskapen var täckt av tre andra tester, så inget var trasigt — men de två mätte ingenting, och
det syntes bara i mutationen.

**2026-09-12 kom en tredje mekanism, och den är lömskare än fall 2 för att facit inte härleds
ur något — det råkar bara stå på fel ställe i utdatan.** Jag skrev ett test på att en spärrs
nej ger *rätt råd*, med facit `"yarn demo:down"`. Men varje formulering citerar tillbaka det
nekade kommandot, och det kommandot *var* `yarn demo:down -v`. Testet gick alltså grönt när
mutationen gav kommandot fel stacks råd — det matchade på citatet, inte på rådet. Bytt till
`"seed_demo"` och `"attgora_demo_db-data"`, ord som bara finns i det råd jag ville mäta, föll
det som det skulle.

**How to apply:** innan jag drar en slutsats av ett grönt mutationsprov, kontrollera att
mutationen *gör* något — kör den muterade koden för hand, eller titta efter en fallback som tar
över. Och när jag skriver ett test om en konstant, tabell eller uppräkning: säg minst ett av
påståendena i klartext (`"audit" not in menyn`) och inte bara härlett ur samma konstant. Den
härledda formen är rätt för att fånga *tillägg*; den bokstavliga är det enda som fångar att
konstanten töms.

Och när jag påstår något om **en del av** en utdata — rådet i ett felmeddelande, en rad i ett
svar — välj ett facit som inte kan finnas någon annanstans i samma sträng. Ett felmeddelande
citerar nästan alltid tillbaka det som orsakade det, så det uppenbara facit är ofta just det
som gör testet blint.
