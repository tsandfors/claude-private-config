---
name: backa-ett-prov-med-en-kopia
description: "Backa en mutation eller ett prov med en filkopia, aldrig med git checkout - versionshanteringen backar till senaste commit och inte till före provet"
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 638791d0-1e54-4b7f-9678-af3fd30a2f97
  modified: 2026-09-09T20:00:08.433Z
---

När jag muterar en fil för att se att ett test blir rött, och sedan ska backa mutationen: kopiera
filen till `/tmp` först och kopiera tillbaka därifrån. **`git checkout <fil>` backar inte
mutationen — den backar till senaste commit**, och allt ocommittat i filen försvinner med den.

**Varför:** i `att-gora` 2026-09-09 mutationsprövades en nyskriven datamodell som ännu inte var
committad. `git checkout app/services.py` efter första mutationen slängde hela dagens arbete i
två filer, inte bara mutationen. Det värsta var inte förlusten utan att den var **tyst**: nästa
mutation gav 6 röda i stället för 2, och jag höll på att skriva ner den siffran som ett resultat
innan jag såg att fyra av dem var den första mutationen som satt kvar. Ett prov vars
återställning är trasig ger fel svar utan att säga ifrån. Samma dag: en otrackad fil räddades
just av att `git checkout` misslyckades på den.

**How to apply:** Före en serie mutationer, `cp` de berörda filerna till en scratchkatalog och
skriv en `restore()`-funktion som kopierar tillbaka därifrån. Kör `git status --short` mellan
varje mutation — den visar om något ramlat bort. Har filerna redan en commit att stå på är
`git stash`/`git checkout` säkert, men vanan att kopiera kostar ingenting och gäller i bägge
lägena. Släktskap: [[prov-far-inte-orsaka-skadan]] om målet för ett prov,
[[gront-test-bevisar-inget-i-sig]] om varför mutationen körs alls, och
[[ett-fel-sitter-sallan-ensamt]] om att kontrollera de andra filerna i samma svep.
