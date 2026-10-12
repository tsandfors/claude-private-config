---
name: en-syntetisk-blur-flyttar-inte-fokus
description: "fireEvent.blur skickar händelsen men lämnar fokus kvar; fältet blurrar på riktigt senare och sparar en gång till, mitt i nästa steg av testet"
metadata:
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 10770320-983e-458f-8457-561499ff94c6
  modified: 2026-10-07T08:46:30.581Z
---

`fireEvent.blur(fält)` i testing-library skickar en blur-händelse men flyttar inte fokus.
Hade fältet fått fokus på riktigt – av komponenten själv, som `useFocusOnOpen` gör när en
penna öppnar raden – ligger fokus kvar där. Nästa gång något tar fokus på riktigt, till
exempel en ruta som öppnas, blurrar fältet en gång till och sparar igen.

Mätt 2026-10-06 i att-goras `ForsaljningPage.test.tsx`: en andra PATCH avgjordes efter
testets nästa steg och skrev tillbaka en statusrad som just hade rensats. Testet var rött
av ett race som bara fanns i testet. Rättelsen var `act(() => cell.focus())` före
ändringen och `cell.blur()` efter den, alltså riktig fokus åt bägge hållen.

**Why:** Felet ser ut som en bugg i appen, med en extra skrivning och ett tillstånd som
inte rensas, och letandet börjar därför på fel ställe.

**How to apply:** Blandar ett test syntetiska fokushändelser med kod som själv flyttar
fokus, skicka fokus på riktigt med `element.focus()`/`.blur()` inom `act`. Ser du en
oväntad extra skrivning i ett test, logga anropen innan du misstänker appen. Den
generella sorten är [[en-vantan-flyttar-matpunkten]]: riggen gör något annat än en
webbläsare, och skillnaden syns som ett fel någon annanstans.
