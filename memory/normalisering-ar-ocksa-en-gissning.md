---
name: normalisering-ar-ocksa-en-gissning
description: Kod jag skriver för att slippa gissa är ofta själv en gissning - en normalisering tar bort ett fall jag inte räknade upp
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 3b69eaa3-0aa5-4f3d-8c92-304c62b71dc8
  modified: 2026-09-09T15:17:00.776Z
---

När jag skriver en rad som ska **ta bort en tvetydighet** — normalisera, fylla i ett saknat
fält, klistra på ett format, tvinga fram en gemensam form — är frågan att ställa: *vilka fall
finns det, och gäller det här för alla?* En normalisering som är riktig för de fall jag råkade
tänka på är en gissning i förklädnad, och den är farligare än att inte ha skrivit den alls,
eftersom den ser ut som lösningen på problemet.

**Varför:** i `att-gora`s iCal-parser vägrade `dateutil` jämföra en naiv `UNTIL` mot en aware
`DTSTART`, så jag klistrade på ett `Z` på varje `UNTIL` som saknade det. Det löste tvetydigheten
för det fall jag hade framför mig. Men ett `UNTIL` utan klockslag är fullt giltigt när `DTSTART`
är en `DATE`, och `20160805` + `Z` är då varken datum eller tidpunkt — raden kastade, och tog
ner hela kalenderlagret för en kalender som var alldeles hel. **Det jag skrev för att slippa
gissa var i sig en gissning.** Rätt svar var att räkna fram gränsen i samma frame som `DTSTART`
faktiskt lästes i, alltså att låta datan svara i stället för att påtvinga den ett format.

Två saker gjorde att det överlevde: felet fanns inte i data jag skrivit själv (min testfeed bar
fem sorters poster, den riktiga kalendern bar ett decennium), och normaliseringen såg ut som
omsorg. En rad som *lägger till* något är svårare att misstänka än en rad som saknas.

**How to apply:** När jag skriver en normalisering, räkna upp fallen högt och skriv ner vilka
den gäller för — går den inte att räkna upp är det ett tecken i sig. Fråga särskilt om det finns
en giltig variant där fältet betyder något *annat* och inte bara saknar en del. Och pröva den
mot data jag inte skrivit själv innan jag kallar den klar. Släktskap:
[[gront-test-bevisar-inget-i-sig]] om varför min egen fixtur inte räcker,
[[en-kompensation-kan-dolja-ett-fel]] om rader som rättar och döljer samtidigt, och
[[utmana-oklarheter]] om att säga att jag inte vet i stället för att fylla i.
