---
name: plan-mode-utreds-separat
description: Tomas vill utforska varför plan mode sällan föreslås - briefen med mätning och fällor ligger i ~/.claude-private/PLAN_MODE.md
metadata: 
  node_type: memory
  type: reference
  scope: global
  modified: 2026-09-19T02:34:24.553Z
  originSessionId: 8f8dbf6c-c26b-49af-9781-6c22cd683b80
---

Tomas frågade 2026-09-19 varför jag inte längre föreslår plan mode, och om det beror på
modellbytet. Han vill ta upp det i en **egen session**. Underlaget är skrivet och ligger i
**`~/.claude-private/PLAN_MODE.md`** – läs den filen innan du svarar på frågan, i stället för
att börja om.

Tre saker därifrån som är lätta att gå fel på och därför står också här:

- **Frågan om modellen går inte att besvara inifrån.** Ingen session kan jämföra sig med en
  tidigare version av sig själv. Svara inte med en kausal historia; den låter hjälpsam och är
  påhittad. Se [[utmana-oklarheter]].
- **En ordräkning i transkripten mäter systemprompten.** Varje sessions verktygslista nämner
  `EnterPlanMode`, så bara JSON-nyckeln `"name":"EnterPlanMode"` räknas. Mätt så: **en av 59
  sessioner** hade faktiska anrop, alltså har det varit sällsynt hela tiden och inte nyligen
  slutat.
- **Att mäta förorenar datan** – ett grep efter verktygsnamnet skriver namnet i transkriptet.
  Uteslut den session som gör mätningen. Samma mönster som
  [[dokumentationen-av-en-sanering-lacker]].

Det som binder oavsett hur utredningen slutar: att jag brukar beskriva upplägget först är en
instruktion jag ger mig själv, och plan mode är spärren. Se
[[instruktion-ar-ingen-sparr]].
