# Memory Index

Ett gemensamt lager sedan 2026-08-28. Tidigare låg minnena i
`~/.claude-private/projects/<cwd>/memory/`, alltså katalogbundna – vilket är precis den
struktur jobbets lager övergav 2026-08-26, och av samma skäl: en katalog gör varje generell
lärdom osynlig utanför det repo den råkade upptäckas i. Pekas hit via `autoMemoryDirectory`
i `~/.claude-private/settings.json`.

## scope-fältet

Varje minne har `scope:` i sin frontmatter — `global`, ett repo ur `repos.txt`, eller flera
kommaseparerade. Katalogen bar tidigare den informationen strukturellt; nu står den skriven,
och skrivna fakta ruttnar.

`scope` svarar på **var något gäller**, aldrig på var det lärdes. Provenansen finns i
`originSessionId`. Blandas de ihop blir en generell lärdom osynlig utanför det repo den
råkade upptäckas i. Vid tveksamhet: `global`. Ett för brett scope ger brus som avfärdas;
ett för smalt gör minnet osynligt, och **det märks aldrig**.

Kör **`python3 ~/.claude-private/bin/check-memory.py`** när du rör lagret. Den underkänner
saknat eller okänt scope, minnen som inte finns i det här indexet, och indexrader som pekar
på filer som inte finns. Giltiga repo-namn läses ur `~/.claude-private/repos.txt` — en fil
och inte en katalogskanning, eftersom `~/ts_projects` också rymmer jobbrepon
(`motor-pro-import-api`) och en skanning tyst skulle godta ett av dem som privat scope.

**Lagret är privat och skilt från jobbets.** Ett minne om ett privat repo får aldrig skrivas
i `~/.claude/memory/`; två hann hamna där och raderades 2026-08-28. Åt andra hållet gäller
detsamma — jobbets 94 minnen hör inte hit.

## Arbetssätt

- [Tomas är backendutvecklare](tomas-ar-backendutvecklare.md) — UX-omdömet ska komma från mig oombett, inte efterfrågas
- [Utmana oklarheter](utmana-oklarheter.md) — stående lov att ifrågasätta i stället för att gissa; smaken är hans, mätningen min
- [Korrigera, inte bara komplettera](korrigera-inte-bara-komplettera.md) — gör ett motsägelsesvep före "klart"; riv upp gamla påståenden, lägg inte bara till
- [En instruktion är ingen spärr](instruktion-ar-ingen-sparr.md) — bruten rutin flyttas till harnesset, inte skrivs om tydligare
- [Ett fel sitter sällan ensamt](ett-fel-sitter-sallan-ensamt.md) — greppa efter mönstret så fort jag kan formulera det; börja i filen jag står i

## Git

- [Visa commit-meddelandet, pusha aldrig oombedd](no-commit-or-push-without-approval.md) — två skilda godkännanden; "är allt pushat?" är en fråga, inte en begäran

## Testning och verifiering

- [Verifiering hör till leveransen](verifiering-hor-till-leveransen.md) — tester i samma svep som koden; luckor sägs högt i första meningen
- [En backup säger inte vad som blev kvar](backup-svarar-inte-pa-vad-som-blev-kvar.md) — mät den kvarvarande sidan efter en städning, inte den borttagna
- [Tystnad är tvetydig](tystnad-ar-tvetydig.md) — fråga vad en kontroll jämför mot; evig tystnad och evigt larm ser båda ut som ett fungerande larm
- [Ett grönt test bevisar inget i sig](gront-test-bevisar-inget-i-sig.md) — kör mutationen; och en fixtur med ett exemplar mäter inte en regel om flera

## att-gora

- [Databasen är slängbar](databasen-ar-slangbar.md) — migrationssvårighet är inget argument här; villkorslöst sedan syftesbytet 2026-08-28
