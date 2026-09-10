---
name: tva-kallor-ger-tillstand-per-kombination
description: "En vy som väver ihop två läsningar har ett tillstånd per kombination, inte per källa - pröva den ena trasig och den andra hel"
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 1fc6a9b9-a91c-4276-987e-6beb90bcc242
  modified: 2026-09-09T23:19:19.168Z
---

När en vy bygger en kontroll av **två** läsningar räcker det inte att pröva "allt lyckas" och
"allt fallerar". Tillstånden är kombinationerna, och den intressanta är den där den ena källan
svarar och den andra inte – då finns det data nog att rita något tvärsäkert, och det som ritas
kan vara fel.

**Varför:** rollrutnätet i `att-gora` bygger en väljare per medlem av två anrop: medlemmarna och
rollerna. Blockerade jag bara rollistan föll väljaren tillbaka på sin första post – *Ingen roll,
når allt* – för en kollega som faktiskt hade en roll. Ingen testfil hade fångat det, för de
prövade en källa i taget, och felet syntes bara i browsern. Medlemsraden bar hela tiden
`role_name`, alltså svaret, från den källa som hade svarat.

**How to apply:** räkna kombinationerna innan jag skriver testerna, och fråga för varje: *kan
den här kontrollen ritas rätt med bara den data som finns?* Kan den inte det ska den visa vad
den vet i stället för att gissa, eller inte vara en kontroll alls. Serversvar som duplicerar ett
namn (`role_name`, `customer_title`) finns ofta just för det här och är lätta att missa.
Besläktat med [[ett-fel-sitter-sallan-ensamt]] och [[tystnad-ar-tvetydig]].
