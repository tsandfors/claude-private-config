# Claude Code – privat konfiguration

Innehållet i `~/.claude-private/`, alltså den konfigkatalog privata sessioner körs ur
(`CLAUDE_CONFIG_DIR="$HOME/.claude-private"`). Katalogen är skild från jobbets `~/.claude/`,
och det är avsikten: maskinen är en jobblaptop och projekten här är privata.

**Repot är katalogen själv, inte en kopia av den.** Ingen synkning, inga symlinks, ingenting
som kan glida isär. Priset är att arbetskatalogen också rymmer 64 MB som aldrig får till en
remote – sessionstranskript, prompthistorik, filsnapshots, cache – och det är därför
`.gitignore` är en **whitelist**. Läs kommentaren där innan du lägger till en rad.

## Vad som ligger här

| | |
|---|---|
| `bin/statusline.sh` | Statusraden. Vakt, version, modell, kontext, kostnad, sökväg, git. |
| `bin/claude-version-check.sh` | Hämtar senaste versionen detached, max var sjätte timme, till `cache/`. |
| `bin/session-start-orientation.sh` | `SessionStart`-hook: injicerar projektets *Var man börjar* ur `BACKLOG.md`. |
| `bin/check-memory.py` | Underkänner minnen med saknat eller okänt `scope`, och index som inte stämmer. |
| `memory/` | Minneslagret, gemensamt för alla privata repon. `scope` i varje fil säger var minnet gäller. |
| `repos.txt` | De privata repona. Listan `check-memory.py` validerar `scope` mot. |
| `settings.example.json` | Mall – se nedan. |

## `settings.json` är inte versionshanterad

Den bär två saker som inte får committas, och bägge av samma skäl som resten av arrangemanget
finns: **arbetsgivarens GCP-projektnamn** (inferensen går genom jobbets Vertex, ett medvetet
undantag) och **hemkatalogens absoluta sökväg** i `claudeMdExcludes`, som därmed bär
jobbadressen.

`settings.example.json` är samma fil med de två värdena utbytta mot platshållare. På en ny
maskin:

```bash
cp settings.example.json settings.json
# fyll i ANTHROPIC_VERTEX_PROJECT_ID och claudeMdExcludes
```

`claudeMdExcludes` pekar på jobbets `~/.claude/CLAUDE.md` med **absolut sökväg** och inte med
globen `**/.claude/CLAUDE.md` – den senare hade tystat framtida privata repons egna
`.claude/CLAUDE.md` på köpet.

## Att sätta upp på nytt

1. Klona till `~/.claude-private`.
2. Kopiera mallen till `settings.json` och fyll i de två värdena.
3. Sätt `CLAUDE_CODE_USE_VERTEX`-autentisering via GCP:s ADC (`~/.config/gcloud/`) – ligger
   utanför alla konfigkataloger och gäller därför likadant här.
4. `claude()`-funktionen i `~/.zshrc` sätter `CLAUDE_CONFIG_DIR` automatiskt i projektträdet.
   En funktion och inte ett alias: ett alias kräver att man minns att skriva det, och en glömd
   session läser tyst jobbets konfiguration.
5. Verifiera: `python3 bin/check-memory.py` ska ge exit 0, och statusraden ska visa
   `● privat` längst till vänster.

## Vad som medvetet inte ligger här

- **`CLAUDE.md`** – den privata användarfilen. Den bär i dag en referens till jobbets
  GitHub-värd i klartext och faller därför på samma test som `settings.json`. Skrivs den raden
  om i generella termer kan filen tas med.
- **Sessionsdata i alla former.** Se `.gitignore`.

## Skotten mot jobbet

Remoten går genom värdaliaset i `~/.ssh/config`, inte genom `github.com` direkt – en egen
ed25519-nyckel med `IdentitiesOnly yes`. Utan den raden erbjuder ssh jobbets `id_rsa` mot
github.com också. **Skriv aldrig om remoten till `git@github.com:`** – då tappas hela
arrangemanget tyst.

`user.email` ska vara repo-lokal. Den globala git-identiteten är jobbadressen, och tas
överskrivningen bort bär nästa commit fel namn. Statusradens vakt visar `▲ GLOBAL E-POST` när
den saknas – i alla lägen, även det goda, eftersom en markering som bara dyker upp vid fel inte
går att skilja från en som slutat fungera.

`gh` används inte här. Verktygets github.com-konto på den här maskinen är jobbrelaterat, och
`gh auth login` skriver in nya konton i samma `hosts.yml` som jobbets värd. Git över ssh räcker.
