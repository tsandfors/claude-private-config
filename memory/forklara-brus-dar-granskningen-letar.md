---
name: forklara-brus-dar-granskningen-letar
description: "Ofarligt brus jag lämnar efter mig ska förklaras på den plats nästa granskning tittar, annars återupptäcks det som ett fynd"
metadata: 
  node_type: memory
  scope: global
  type: feedback
  originSessionId: 9052740c-6e5c-4db0-946f-b5697cfb863a
  modified: 2026-09-10T02:06:45.007Z
---

Lämnar jag efter mig något som ser ut som ett fel men inte är det – en lograd, en varning, ett
konsolfel, en misslyckad förfrågan i nätverkspanelen – ska förklaringen skrivas där nästa
granskning faktiskt letar, inte där jag råkar skriva just då.

**Why:** Acceptsidan i att-gora ger en 404 i konsolen efter en lyckad accept: cachen töms,
den ännu monterade frågan hämtar om en länk som just spenderats, och svaret landar efter
omdirigeringen utan komponent att rita i. Utan verkan i gränssnittet – men ett konsolfel är ett
av de mönster projektets browsergenomgång uttryckligen letar efter, så raden hade blivit nästa
genomgångs "fynd" och kostat en kvart att jaga. Tomas frågade rakt ut om det var ett fel som
skulle lagas; att jag nämnt det utan att säga *varför* jag nämnde det gjorde saken oklarare,
inte tydligare.

**How to apply:** Två saker. Nämner jag brus i en rapport, skriv i samma andetag om det ska
åtgärdas eller bara vara känt – annars läses varje notering som en dold uppmaning. Och
överlever bruset commiten, skriv en rad på den plats granskningen läser (projektets `CLAUDE.md`,
en docstring, en kommentar vid koden som orsakar det). Alternativet – att tysta bruset – byter
ofta en förklarad rad i konsolen mot en oförklarad rad i koden, och det är sällan en vinst.
