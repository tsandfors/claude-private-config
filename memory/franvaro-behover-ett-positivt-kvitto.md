---
name: franvaro-behover-ett-positivt-kvitto
description: Ett test som påstår att något INTE finns måste hänga påståendet på ett positivt kvitto - frånvaro anländer inte vid något tillfälle
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 1fc6a9b9-a91c-4276-987e-6beb90bcc242
  modified: 2026-09-09T23:19:04.688Z
---

Ett test som påstår att något **inte** ritas, inte anropas eller inte händer måste vänta in ett
**positivt** kvitto på att tidpunkten passerats – ett svar som landat, ett värde i en cache, ett
element som säkert ritas i bägge fallen. Att vänta på att en *förfrågan skickades* räcker inte:
den är sann långt innan svaret har behandlats.

**Varför:** i `att-gora` skrev jag tre tester på att rollsektionen inte finns i ett enmansteam,
med `waitFor(() => stub.to("GET", "/api/auth/me/").length === 1)` som väntan. Alla tre var
gröna – och förblev gröna när jag muterade bort villkoret som döljer sektionen. Assertionen
kördes mellan att anropet gick iväg och att React hann rita svaret, så den mätte ingenting alls.
Med `waitFor(() => client.getQueryData(["me"]))` blev två av dem röda direkt.

**How to apply:** när jag skriver ett `queryBy...).toBeNull()` eller `toEqual([])`, fråga *vad
gör att den här raden körs efter att saken skulle ha hänt?* Finns inget sådant ankare, skaffa ett
– cachen, ett grannelement, ett anrop som bara sker i det andra fallet. Och pröva alltid ett
negativt test med en mutation: det är den sortens test som är grön av fel skäl. Motsatt sida av
[[en-vantan-flyttar-matpunkten]], och ett specialfall av [[gront-test-bevisar-inget-i-sig]].
