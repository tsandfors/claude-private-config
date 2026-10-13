---
name: beskriv-resultatet-i-klick
description: "Innan jag bygger efter en spec, beskriv vad användaren ser och klickar på – inte spec-ordet – för ett substantiv kan betyda olika saker för oss"
metadata:
  node_type: memory
  scope: global
  type: feedback
  originSessionId: 886de4f0-f908-46ff-bccd-8139858b53f3
  modified: 2026-10-13T11:52:04.851Z
---

Innan jag bygger något användaren valt utifrån min förklaring ska förklaringen säga **var
knappen sitter och vart ett klick leder**, inte bara upprepa specens substantiv. Ett ord som
betyder en sak i koden kan betyda en annan för användaren.

**Why:** 2026-10-13 i att-gora byggde jag punkt 21:s *Kundkortet* färdigt – penna per kort,
modal, tester, dokumentation – efter att Tomas godkänt det. För mig och backloggen var
*kundkortet* detaljsidan `/kunder/:id`; för honom var det kortet i galleriet. Hans "modal som
default för kundkortet" menade raden i listan. Det märktes först när han tittade i appen:
listan hade ingen penna, och man klickade in på en kund för att klicka igen. Hela bygget
kastades. Min pedagogiska förklaring hade nämnt "en penna per kort" men aldrig sagt att listan
förblir utan penna – konsekvensen han hade reagerat på stod inte i texten.

**How to apply:** När en uppgift ändrar gränssnittet, skriv före bygget en rad i stil med
*"i listan händer X när du klickar på Y; på sidan Z ser du W"*, och nämn särskilt vad som
**inte** ändras om det avviker från resten av appen. Definiera substantiv som kan läsas på två
sätt (kort, sida, rad, vy). Hör till samma familj som [[en-spec-ar-inte-sann-for-att-den-ar-skriven]]
och [[ett-namn-som-inte-skiljer-ar-ett-halvt-namn]].
