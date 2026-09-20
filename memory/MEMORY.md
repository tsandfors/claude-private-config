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
- [En uppdelning går att granska](en-uppdelning-gar-att-granska.md) — flytta stycken oförändrade i stället för att skriva om; en omskrivning av resonerande prosa går inte att läsa sig till
- [Räkneord ruttnar tystast](rakneord-ruttnar-tystast.md) — greppa talen först vid en dokumentgranskning; stryk hellre talet än uppdatera det
- [Korrigera, inte bara komplettera](korrigera-inte-bara-komplettera.md) — gör ett motsägelsesvep före "klart"; riv upp gamla påståenden, lägg inte bara till
- [En instruktion är ingen spärr](instruktion-ar-ingen-sparr.md) — bruten rutin flyttas till harnesset, inte skrivs om tydligare
- [Ett fel sitter sällan ensamt](ett-fel-sitter-sallan-ensamt.md) — greppa efter mönstret så fort jag kan formulera det; börja i filen jag står i
- [Räkna omfattningen före spec](rakna-omfattningen-fore-spec.md) — ett önskemål gäller ofta färre ställen än det låter, och siffran ändrar vad det betyder
- [En spec är inte sann för att den är skriven](en-spec-ar-inte-sann-for-att-den-ar-skriven.md) — fråga om regeln är sann som den står innan jag kodar den, inte bara hur den ska kodas
- [En spec nämner ofta bara ena halvan](en-spec-namner-ofta-bara-ena-halvan.md) — specen säger vem som får ändra och tiger om vem som får läsa; fråga efter halvan som saknas
- [En vakt på namnet täcker inte saken](en-vakt-pa-namnet-tacker-inte-saken.md) — räkna ingångarna till det som skyddas, inte sätten jag brukar nå det
- [En kompensation kan dölja ett fel](en-kompensation-kan-dolja-ett-fel.md) — klampningar och toleranser maskerar; prova också i läget där de inte gäller
- [Obemärgat arbete är osynligt](obemargat-arbete-ar-osynligt.md) — svep efter obemärgade brancher innan jag skriver om något; frånvaro har ingen representation
- [Mät takten, inte bara nivån](mat-takten-inte-bara-nivan.md) — ett tak som nås av något som växer är ingen städuppgift; läs tillväxten ur historiken
- [Mina uppslag rankas inte](mina-uppslag-rankas-inte.md) — egna idéer sägs i samtalet, aldrig i användarens kö; placeringen slår brasklappen
- [Förklara brus där granskningen letar](forklara-brus-dar-granskningen-letar.md) — ofarligt brus återupptäcks som fynd; säg också om en notering är en uppmaning eller inte
- [Ett steg kan lämna ett trasigt mellanläge](ett-steg-kan-lamna-ett-trasigt-mellanlage.md) — namnge fönstret där appen är sämre än före; låt det styra ordningen på resten
- [Ett villkor kan låsa tillståndet inifrån](ett-villkor-kan-lasa-tillstandet-inifran.md) — döljer jag vägen ut ur ett tillstånd blir tillståndet permanent; räkna övergångarna
- [Ett namn som inte skiljer är ett halvt namn](ett-namn-som-inte-skiljer-ar-ett-halvt-namn.md) — tre knappar kan heta likadant och passera ett namnsvep; disambiguering i en selektor är ett fynd

## Öppna spår

- [Plan mode utreds separat](plan-mode-utreds-separat.md) — briefen ligger i `~/.claude-private/PLAN_MODE.md`; frågan om modellen går inte att besvara inifrån, och mätningen förorenar sig själv

## Tokenkostnad och kontext

- [Ett verktygsresultat kostar gånger återstående turer](verktygsresultat-kostar-ganger-aterstaende-turer.md) — mät medelkontext per tur ur `usage`; kortare sessioner slår kortare svar
- [Caveman avvisad, effort high behålls](caveman-avvisad-effort-high-behalls.md) — bägge prövade och avvisade 2026-09-10; föreslå dem inte igen utan nya siffror

## Git

- [Visa commit-meddelandet, pusha aldrig oombedd](no-commit-or-push-without-approval.md) — två skilda godkännanden; "är allt pushat?" är en fråga, inte en begäran
- [Sammanfatta före commit](sammanfatta-fore-commit.md) — skumbar lista över vad som ändrats bredvid meddelandet; olika läsare, olika text

## Testning och verifiering

- [Verifiering hör till leveransen](verifiering-hor-till-leveransen.md) — tester i samma svep som koden; luckor sägs högt i första meningen
- [En backup säger inte vad som blev kvar](backup-svarar-inte-pa-vad-som-blev-kvar.md) — mät den kvarvarande sidan efter en städning, inte den borttagna
- [Tystnad är tvetydig](tystnad-ar-tvetydig.md) — fråga vad en kontroll jämför mot; evig tystnad och evigt larm ser båda ut som ett fungerande larm
- [En svit bygger sin egen värld](en-svit-bygger-sin-egen-varld.md) — grönt mäter inte dev-miljön; okörda migrationer och gamla containrar faller utanför
- [Ett grönt test bevisar inget i sig](gront-test-bevisar-inget-i-sig.md) — kör mutationen; mät också utan ändringen; en fixtur med ett exemplar mäter inte en regel om flera
- [En grön mutation är inte ett besked](en-gron-mutation-ar-inte-ett-besked.md) — kontrollera att mutationen muterade, och att facit inte härleds ur det som muterades
- [En väntan flyttar mätpunkten](en-vantan-flyttar-matpunkten.md) — en tillagd await låter allt annat rendera; skopa assertionen i stället för att räkna i hela dokumentet
- [Frånvaro behöver ett positivt kvitto](franvaro-behover-ett-positivt-kvitto.md) — ett test på att något inte finns måste ankras i något som säkert hänt; annars är det grönt av fel skäl
- [Tömma är inte att hämta om](tomma-ar-inte-att-hamta-om.md) — kastat tillstånd ersätts inte av sig självt; fråga vad som får skärmen att fråga igen
- [Två källor ger tillstånd per kombination](tva-kallor-ger-tillstand-per-kombination.md) — pröva den ena läsningen trasig och den andra hel; det är där en kontroll ljuger tvärsäkert
- [Ett värde i en URL har en teckenmängd](ett-varde-i-en-url-har-en-teckenmangd.md) — `+` blir mellanslag; en tolerant fallback gör felet tyst
- [En normalisering är också en gissning](normalisering-ar-ocksa-en-gissning.md) — raden jag skrev för att slippa gissa tar bort ett fall jag inte räknade upp
- [Ett prov får inte orsaka skadan](prov-far-inte-orsaka-skadan.md) — rikta prov på oåterkalleliga spärrar mot ett påhittat mål, inte mot det riktiga
- [Backa ett prov med en kopia](backa-ett-prov-med-en-kopia.md) — `git checkout` backar till senaste commit, inte till före mutationen
- [Dokumentationen av en sanering läcker](dokumentationen-av-en-sanering-lacker.md) — att beskriva en borttagen sträng återinför den; kontrollera diffen, inte arbetsträdet
- [En byggtidsvariabel reser med imagen](byggtidsvariabel-reser-med-imagen.md) — fråga när en konfiguration läses; ta hellre bort frågan än sätt rätt värde
- [En olåst version driver isär](olast-version-driver-isar.md) — rullande taggar och caret-intervall gör maskinerna olika; den som redan har artefakten kan inte se det

## att-gora

- [Databasen är slängbar](databasen-ar-slangbar.md) — migrationssvårighet är inget argument här; villkorslöst sedan syftesbytet 2026-08-28
