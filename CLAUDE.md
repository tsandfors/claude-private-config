# Privata instruktioner

Den här filen är användarnivån för sessioner som kör med
`CLAUDE_CONFIG_DIR=$HOME/.claude-private`. Den ersätter jobbets `~/.claude/CLAUDE.md`,
som inte hör hemma i privata projekt.

MARKER-PRIVAT-7391

Projektets egna instruktioner står i respektive repos `CLAUDE.md` och gäller före den här.

## Varför jobbets CLAUDE.md inte längre läses

Fram till 2026-08-27 lästes `~/.claude/CLAUDE.md` **ändå** i privata sessioner, och skälet var
inte `CLAUDE_CONFIG_DIR`. Claude Code går uppåt från arbetskatalogen mot roten och läser
`CLAUDE.md` i varje förälder *och* `<förälder>/.claude/CLAUDE.md`. Hemkatalogen är förälder till
allt som ligger under den, så jobbfilen kom in som **projektfil**, inte som användarfil.

Mätt samma dag: samma prompt från `/tmp` (utanför `$HOME`) såg inte jobbfilen, från
`~/ts_projects` (under `$HOME`) såg den den. `CLAUDE_CONFIG_DIR` var identisk i bägge.

Därför står `claudeMdExcludes` i `settings.json` bredvid den här filen, med jobbfilens absoluta
sökväg. Absolut sökväg och inte en glob: den utesluter exakt en fil, medan `**/.claude/CLAUDE.md`
också hade tystat framtida privata repons egna `.claude/CLAUDE.md`. Raden gäller alla privata
sessioner, i alla repon.

**Följden är att de två rutinerna nedan flyttade hit.** De låg i jobbets fil men är dina
personligen, inte jobbets, och de hade försvunnit med samma snitt.

## Slutar för dagen

När du signalerar att du slutar – *"nu tänker jag sluta för dagen"*, *"jag avslutar den här
sessionen"*, *"då var det bra för idag"* eller liknande – gör jag de här tre stegen utan att bli
ombedd, och säger vad jag gör först. Läs inte varje "sluta" som utlösare: *"sluta med det
tillvägagångssättet"* är inte det här.

**1. Svep över det som kan gå förlorat.** I det privata sammanhanget betyder det:

- Ocommittat och opushat i repot du står i, plus opushade brancher rörda de senaste dagarna.
- Kör något i Docker, och är det byggt ur den branch du faktiskt står på? Det finns **en**
  Docker-instans på localhost, och den delas med allt annat på maskinen.
- Är minnesstoren konsekvent – pekar varje rad i `MEMORY.md` på en fil som finns, och finns
  varje fil i indexet?

Jobbets `~/.claude/bin/end-of-day-check.sh` gör motsvarande svep för jobbet, men **kör det inte
härifrån**: det frågar `gh` mot jobbets GitHub Enterprise-värd och tittar på jobbrepon,
alltså precis den blandning som inte får ske. Vill du ha det svepet, kör det i en jobbsession.

**2. Allt som måste överleva går in i en minnesfil eller i projektets `CLAUDE.md`.** Inte i
Obsidian-noten – se nedan. Öppna frågor, sådant som väntar på någon annan, beslut tagna idag:
det hör hemma i lagret som läses varje session.

**3. Sedan sparas sessionen till Obsidian**, enligt avsnittet nedan.

## Obsidian

Vault: `~/obsidian_notes`, och **den delas med jobbet**. Därför gäller sedan 2026-08-28 att allt
privat ligger under `~/obsidian_notes/private/` och ingen annanstans:

- `private/sessions/` – sessionstranskript från privata projekt
- `private/Tomas egna projekt/` – projektsammanfattningar, bland annat Byrå-CRM:ets

Valvets övriga mappar – `sessions/`, `Work Journal/`, `API docs/` och resten – är **jobbets**.
Skriv aldrig en privat not där. Det var så det såg ut fram till 2026-08-28: fyra privata
sessionsnoter låg blandade bland 62 av jobbets, och `Tomas egna projekt/` stod på toppnivån
bredvid `Work Journal/`. Samma sorts blandning som skotten mot jobbet finns för att stoppa, och
den syntes inte förrän en not sparades och sökvägen lästes högt.

Valvet är **inte versionshanterat**, så en not som skrivs över är borta. Kontrollera att filen
inte redan finns innan du skriver.

**Noterna är ett arkiv, inte en överlämning.** Du läser dem inte rutinmässigt. De finns som
livrem och hängslen: de konsulteras när något har gått fel, eller när ett beslut från en tidigare
session har glömts bort och måste rekonstrueras. Allt som gäller just nu bor i minnesfilerna och
i `CLAUDE.md` i stället.

Det ändrar vad en bra not är. Optimera för **sökbarhet, inte läsbarhet** – ingen läser den uppifrån
och ner, så putsad prosa är bortkastad möda medan greppbarhet om åtta veckor är hela värdet. Behåll
datum, repo- och branchnamn, sökvägar, commit-shas, PR-nummer, de faktiska kommandona och feltext
ordagrant. Detalj framför sammanfattning: är noten det enda som överlever från dagen måste den
svara på vad som gjordes och varför.

### Sessionstranskript

På begäran (*"spara sessionen till Obsidian"* eller liknande) sparas ett kondenserat transkript
till `~/obsidian_notes/private/sessions/<datum>.md`. Format: användarens meddelanden och mina textsvar,
inget annat – inga verktygsanrop, inga tankeblock, inga system-reminders. Korta av långa
meddelanden. Lägg en rubrik överst med datum, repon, nyckelämnen och kostnad/tokens. Parsas ur
sessionens JSONL-fil.
