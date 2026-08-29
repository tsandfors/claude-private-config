---
name: databasen-ar-slangbar
description: "Byrå-CRM:et släpps aldrig till någon annan, så databasen får ändras fritt - migrationssvårighet är inget giltigt argument mot en design"
metadata: 
  type: project
  originSessionId: f5b2f404-f0b4-4bda-8d3a-b9bc488135ba
  modified: 2026-08-27T22:50:25.802Z
  scope: att-gora
---

Tomas sa 2026-08-25, mitt i kundsektionen: *"Inget har releasats, och repot har script som
seedar databasen med testdata, så du kan ändra i databasen hur du vill fram till att vi har en
färdig produkt."* Det gäller `~/ts_projects/att-gora`.

**Villkoret föll bort 2026-08-28 och regeln blev ovillkorlig.** Meningen löd förut *"tills appen
faktiskt säljs"* och pekade på sektionen *Vägen till en säljbar produkt* som villkoren för att
dörren skulle öppnas. Den dörren finns inte längre: syftet är att lära, appen är övningsstycket,
och ingen utomstående får någonsin data i den här databasen. Det som var en frist är nu ett
permanent tillstånd.

**Varför:** Jag hade avfärdat ett designalternativ med att en `NOT NULL`-migration *"mot ett
register i bruk inte är möjlig"*, och det var fel på två sätt. Det finns inget register i bruk,
och `seed_demo` återskapar allt på en sekund. Han rättade premissen, inte slutsatsen — och det
är den sortens invändning han faktiskt ställer när jag bygger ett argument på något jag inte
har kontrollerat. Jämför [[utmana-oklarheter]]: lovet går åt bägge håll.

Nyansen är värd lika mycket som regeln. Slutsatsen råkade vara riktig, men av ett helt annat
skäl: kravet gick inte att lägga i databasen därför att det är **villkorat av en inställning
som går att byta när som helst** (`TeamSettings.customer_title`), inte därför att migrationen
var svår. Ett team i personläge har legitima kunder utan företag. Att jag landat rätt av fel
anledning gjorde inte argumentet mindre osant.

**How to apply:** Använd aldrig "migrationen skulle vara jobbig", "det finns data i vägen"
eller "det vore bakåtinkompatibelt" som skäl i det här projektet — det finns ingen data att
vara bakåtkompatibel med. Föreslå den rena modellen och skriv migrationen. När jag ändå tycker
att en constraint inte hör hemma i databasen, kontrollera att skälet är strukturellt (det beror
på en inställning, på ett team, på ett läge) och skriv ut just det skälet. Se även
[[verifiering-hor-till-leveransen]]: kontrollera påståendet innan det blir ett argument.
