---
name: en-underkatalogs-claude-md-laddas-bara-vid-read
description: "En CLAUDE.md i en underkatalog laddas av harnesset först när en fil där läses med Read – inte vid Bash (sed/cat/head), Grep eller python-heredoc; pekaren i roten måste säga det"
metadata:
  node_type: memory
  type: reference
  scope: global
  originSessionId: 6d61796a-998b-418e-8b04-6584458648f7
  modified: 2026-10-03T22:32:07.197Z
---

Mätt 2026-10-04 i *att-gora* (Claude Code 2.1.288) med en markörrad i `web/CLAUDE.md` och
`claude -p`, sex körningar plus två mot den riktiga filen:

- Ingen fil läst (verktygen avstängda): **syns inte**. Filen laddas alltså inte vid start.
- Read på `web/src/App.tsx`: **syns**.
- `head -5` och `cat` via Bash på filer under `web/`: **syns inte** (två körningar).
- Grep i `web/src`: **syns inte**.

Edit kräver en Read först, så vanliga redigeringar täcks. Det som inte täcks är exakt de vägar
auto-läget uppmuntrar: läsa med `sed -n`, skriva stora ändringar med python-heredoc, och greppa.

**Why:** En underkatalogs `CLAUDE.md` är en riktig spärr för Read/Edit-vägen och bara en
instruktion för resten – se [[instruktion-ar-ingen-sparr]]. Den som delar en växande
`CLAUDE.md` efter katalog och tror att harnesset alltid laddar delen bygger på halva sanningen.

**How to apply:** När en `CLAUDE.md` delas efter katalog, lägg en pekare i roten som säger rakt
ut att filen bara laddas vid Read och att den som läser eller skriver via Bash ska läsa den
själv. Placera bara regler i underkatalogen som enbart gäller koden där – en regel som spänner
över två kataloger hade aldrig laddats av den som rör den andra. Mät om efter en större
uppgradering av Claude Code; beteendet är harnessets och inte dokumenterat här. Provet: en
unik markörrad i underkatalogens fil, `claude -p` med `--disallowedTools Read Bash Grep Glob`
som negativ kontroll och `--allowedTools Read` som positiv.
