---
name: en-tom-lista-speglar-vagen-dit
description: "En kort eller tom lista från en upptäcktsmekanism är ett svar om vägen dit - endpoint, region, behörighet - och inte om vad som finns i andra änden"
metadata:
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 9c9f8753-ee10-4d7e-832f-250c5833a616
  modified: 2026-10-02T23:42:34.225Z
---

2026-10-03 saknades `claude-opus-5-5[1m]` i `/model`. Jag läste den tomma väljaren som ett
besked om **innehållet** – att modellen inte var påslagen i GCP-projektet – och skrev att nästa
steg var en fråga till den som äger projektet. Tomas sa *"jag tror vi måste ändra region till
eu"*, och han hade rätt: jobbets konfiguration körde `CLOUD_ML_REGION=eu` och
`model=claude-opus-5-5[1m]` mot **samma** projekt. Modellen hade varit tillgänglig hela tiden.
`global`-endpointen serverade den bara inte, och Claude Codes uppstartssond hade seedat
defaulten med det enda den fann där.

Jag hade till och med belägg som pekade rätt och läste det fel: dokumentationen visade
`claude-opus-5-5` i ett exempel mot `locations/global`, vilket jag tog som bevis för att
regionen var oskyldig. Att en modell *kan* serveras på en endpoint säger ingenting om att den
gör det för ett givet projekt.

**Varför:** En lista som genereras av en sond har två ingångsvärden – vad som finns, och vilken
väg sonden gick. Frånvaro i utdatan skiljer inte på dem. Att gissa på "finns inte" är dyrare än
att gissa på "nåddes inte", för det första svaret skickar iväg någon att begära åtkomst som
redan finns, medan det andra bara kostar ett omtest. Samma sort som
[[en-matning-kan-vara-inaktuell-eller-stympad]], ett steg tidigare i kedjan: där var utdatan
beskuren, här är den komplett för den väg som faktiskt togs. Jämför [[tystnad-ar-tvetydig]].

**How to apply:** När en lista, en väljare eller en autocompletion saknar något du väntade dig,
fråga först **vilken väg som räknade upp den** – endpoint, region, projekt, behörighet, token,
cache – innan du drar en slutsats om innehållet. Leta efter en **andra konfiguration som redan
fungerar** och jämför parametrarna rad för rad; det är det billigaste provet som finns och det
var det som avgjorde här. Och säg "nåddes inte" hellre än "finns inte" tills en mätning skiljer
dem åt. Se även [[en-rekommendation-maste-bara-ett-argument]] – jag gav en rekommendation med
ett argument som inte var prövat.
