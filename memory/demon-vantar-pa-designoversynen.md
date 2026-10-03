---
name: demon-vantar-pa-designoversynen
description: PR #2 (designöversynen, lager 1 och 2) är ihopslagen i main 2026-10-03 men demomaskinen är inte uppdaterad – beställaren ser fortfarande den gamla appen
metadata:
  type: project
  scope: att-gora
---

PR #2, *Client design review: the new shell on every page, and Säljplan rebuilt to her mockup*,
slogs ihop i `main` 2026-10-03 kl. 21:56 UTC (merge-commit `8f3adf6`). Den bär skalet på alla
fjorton sidorna, Säljplanens nya struktur, Säljmånaden och periodbytets rad.

**Demomaskinen är inte uppdaterad.** Tomas kör `git pull && yarn demo` där själv; migrationen
`crm/0005_plan_item_sales_month` körs av `run.sh` vid start och lägger bara till ett nullbart
fält, så demodatan rörs inte. Tills dess ser beställaren den gamla appen på demon.

**Why:** Det enda steget som återstår av designöversynen bor på en annan maskin och syns inte i
repot – `main` ser färdig ut härifrån.

**How to apply:** Fråga om demon är uppdaterad innan något sägs om vad beställaren har sett
eller tycker om lager 2 i bruk. Radera minnet när Tomas bekräftat att den är det. Att hon alls
når demon är en egen öppen fråga, se [[frun-nar-inte-demon]].

Rester på origin: `design-saljplan` och `design-skalet` finns kvar där med avsikt (Tomas lät
dem stå 2026-10-03); de lokala är raderade. Bägge är helt ihopslagna.
