---
name: tomma-ar-inte-att-hamta-om
description: "Att kasta bort tillstånd är inte att skaffa nytt - fråga vad som får skärmen att fråga igen, annars står gammalt kvar utan något som förklarar det"
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 8309c397-54f3-49b6-a685-1a0a01352b78
  modified: 2026-09-11T14:42:07.161Z
---

En primitiv som **tömmer** tillstånd och en som **hämtar om** det är två olika saker, och den
första lämnar skärmen stående på det gamla tills något annat råkar be om nytt. Fråga alltid: vad
i den här koden får det som redan är ritat att fråga igen?

**Varför:** i `att-gora` avslutade jag ett impersoneringsbesök med `queryClient.clear()`. Cachen
tömdes, och sedan hände ingenting: inget nätverksanrop alls förrän någon laddade om. Menyn stod
kvar avsmalnad till den roll man just lämnat, med banderollen som förklarade varför borta – alltså
exakt det tillstånd hela funktionen fanns för att omöjliggöra. `clear()` fungerar vid inloggning
bara för att hela trädet monteras om där; ingenting monterades om här. `resetQueries()` är
primitiven som gör bägge sakerna.

**How to apply:** när jag byter *vems* data en app visar – utloggning, kontobyte, impersonering,
byte av organisation – räcker det inte att slänga cachen. Leta upp den primitiv som också
refetchar aktiva observatörer, eller montera om det som visar datan. Och pröva det i en browser:
ett jsdom-test som bara läser cachen är grönt medan skärmen ljuger, vilket var precis vad som
hände här. Samma familj som [[franvaro-behover-ett-positivt-kvitto]] – frågan är vad som
*bevisar* att det nya tillståndet nått fram.
