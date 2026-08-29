---
name: backup-svarar-inte-pa-vad-som-blev-kvar
description: En backup gör en städning ångerbar men säger aldrig om något blev kvar; efter en filtrering ska jag mäta den kvarvarande filen, inte den borttagna
metadata:
  type: feedback
  originSessionId: cc180170-0edd-405f-8317-e200404cdef7
  modified: 2026-08-28T01:55:44.384Z
  scope: global
---

Att en städning är **ångerbar** och att den är **fullständig** är två olika egenskaper, och en
backup ger bara den första. 2026-08-28 filtrerades 95 rader privat historik ur en delad fil och
originalet sparades som `.bak`. Backupen svarade på *togs fel rader bort?* – svaret var nej,
allt rätt. Ingen ställde frågan *ligger något kvar?*, och 49 rader gjorde det, för filtret
matchade en exakt sökväg medan hälften av materialet låg i katalogen ovanför.

**Varför:** en backup känns som verifiering. Den finns, den är fullständig, och den tar bort
oron – men den är ett facit över *det jag rörde*, aldrig över *det jag inte såg*. Felet den inte
kan upptäcka är dessutom det dyrare av de två: en felaktigt borttagen rad går att lägga
tillbaka, en kvarlämnad rad ligger kvar tills någon råkar titta. Här hade den lämnade raden en
privat mejladress i klartext i arbetsgivarens katalog.

**How to apply:** Efter varje filtrering, städning eller migrering – mät den **kvarvarande**
sidan, inte den borttagna. Räkna kategorierna som finns kvar (projekt, id, ägare, prefix) och
jämför mot en oberoende lista över vad som borde vara borta; sök på innehåll och inte bara på
det kriterium filtret redan använde, eftersom ett svep med samma kriterium bekräftar sig självt.
Fråga inte "kan jag ångra det här?" utan **"hur skulle jag se det jag missade?"** – har den
frågan inget mekaniskt svar är städningen inte verifierad, hur bra backupen än är.

Ett kriterium byggt på en exakt sökväg är särskilt värt att misstro: verktyg som arbetar i
katalogträd träffar också nivån ovanför. Se [[verifiering-hor-till-leveransen]] och
[[korrigera-inte-bara-komplettera]].
