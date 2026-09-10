---
name: ett-villkor-kan-lasa-tillstandet-inifran
description: "Innan jag döljer något i tillstånd X - fråga om det jag döljer är vägen ut ur X, annars blir X permanent"
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: fa968a72-fb90-4dc2-b218-57044dfdb020
  modified: 2026-09-10T08:58:04.330Z
---

Ett villkor som döljer en funktion i ett visst tillstånd kan göra det tillståndet permanent,
om det som döljs var enda vägen därifrån. Formen är alltid densamma: villkoret ser rimligt ut
för varje enskilt fall och är ändå en dörr låst inifrån.

**Why:** Regeln *en funktion ska vara borta när den inte gäller* är riktig, och just därför
farlig — den lockar till att kopiera ett villkor som fungerade på granngrejen. 2026-09-10 var
mönstret nästan byggt två gånger på samma sida: rollrutnätet är osynligt tills teamet har en
andra medlem (rätt — en roll behöver någon att sitta på), och medlemssektionen bredvid stod
under exakt samma frestelse. Men den bär inbjudningslänken, alltså **enda sättet ett team av
en någonsin blir ett team av två**. Samma villkor hade gjort varje enmanskonto till ett
enmanskonto för alltid, och felet hade inte gått att upptäcka genom att titta på sidan: den
ser komplett ut i bägge lägena.

Det svarar också på varför frågan inte är *ser funktionen onödig ut här?* utan *gäller den
här?*. Medlemssektionen i ett enmansteam ser onödig ut — en lista med en rad, som är jag — och
är det inte.

**How to apply:** När jag är på väg att dölja, spärra eller villkora något på ett tillstånd,
ställ en fråga till: **är det jag döljer en av övergångarna ut ur tillståndet?** Räkna
övergångarna, gissa dem inte — om det bara finns en och den ligger bakom villkoret är villkoret
fel. Kopiera aldrig ett villkor från en grannfunktion utan att ställa frågan om den nya, även
när de sitter på samma sida och ser ut att höra ihop. Se
[[ett-steg-kan-lamna-ett-trasigt-mellanlage]], som är samma sorts osynlighet i tiden i stället
för i tillståndet, och [[en-vakt-pa-namnet-tacker-inte-saken]].
