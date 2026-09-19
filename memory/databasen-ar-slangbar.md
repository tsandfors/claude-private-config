---
name: databasen-ar-slangbar
description: "Byrå-CRM:et släpps aldrig till någon annan, så databasen får ändras fritt - migrationssvårighet är inget giltigt argument mot en design"
metadata: 
  type: project
  originSessionId: f5b2f404-f0b4-4bda-8d3a-b9bc488135ba
  modified: 2026-09-12T03:03:01.144Z
  scope: att-gora
---

Tomas sa 2026-08-25, mitt i kundsektionen: *"Inget har releasats, och repot har script som
seedar databasen med testdata, så du kan ändra i databasen hur du vill fram till att vi har en
färdig produkt."* Det gäller `~/ts_projects/att-gora`.

**Villkoret föll bort 2026-08-28 och regeln blev ovillkorlig.** Meningen löd förut *"tills appen
faktiskt säljs"* och pekade på sektionen *Vägen till en säljbar produkt* som villkoren för att
dörren skulle öppnas. Den dörren finns inte längre: syftet är att lära, appen är övningsstycket.
Det som var en frist är nu ett permanent tillstånd.

**Sedan 2026-09-12 finns en databas till, och den ändrar ingenting.** Demostacken
(`attgora_demo_db-data`) körs på en maskin där intressenter matar in riktig data för att kunna
ge feedback, så meningen *"ingen utomstående får någonsin data i den här databasen"* stod inte
längre. Jag drog av det slutsatsen att datan var dyrbar och skrev skyddsregler i den tonen —
*"data ingen kan återskapa"*, en osymmetrisk skada, en punkt som borde tas *näst*. **Tomas
rättade samma dag:** *"demo är inte produktion, om demo förloras så är det inte hela världen …
vi kan fortfarande behöva bygga om databasstrukturen, eller göra stora ändringar som gör att
intressentens data blir obrukbart."* Slängbarheten gäller alltså bägge databaserna.

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
vara bakåtkompatibel med, och det gäller demomaskinen också. Och innan jag skriver en regel
*om* ett datalager: fråga vad datan är värd i stället för att sluta mig till det av vem som
matade in den. Att någon annan skrev in något gör det inte oersättligt. Föreslå den rena modellen och skriv migrationen. När jag ändå tycker
att en constraint inte hör hemma i databasen, kontrollera att skälet är strukturellt (det beror
på en inställning, på ett team, på ett läge) och skriv ut just det skälet. Se även
[[verifiering-hor-till-leveransen]]: kontrollera påståendet innan det blir ett argument.
