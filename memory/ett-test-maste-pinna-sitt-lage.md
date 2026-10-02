---
name: ett-test-maste-pinna-sitt-lage
description: "Ett test som mäter en konfigurerbar gren måste pinna läget, annars mäter det konfigurationen"
metadata:
  node_type: memory
  scope: global
  type: feedback
  originSessionId: 62375bfa-13ef-432b-849e-81984e0ddd69
  modified: 2026-10-02T23:16:45.515Z
---

Finns det en flagga, en karta eller en inställning som avgör vilken gren koden tar, måste varje
test sätta det läge det handlar om — explicit, i testet. Läser testet defaultvärdet mäter det
konfigurationen och inte grenen, och det märks inte förrän någon vrider på flaggan: då blir
halva sviten röd och den andra halvan slutar köras.

**Why:** Jag byggde två redigeringslägen bakom en karta i *att-gora* och skrev tester för
bägge, men inline-testerna renderade sidan utan att pinna läget. De var gröna — på default. När
Tomas bad mig vrida kartan till det andra läget hade de mätt fel gren. Felet var osynligt
precis så länge kartan stod kvar där den råkade stå, alltså precis så länge konfigurationen
inte användes till det den finns för.

**How to apply:** När jag bygger något konfigurerbart: pinna läget i *varje* test, också det
som råkar sammanfalla med defaulten, och skriv i testet varför. Pröva sedan genom att vrida
kartan och köra hela sviten — grön i bägge riktningarna är beviset, en grön körning är det
inte. Och lägg defaultvärdet så att det går att överskugga vid rendering i stället för att
läsas vid import, annars läcker läget ett test valde till nästa.

Besläktat: [[gront-test-bevisar-inget-i-sig]], [[en-gron-mutation-ar-inte-ett-besked]],
[[franvaro-behover-ett-positivt-kvitto]].
