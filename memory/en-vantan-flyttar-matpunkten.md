---
name: en-vantan-flyttar-matpunkten
description: Lägger jag till en await i ett test hinner allt annat också rendera - dokumentvida räkningar börjar mäta något de inte mätte
metadata: 
  node_type: memory
  type: feedback
  scope: global
  modified: 2026-09-09T22:28:18.070Z
  originSessionId: 68ce4615-883b-4e36-9900-0147b4be8e17
---

När jag lägger till en `await` i ett testet **flyttar jag mätpunkten för allt annat på sidan
också**, inte bara för det jag väntar på. Varje fråga som var obesvarad när assertionen låg
tidigare hinner nu landa. En dokumentvid räkning – `getAllByRole("link")`, antal rubriker,
antal rader – börjar då mäta saker den aldrig såg förut, och den faller utan att något är
trasigt.

**Varför:** en räkning som stått sedan bygget (`links).toHaveLength(13)`, menyns poster) föll
när menyn blev en asynkron läsning och testet fick en `await`. Väntan gav guidens egen
innehållsförteckning tid att rita sin `<nav>`, och den fjortonde länken var alltså sidans och
inte menyns. Testet hade aldrig mätt "menyns poster" – det hade mätt "de länkar som råkat
finnas när assertionen kördes", och det sammanföll med rätt svar så länge sidan var långsammare
än assertionen.

**How to apply:** skopa assertionen till det den handlar om (`within(landmark)`,
`getByRole(..., {name})`) i stället för att räkna i hela dokumentet – och när ett gammalt test
faller efter att jag lagt till en väntan, fråga först om det mätte rätt sak förut, innan jag
justerar siffran. Ett landmärke utan namn går inte att skopa till, så namnet är halva
åtgärden. Besläktat med [[gront-test-bevisar-inget-i-sig]] och
[[korrigera-inte-bara-komplettera]].
