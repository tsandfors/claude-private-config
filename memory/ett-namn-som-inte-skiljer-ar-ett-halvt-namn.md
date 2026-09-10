---
name: ett-namn-som-inte-skiljer-ar-ett-halvt-namn
description: "En kontroll kan ha ett namn och ändå vara omöjlig att peka ut - kravet är unikt på sidan, inte icke-tomt"
metadata: 
  node_type: memory
  scope: global
  type: feedback
  originSessionId: session-2026-09-10-foretagsuppgifter
  modified: 2026-09-10T17:53:20.389Z
---

Ett svep som kräver att varje kontroll **har** ett namn godkänner en sida där tre knappar heter
likadant. Kravet som faktiskt bär är att namnet **skiljer kontrollen från de andra på sidan** –
och den skillnaden märks först när någon, eller något, försöker peka ut en av dem.

**Why:** Mätt i browsern 2026-09-10: `/installningar` bar tre knappar med det accessibla namnet
`Spara` samtidigt, i tre olika kort. Sidans automatiska namnsvep var grönt, för alla tre hade ju
namn. Det som avslöjade det var att jag själv fick sikta med sektionen för att kunna klicka rätt –
alltså samma signal en skärmläsaranvändare får, fast som en olägenhet i stället för som ett fel.
Samma kodbas hade dessutom redan regeln nedskriven för tabellceller (*"Pris för Zenlerkurs, inte
Pris"*) utan att någon dragit den till knappar.

**How to apply:** När jag lägger en kontroll på en sida som redan har en likadan: låt namnet bära
**vad** den gör och inte bara verbet, med den synliga texten kvar som prefix så Label-in-Name
håller. Och när ett verktyg tvingar mig att disambiguera en selektor – `.filter()`, `:has-text`,
"den andra knappen" – läs det som ett fynd om gränssnittet och inte som en egenhet i verktyget.
Ett svep som kräver unika namn är däremot ett omdöme: två *Ta bort* på samma sida kan vara rätt
när raden bär skillnaden.

Släkt med [[ett-fel-sitter-sallan-ensamt]] – greppa fram de andra likalydande innan jag bockar av
den jag hittade – och med [[gront-test-bevisar-inget-i-sig]], eftersom det gröna svepet här mätte
en svagare sak än den det påstod sig mäta.
