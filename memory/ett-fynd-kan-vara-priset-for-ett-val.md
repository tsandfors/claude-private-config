---
name: ett-fynd-kan-vara-priset-for-ett-val
description: "Innan ett fynd lagas: fråga om det är priset för ett val användaren redan gjort, och vad lagningen tar ifrån det valet"
metadata:
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 25b84dcc-ae4d-4dfc-9ac9-e32466136464
  modified: 2026-10-06T09:22:29.120Z
---

Ett fynd i en granskning kan vara den avsedda följden av ett beslut som redan är fattat, och
då är lagningen ett omval som ingen bett om. Fråga först: *vilket val ligger bakom det jag ser,
och vad tar min lagning ifrån det?*

**Why:** 2026-10-06 i att-gora. Tomas hade valt att fästa åtgärdskolumnen så att tabellen skulle
kunna skrollas i sidled på en mindre skärm. En genomgång fann att ett värde låg under kolumnen
vid 1440 px, och jag lagade det med radbrytning – som tog bort just sidledsskrollningen mellan
1280 och 1440 px. Tomas fick påpeka att det var hela poängen med kolumnen. Att innehåll ligger
under en fäst kolumn tills man skrollar är vad sidledsskrollning *är*; det verkliga felet var
smalare (15 px som klippte ett värde mitt i), och den minsta lagningen räckte.

**How to apply:** När ett fynd följer av en nyss gjord ändring, säg vilket val det hänger på
och presentera alternativen *mot det valet*, inte bara mot fyndet. Föredra den minsta lagningen
som tar bort felet utan att röra valet. Släkt med [[en-spec-ar-inte-sann-for-att-den-ar-skriven]]
och [[en-rekommendation-maste-bara-ett-argument]].
