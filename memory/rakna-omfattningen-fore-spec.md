---
name: rakna-omfattningen-fore-spec
description: Ett önskemål är en gissning om omfattning - räkna hur många ställen det faktiskt gäller innan jag skriver ner det, för siffran ändrar ofta vad önskemålet betyder
metadata:
  node_type: memory
  type: feedback
  scope: global
  originSessionId: curious-wondering-walrus
  modified: 2026-08-29T22:57:14.122Z
---

När Tomas beskriver något han vill ha, beskriver han **upplevelsen på det ställe där han råkade
märka den**. Formuleringen låter generell – "när man lägger till något", "överallt", "alla
sidor" – men det är en gissning om omfattning och inte en mätning. Att räkna instanserna innan
jag skriver ner önskemålet är billigt, och siffran ändrar regelbundet **vad önskemålet betyder**,
inte bara hur stort det är.

**Varför:** 2026-08-29 bad han om att *"när man lägger till något ska man hamna på det kortet så
att man kan fortsätta lägga till fler data"*. Skrivet rakt av hade det blivit en punkt om att
navigera efter varje skapelse. Mätningen sa något annat: sju sidor har ett tilläggsformulär, och
på **sex** av dem redigeras varje fält inline i den rad man just skapade – raden *är* kortet, och
att kastas ur den vore sämre än i dag. Bara två lämnade en stubbe, och de behövde dessutom var
sin mekanik: kunden hade en rutt att gå till, kampanjen bara ett kort på samma sida.

Det som gör exemplet värt att spara är vad som hände **efter** räkningen. När Tomas fick se att
kampanjen var den udda av de två valde han ett helt annat och mycket större svar än det han bad
om – att kampanjen skulle få kundens hela arrangemang med egen sida, två vyer och en bild. Det
valet fanns inte att göra innan någon räknat. **Mätningen var inte en precisering av hans
önskemål, den var förutsättningen för att han skulle kunna fatta ett bättre beslut.**

**How to apply:** Innan jag skriver ner ett önskemål som en punkt eller en spec: greppa fram
alla ställen det påstås gälla och räkna dem. Kolla särskilt om de liknar varandra – gör de inte
det är "samma sak överallt" fel form på svaret. Redovisa siffran för Tomas innan jag skriver, och
inte efteråt som en fotnot; det är där han kan använda den. Och skriv aldrig ett tal i texten som
jag inte läst ur koden samma dag – två av mina egna påståenden i samma svep var fel och fångades
bara av att jag gick tillbaka till källan innan jag committade.

Skiljer sig från [[ett-fel-sitter-sallan-ensamt]], som handlar om ett **fel** som sitter på fler
ställen än där jag såg det. Det här är motsatt riktning: ett **önskemål** som gäller på färre
ställen än det låter, och där färre betyder något annat. Se även [[utmana-oklarheter]] och
[[verifiering-hor-till-leveransen]].
