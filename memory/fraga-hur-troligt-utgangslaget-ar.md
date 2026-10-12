---
name: fraga-hur-troligt-utgangslaget-ar
description: "Före gradering av ett granskningsfynd – fråga hur troligt scenariot är för de faktiska användarna, inte bara om felet är verkligt; osannolika fynd lagas inte och skrivs inte upp"
metadata:
  node_type: memory
  type: feedback
  scope: global
  originSessionId: ee6fd1c8-4f20-4089-b427-044278a03605
  modified: 2026-10-09T12:50:42.525Z
---

Ett granskningsfynd kan vara verkligt och ändå inte värt något. 2026-10-09, PR #15 i att-gora: jag
graderade "en todo raderad i en annan flik medan panelen är öppen" som major, lagade det, och skrev
fyra liknande fynd i backloggen – två flikar, nät som tappas, en sekunds retry, ordval. Tomas
stoppade det: appen används av en enmansföretagare med frontend och backend på samma server, och
dagarna hade börjat snurra på små lagningar som gav nya fynd.

**Why:** En granskning letar efter allt som *kan* gå fel, och samtidighet, flikar och nätavbrott
finns alltid till hands som scenarier. Varje fynd ser riktigt ut, lagningen är ny kod, och nästa
granskning hittar något i den – rundgången han varnat för. Felet var att jag frågade *är det sant?*
men aldrig *hur troligt är utgångsläget för den som faktiskt använder det här?*

**How to apply:** Ställ sannolikhetsfrågan först, mot vem som använder appen och hur den driftas,
och säg den högt i graderingen. Klarar fyndet inte ribban: varken laga eller skriv upp det – nämn
det kort som struket så att det inte återupptäcks. Se även [[en-granskning-kan-be-om-att-angra-forra]]
och [[ett-fynd-kan-vara-priset-for-ett-val]].
