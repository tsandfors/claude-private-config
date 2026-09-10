---
name: ett-steg-kan-lamna-ett-trasigt-mellanlage
description: En delleverans kan lämna appen sämre än både före och efter; namnge fönstret och låt det styra ordningen på resten
metadata: 
  node_type: memory
  scope: global
  type: feedback
  originSessionId: 4f73afa8-8564-4107-b9c1-862b83ecbf9c
  modified: 2026-09-09T21:26:23.755Z
---

Ett steg i en flerstegsplan kan lämna ett läge som är sämre än både utgångsläget och
slutläget — inte ofullständigt, utan trasigt. Backenden som börjar utelämna fält ur ett svar
innan frontenden lärt sig läsa det saknade fältet är den typiska formen.

**Why:** Ett ofullständigt steg märks av den som letar efter funktionen; ett trasigt
mellanläge märks av den som råkar gå in i det, och ingenting påminner om att det finns. Att
det bara går att nå genom en väg få använder (Djangos admin, en flagga, en roll som ingen har
ännu) gör det acceptabelt — men bara om skälet är nedskrivet och ordningen på resten följer av
det.

**How to apply:** Fråga efter varje steg som ändrar en gräns: *vad går sönder för den som
hamnar mitt emellan?* Är svaret något annat än "inget", skriv fönstret i den fil nästa session
läser först — inte i commit-meddelandet, som ingen läser igen — och låt det avgöra vilket steg
som är näst på tur. Säg det också högt i samtalet vid leverans; det är ett förbehåll, inte en
detalj. Se [[verifiering-hor-till-leveransen]] och [[korrigera-inte-bara-komplettera]].
