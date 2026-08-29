---
name: gront-test-bevisar-inget-i-sig
description: Ett grönt test är ett påstående först när jag vet vad som hade gjort det rött - tre sätt jag lurades av gröna tester på en dag
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 1044405c-bf6b-4e47-bbd7-cd4dd38b38cc
  modified: 2026-08-29T03:16:13.608Z
---

Ett test som passerar säger ingenting förrän jag vet **vad som hade fällt det**. Att köra
mutationsprovet är därför inte en extra omsorg utan det som gör resultatet till ett påstående.

**Varför:** 2026-08-29 lurades jag av gröna tester tre gånger på en dag, och de var tre olika
sorters lucka.

- **Ett prov med ett exemplar kan inte mäta en regel om flera.** Kortet skulle skicka *hela*
  listan kalendrar vid en färgändring, men testet hade en enda kopplad — och då ser "skicka
  allt" och "skicka bara raden jag rörde" exakt likadana ut. Samma fel en gång till samma dag,
  i ett parallellprov som bara påstod att svaret var en 200: seriellt brister barriären, bägge
  hämtningarna misslyckas, och svaret är en 200 ändå.
- **Ett kast som någon annan sväljer.** Testriggen kastar på ett ostubbat anrop, men React
  Query fångar kastet och gör det till ett tyst frågefel. En vy som frågade efter en endpoint
  den inte borde ha frågat efter gav alltså grön svit. Felet syntes bara för att jag undrade
  varför **ingenting** föll när jag lagt till ett nytt anrop.
- **En grön svit efter en ändring som borde ha rört den är en fråga, inte ett besked.** Det var
  den frågan som hittade felet ovan.

**How to apply:** När ett nytt test blir grönt på första försöket: återinför felet det ska
fånga och kontrollera att det faller, och att det faller på rätt sak. När en ändring inte
fäller något test som rimligen borde ha berörts: leta reda på varför innan jag går vidare.
Och när ett test handlar om *flera* — alla rader, hela listan, varje vy — låt fixturen ha minst
två, annars mäter provet singularis. Se även [[verifiering-hor-till-leveransen]] och
[[tystnad-ar-tvetydig]], som är samma tanke om larm i stället för om tester.
