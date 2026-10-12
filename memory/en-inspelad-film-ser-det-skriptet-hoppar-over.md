---
name: en-inspelad-film-ser-det-skriptet-hoppar-over
description: Playwright-video visar allt ett testskript är byggt för att hoppa över – pekaren hoppar, väntan blir stillbild, "networkidle" är inte "laddad"
metadata:
  type: feedback
  scope: global
---

Ett Playwright-skript som ska **filmas** måste skrivas för en tittare och inte för en assertion,
och de tre felen syns inte i skriptet utan bara i filmen. Mätt 2026-10-09 i att-gora, `film/`:

- **`page.mouse.move(x, y, { steps: 30 })` skickar alla steg på en gång**, så pekaren korsar
  skärmen på en tiondels sekund och ser ut att hoppa. Glid själv: en loop med easing och ~16 ms
  `waitForTimeout` per steg. Pekaren syns inte alls på film utan en egen ritad markör.
- **`waitForLoadState("networkidle")` är inte "sidan har laddat".** En sida stod på
  *"Hämtar …"* hela sitt stopp medan API:t svarade på 12 ms. Vänta på det tittaren ser – att
  laddningstexten är borta.
- **All väntan blir stillbild**, och Tomas såg det som att filmen *"stannade och fortsatte"*.
  Lägg texten för nästa steg vid klicket, så att laddningen blir lästid.

**Why:** Ett test bryr sig om slutläget; en film visar vägen dit, och det är där alla tre
gömmer sig. Frysdetektorn (`ffmpeg freezedetect`) kunde inte skilja ett avsiktligt stopp från
ett oavsiktligt, och jämna tidsstämplar uteslöt bara omkodningen.

**How to apply:** Titta på bilder tätt (10/s) runt en rörelse innan jag drar slutsatser om
ryckighet, och fråga *vad ser tittaren medan skriptet väntar?* vid varje `await`. Jag kan inte
höra ljud – nivåer går att mäta (`volumedetect`), om musiken är bra är användarens att säga.
Se också [[ett-delat-verktyg-bar-mina-installningar]].
