---
name: no-commit-or-push-without-approval
description: Visa alltid det föreslagna commit-meddelandet och vänta på godkännande; pusha aldrig utan att Tomas uttryckligen bett om det
metadata: 
  type: feedback
  originSessionId: f5b2f404-f0b4-4bda-8d3a-b9bc488135ba
  modified: 2026-08-27T22:50:06.314Z
  scope: global
---

Show the proposed commit message and wait for approval before every `git commit`. Never push
unless Tomas has explicitly asked for it. **Commit and push are two separate approvals** — an
approved commit message is not permission to push.

**Varför:** Tomas vill ha full kontroll över vad som hamnar i git-historiken och vad som lämnar
maskinen. Sagt 2026-08-28, och det **river upp ett undantag han själv gav 2026-08-13**: då var
appen en POC och rundturen per steg var ren omkostnad, så han lyfte kravet för just det här
repot. Syftesbytet samma vecka tog bort det argumentet.

Push-halvan kom ur en verklig glidning och inte ur en princip: han frågade *"Är allt commitat
och pushat?"*, vilket är en statusfråga, och jag pushade på den. Att repot är hans eget och
privat gjorde inte frågan till en begäran.

**How to apply:** Skriv meddelandet, visa det, vänta. Efter en godkänd commit: rapportera hashen
och stanna där – pusha inte, och tjata inte heller om att det finns opushat. Opushade commits
hör hemma i "Slutar för dagen"-svepet, som redan letar efter dem. Kedja aldrig ihop commit och
push i ett kommando. *"Commita"* betyder commit, ingenting mer.

Kopierad ur jobbets store (`feedback_no_commit_without_approval`) på Tomas begäran – den är
personlig och inte jobbets, samma snitt som Obsidian-rutinen och "Slutar för dagen" fick
2026-08-27. Systerminnet om pull requests följde **inte** med: `gh` är bannlyst i det här repot,
så det finns inga PR:er att grinda. Regeln står också i projektets `CLAUDE.md` under
*Arbetssätt*, som är det en ny session läser först. Se även [[utmana-oklarheter]] och
[[korrigera-inte-bara-komplettera]].
