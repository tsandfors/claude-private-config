---
name: en-spec-namner-ofta-bara-ena-halvan
description: "En behörighetsspec säger vem som får ändra och tiger om vem som får läsa - fråga efter den halvan innan grinden byggs"
metadata: 
  node_type: memory
  scope: global
  type: feedback
  originSessionId: session-2026-09-10-foretagsuppgifter
  modified: 2026-09-10T17:53:00.855Z
---

En spec om behörighet namnger nästan alltid **skrivningen** och tiger om **läsningen**. Tystnaden
läses lätt som "samma svar för bägge", och det är ett antagande och inte ett svar. Fråga efter
den uteblivna halvan innan grinden byggs – det är en fråga och inte en gissning, och svaret kan
ändra både kod och gränssnitt.

**Why:** Specen för företagsuppgifter sa *"företagsadmin får redigera företagsuppgifterna"* och
ingenting om vem som får se dem. Jag var på väg att spegla den befintliga grannen – hela
sektionen bara för admin, som roll- och medlemssektionerna – vilket hade varit försvarbart och
fel. Svaret blev *hela teamet läser, bara admin ändrar*, med skälet att en kollega som ska skriva
en faktura ska slippa fråga efter organisationsnumret. Det gav en permissionklass till, en läsvy
till, och en punkt i backloggen om att korten bredvid nu behandlar samma läsare olika. Inget av
det hade funnits om jag antagit att tystnaden betydde symmetri.

**How to apply:** När en spec, ett önskemål eller en befintlig grind namnger en av verbklasserna –
skriva, radera, godkänna – ställ frågan om de andra explicit innan jag kodar. Formulera den som
ett val med en rekommendation, inte som en öppen fråga: *"bara admin, eller alla läser och admin
ändrar?"* Och vid tveksamhet, börja smalt: att vidga en läsrätt senare är enkelt, att ta tillbaka
en folk vant sig vid är det inte.

Släkt med [[en-spec-ar-inte-sann-for-att-den-ar-skriven]], som misstror innehållet i det som står
skrivet medan den här misstror **fullständigheten**, och med [[utmana-oklarheter]]. Vad frånvaron
av ett svar gör med koden är samma sort som [[tystnad-ar-tvetydig]].
