---
name: en-vakt-matchar-sin-egen-definition
description: "Ett svep som förbjuder en lista av literaler flaggar filen som bär listan – undanta den med skäl, inte tyst, annars tystas något som borde larma"
metadata:
  node_type: memory
  scope: global
  type: feedback
  originSessionId: b9224132-60ef-4cda-8b3d-ba0788044efa
  modified: 2026-10-01T03:27:19.893Z
---

Skriver jag ett svep som letar efter förbjudna strängar i en kodbas, så innehåller själva
svepet varje förbjuden sträng. Den är röd från första körningen, och den självträffen är inte
ett fel i koden utan i mätningen.

**Why:** Jag skrev ett test som förbjöd elva hårdkodade hexvärden ur en gammal palett i hela
frontendträdet. Det föll direkt med elva träffar, och alla elva var i testfilen själv – dess
egen förbudslista. Frestelsen i det läget är att smalna av svepet tills det blir grönt, och då
är det lätt att råka tysta mer än sig självt: en bredare regex, en utesluten katalog, en
`.filter()` som också släpper igenom riktiga träffar.

**How to apply:** Undanta den egna filen **vid namn** och skriv ut skälet bredvid, så att
undantaget inte läses som att den sortens fil generellt är ointressant. Lista undantagen
explicit i stället för att smalna av mönstret. Och håll isär undantagens *slag* när de är
flera – i mitt fall var det ena en legitim användning av en förbjuden färg och det andra en
självträff, vilket är två helt olika skäl som skulle läsas fel av en gemensam kommentar.

Samma familj som [[franvaro-behover-ett-positivt-kvitto]]: ett svep behöver både något som får
det att larma och något som bevisar att tystnaden är äkta.
