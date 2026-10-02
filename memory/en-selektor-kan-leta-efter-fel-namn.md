---
name: en-selektor-kan-leta-efter-fel-namn
description: "En CSS-attributselektor gemenfäller attributnamnet, så camelCase-attribut på SVG och andra främmande element matchar aldrig – och ett test som påstår frånvaro blir grönt av fel skäl"
metadata:
  node_type: memory
  scope: global
  type: feedback
  originSessionId: 07ffd438-c4fc-4528-beec-ae4f20e067ea
  modified: 2026-10-02T12:17:33.168Z
---

En CSS-attributselektor matchar attributnamnet **ASCII-skiftlägesokänsligt bara för
HTML-element**. På element i en annan namnrymd – SVG, MathML – är jämförelsen
skiftlägeskänslig, så `svg[viewBox="0 0 40 40"]` letar efter `viewbox` och hittar aldrig
något. Läs med `getAttribute("viewBox")` i stället.

**Why:** Mätt 2026-10-02 i jsdom. Det farliga är inte att selektorn är fel utan **åt vilket
håll** den felar: den returnerar alltid null, så varje `expect(x()).toBeNull()` passerar utan
att mäta något. Jag hade tre sådana påståenden gröna och trodde att de höll. Felet syntes
först när jag lade till det positiva kvittot, och först *då* för att jag råkade köra
mutationen innan jag sett assertionen grön en enda gång.

**How to apply:** Använd aldrig en attributselektor för ett camelCase-attribut – `viewBox`,
`preserveAspectRatio`, `gradientUnits`, `clipPathUnits`. Och oavsett selektor: en hjälpare som
bara används till att påstå frånvaro ska ha **minst ett** test som påstår närvaro, annars
mäter ingen av dem något. Kör dessutom assertionen grön innan mutationen, inte efter – jag
gjorde tvärtom och tolkade ett genuint rött test som ett lyckat mutationsprov.

Samma sort som [[franvaro-behover-ett-positivt-kvitto]] och
[[en-gron-mutation-ar-inte-ett-besked]]; hör också ihop med
[[gront-test-bevisar-inget-i-sig]].
