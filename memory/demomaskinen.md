---
name: demomaskinen
description: Var demostacken bor – tomass@192.168.50.120, repot i /home/tomass/dev/git/private/test_https/att-gora, appen på :8080; scp-raden för guidens film
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

Uppdatering görs **på** maskinen, i repot: `git pull && yarn demo`, och vid behov
`yarn demo:wipe <användarnamn>`. Bor här och inte i repot eftersom raden namnger en användare och
en hemkatalog. Att beställaren inte når adressen från sin egen Mac är en egen öppen fråga, se
[[frun-nar-inte-demon]].
