---
name: prov-far-inte-orsaka-skadan
description: Ett prov på en spärr mot något oåterkalleligt får inte kunna orsaka det den skyddar mot - hitta på målet
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 3b69eaa3-0aa5-4f3d-8c92-304c62b71dc8
  modified: 2026-09-09T15:17:19.776Z
---

När jag provar att en spärr faktiskt nekar, och det den skyddar mot är **oåterkalleligt**, ska
provet riktas mot ett mål som inte finns. Ett påhittat volymnamn, ett konto ingen använder, en
katalog under `/tmp`. Går spärren sönder är utfallet då ingenting alls i stället för precis den
skada jag byggde den för att förhindra.

**Varför:** två gånger i `att-gora` har det spelat roll åt varsitt håll. När `bash-guard.py`s
regel mot `docker volume rm` provades i en session var volymnamnet påhittat med flit — hade
hooken varit trasig hade kommandot gått igenom och raderat databasen, alltså det provet skulle
bevisa var skyddat. Åt andra hållet: jag provade en gång en kalenderprobe mot Tomas *riktiga*
konto, spärren fanns inte där jag trodde, och proben skrev över hans fungerande kalenderadress —
ett write-only-fält som ingen kan läsa tillbaka. **Prober som skriver hör hemma på ett konto man
får förstöra.**

Det gäller bredare än spärrar: varje gång jag ska demonstrera att något *inte* händer, är det
värt en sekund att fråga vad som händer om jag har fel.

**How to apply:** Före ett prov som rör radering, överskrivning eller något annat utan väg
tillbaka: byt ut målet mot ett påhittat, eller flytta provet till ett skraprepo eller ett
testkonto. Om provet bara går att göra mot det riktiga målet är det inte ett prov utan en
körning, och då ska det sägas högt och godkännas först. Släktskap:
[[gront-test-bevisar-inget-i-sig]] om att provet ska kunna misslyckas,
[[backup-svarar-inte-pa-vad-som-blev-kvar]] om att mäta den kvarvarande sidan, och
[[instruktion-ar-ingen-sparr]] om varför spärren behövs innan provet gör det.
