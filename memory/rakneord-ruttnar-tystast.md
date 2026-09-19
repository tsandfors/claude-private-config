---
name: rakneord-ruttnar-tystast
description: "Vid en granskning av dokumentation: greppa talen först, för de var sanna när de skrevs och säger inte till när de slutar vara det"
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 8309c397-54f3-49b6-a685-1a0a01352b78
  modified: 2026-09-11T20:52:15.861Z
---

När jag sveper en dokumentfil efter det som blivit osant: **börja med räkneorden.** De är den
sort som ruttnar tystast – de var sanna när de skrevs, de ser lika trovärdiga ut efteråt, och de
är dessutom det enda i en text som går att hitta mekaniskt.

**Varför:** i `att-gora` svepte jag `CLAUDE.md` och hittade tre falska påståenden. Två av dem
var tal. Sex ställen sa "tretton vy-nycklar" – det hade varit fjorton sedan en sida lades till
fem dagar tidigare – och "de trettioen isoleringstesterna" var 52. Ingen av dem hade upptäckts
av att läsa, för de läser rätt. Den tredje, ett verkligt falskt påstående i prosa, hittades av
att jag greppade efter formuleringar om **frånvaro**: *finns inte*, *saknas*, *inte byggd*,
*obesvarad*. Också en greppbar klass.

**How to apply:** två svep, bägge mekaniska. `grep` efter räkneord och siffror, och kontrollera
varje mot koden. `grep` efter påståenden om att något inte finns än. Och när ett tal visar sig
vara fel: **stryk det hellre än uppdatera det**, om meningen håller utan – *alla tretton* blev
*varje nyckel*, som inte kan ruttna igen. Ett datum åldras och säger det själv, ett tal ljuger
utan att röra sig. Samma familj som [[korrigera-inte-bara-komplettera]] och
[[en-uppdelning-gar-att-granska]].
