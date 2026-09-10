---
name: ett-varde-i-en-url-har-en-teckenmangd
description: Ett värde som ska färdas i en query-sträng måste väljas efter vilka tecken som överlever resan - och felet är oftast tyst
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: eebfd55a-a4af-42c2-90d2-32b28acc655a
  modified: 2026-09-10T20:39:09.293Z
---

När jag hittar på ett värde som ska skickas som query-parameter — en markör, ett id, en
tidsstämpel — är teckenmängden en del av designen och inte en detalj för mottagaren. `+` blir
mellanslag i en query-sträng, och `&`, `#`, `%` och `/` har sina egna problem. Fråga också om
klienten faktiskt kodar: en handskriven `?a=${v}` gör det inte.

**Varför:** 2026-09-10 gav jag en paginerad logg en keyset-markör i ISO-format,
`2026-09-10T21:03:12.345678+00:00,123`. Appens egen query-byggare kodade ingenting, så `+` kom
fram som mellanslag, tidsstämpeln gick inte att parsa — **och den grenen svarade första sidan**.
Alltså inget fel, ingen loggrad, ingen röd konsol: bara en *Visa fler*-knapp som visade samma
hundra rader i all evighet. Med `Z` i stället för `+00:00` var det borta. Testet hittade det
bara för att det skickade markören vidare rått, vilket är precis vad adressfältet gör.

Det andra halva av läxan är fallbacken: *en oläsbar markör ger första sidan* är rätt beteende
för en handredigerad adress, och det var samma rad som gjorde felet osynligt. En tolerant
tolkning döljer den som skickade fel — se [[en-kompensation-kan-dolja-ett-fel]].

**How to apply:** välj URL-säkra tecken från början (siffror, bokstäver, `-`, `_`, `.`, `~`)
eller koda uttryckligen. Och skriv minst ett test som skickar värdet **rått genom adressen**,
inte bara genom en klient som råkar koda åt dig — annars mäter provet klienten och inte
protokollet.
