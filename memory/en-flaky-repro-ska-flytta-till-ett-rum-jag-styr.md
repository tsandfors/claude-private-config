---
name: en-flaky-repro-ska-flytta-till-ett-rum-jag-styr
description: Ett fel som bara uppträder ibland beror ofta på ett sammanträffande mellan värden - flytta provet dit jag kan konstruera sammanträffandet i stället för att vänta på det
metadata:
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 66f58d0f-067a-49d3-b4a2-59fb3deda214
  modified: 2026-10-02T21:15:35.411Z
---

Ett fel jag sett men inte kan upprepa ska flyttas till det minsta rum där jag **styr varje
värde** – ett enhetstest, inte miljön det dök upp i. "Jag kunde inte reproducera" är inte
samma sak som "det finns inte", och skillnaden mellan de två avgörs nästan alltid av om jag
kan konstruera förutsättningen i stället för att vänta på den.

**Varför:** 2026-10-02 gav browsern ett konsolfel om två syskon med samma React-nyckel. Det
gick inte att upprepa – fem försök, varav ett med exakt samma värdeövergång, var tysta. Jag
var på väg att skriva upp det som *osäkert* och gå vidare. Orsaken visade sig vara ett
**sammanträffande mellan två oberoende nummerrymder**: fältets nyckel var det sparade värdet
och ringens en räknare över antalet skrivningar, så de kolliderade bara när det sparade värdet
råkade vara `1` **och** det var fältets första skrivning. I browsern var det ett lotteri. I ett
vitest på tolv rader var det ett påstående, rött på första försöket, och grönt efter en
enradsfix.

Två saker ur det, och den andra är den större:

- **Flakighet är en ledtråd om formen på felet.** Att det beror på *vilket värde* något har
  pekar på en jämförelse mellan två saker som inte borde kunna jämföras. Fråga vad som råkade
  vara lika den gången det small.
- **Antalet misslyckade försök mäter rummet, inte felet.** Fem tysta körningar i browsern sa
  ingenting om huruvida buggen fanns – bara att jag inte kontrollerade de variabler som
  avgjorde saken. Att dra slutsatsen *"går inte att upprepa, alltså troligen inget"* är att
  läsa ett dåligt instrument som ett svar.

**How to apply:** När något bara uppträtt en gång: fråga först *vilken variabel var ovanlig
den gången?*, och bygg sedan det minsta provet där jag kan sätta den variabeln själv. Gör det
innan jag märker fyndet som osäkert – osäkerhetsmärkningen är till för det jag inte kan
konstruera, inte för det jag inte orkade. Och när felet bara syns i konsolen: låt testet påstå
något om konsolen, med ett positivt ankare bredvid så provet inte blir grönt av att ingenting
hände alls. Se även [[gront-test-bevisar-inget-i-sig]] och
[[franvaro-behover-ett-positivt-kvitto]].
