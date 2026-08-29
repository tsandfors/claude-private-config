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
| `CLAUDE.md` | Användarnivåns instruktioner för privata sessioner: dagsavslutet, Obsidian-rutinen. |
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

## Kör aldrig `git clean` här

Det följer av att arbetskatalogen är en state-katalog: nästan allt i den är **ignorerat och
otrackat**, vilket är precis vad `git clean -fdx` finns för att ta bort. Ett kommando som i ett
vanligt repo betyder "städa bort skräp" betyder här *radera `settings.json`, hela `memory/`s
oskrivna ändringar, samtliga sessionstranskript, prompthistoriken och cachen*. Ingenting av det
går att få tillbaka, och `settings.json` finns inte på remoten.

Samma varning gäller `git checkout .` och `git reset --hard` i mindre grad – de rör bara
spårade filer, men `bin/` och `memory/` är spårade och en oskriven minnesfil är borta lika
tyst.

## Vad som medvetet inte ligger här

- **Sessionsdata i alla former.** Se `.gitignore`.

`CLAUDE.md` stod här fram till 2026-08-29. Den bar då jobbets GitHub Enterprise-värd i klartext och föll
på samma test som `settings.json`; raden är omskriven i generella termer och filen är med.
Kontrollen före den togs in var bredare än den strängen: inga absoluta hemkatalogsökvägar, inga
e-postadresser, inga jobbnamn. **Gör om det svepet innan filen ändras**, för den är den enda
committade filen här som är löpande prosa om jobbet och därmed den lättaste att råka namnge
något i.

En sak till, upptäckt genom att kontrollen fällde den här filen: **att beskriva en sträng man
tagit bort återinför den.** Meningen ovan namngav först värden den säger att vi slutat namnge,
och det hade gått igenom om den negativa kontrollen inte körts på den *staged diffen* i stället
för på arbetsträdet. Samma misstag gjordes två gånger samma dag, i två olika repon.

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
