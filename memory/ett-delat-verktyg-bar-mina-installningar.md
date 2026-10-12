---
name: ett-delat-verktyg-bar-mina-installningar
description: Playwright MCP:s webbläsare är samma fönster som användaren tittar på; en storlek jag satte blev hens miljö och såg ut som en bugg i appen
metadata:
  type: feedback
  scope: global
---

Ett verktyg jag styr och användaren tittar i är **en delad miljö**, och det jag ställer in där
följer med till hen. 2026-10-06 rapporterade Tomas att Årshjulet inte gick att skrolla till
botten. Jag kunde inte framkalla det i fyra lägen, och han hade rätt om vad han såg: han tittade
i Playwright MCP:s Chromium, där min `browser_resize` hade låst viewporten till 900 px medan
fönstret visade mindre. I Firefox fungerade sidan. Raden om
`--disable-blink-features=AutomationControlled` i hans skärmbild var det som avslöjade fönstret.

**Why:** En rapport jag inte kan upprepa mäter ofta rummet och inte felet (se
[[en-flaky-repro-ska-flytta-till-ett-rum-jag-styr]]). Här var rummet mitt eget, och jag letade i
appen i en halvtimme innan frågan *vilket fönster tittar du i?* ställdes.

**How to apply:** När en rapport inte går att upprepa, fråga först var den sågs – webbläsare,
fönster, enhet – och kontrollera om det är automationens. Återställ det jag ändrat i ett delat
verktyg när jag är klar (`browser_close` efter en genomgång som bytt storlek). Detaljerna för
just Playwright står i att-goras `GENOMGANG.md` under *Fällor i verktyget*.
