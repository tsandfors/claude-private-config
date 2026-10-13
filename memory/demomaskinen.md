---
name: demomaskinen
description: Var demostacken bor – tomass@192.168.50.120, repot i /home/tomass/dev/git/private/test_https/att-gora, appen på :8080; ingen ssh-nyckel härifrån; scp-raden för guidens film
metadata:
  type: reference
  scope: att-gora
---

Demomaskinen, uppgiven av Tomas 2026-10-09:

- **Värd och användare:** `tomass@192.168.50.120`
- **Repot:** `/home/tomass/dev/git/private/test_https/att-gora` – katalognamnet `test_https` är
  hans, inte ett tecken på att stacken kör https (den gör det inte, se *Demostacken* i
  `CLAUDE.md`).
- **Appen:** `http://192.168.50.120:8080`

Guidens film kopieras dit från utvecklingsmaskinens repokatalog med:

```bash
scp media/tour.mp4 media/tour.jpg tomass@192.168.50.120:/home/tomass/dev/git/private/test_https/att-gora/media/
```

**Läget 2026-10-14:** demon står fortfarande på branchen `startsida` (`0c1a9b2`), alltså PR #23
och allt före den. PR #24 (planens belopp = antal × pris, migrering `crm/0007`) är ihopslagen i
`main` men inte uppe på demon. Nästa uppdatering är `git checkout main && git pull && yarn demo`
– `git pull` ensamt drar branchen, och `run.sh` migrerar vid start, så inget eget `migrate`.
Efter den syns periodmålet med den uppmuntrande texten för beställaren, förutsatt att hennes
produkter har priser.

**Jag kommer inte in med ssh** från utvecklingsmaskinen: ingen nyckel godtas, och lösenord går
inte att skriva härifrån. Ett kommando på demon körs alltså av Tomas i hans egen terminal, med
utdata inklistrad. Att lägga en nyckel dit rör skotten mot jobbet (`~/.ssh`) och är obeslutat.

Uppdatering görs **på** maskinen, i repot: `git pull && yarn demo`, och vid behov
`yarn demo:wipe <användarnamn>`. Bor här och inte i repot eftersom raden namnger en användare och
en hemkatalog. Att beställaren inte når adressen från sin egen Mac är en egen öppen fråga, se
[[frun-nar-inte-demon]].
