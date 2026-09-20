# Täta skott mot jobbet

Maskinen det här byggs på är en jobblaptop, och de privata projekten på den ska inte blanda sig
med det jobbrelaterade, åt något håll. Kravet är Tomas och uttryckligen ställt 2026-08-26.

**Det här är skälen, mätningarna och felen som hittades på vägen.** Reglerna – det som binder
den som skriver kod – står i `att-gora/CLAUDE.md` under *Täta skott mot jobbet*, i en sektion på
en tiondel av den här filens längd. Texten flyttades hit 2026-09-06, när projektfilen slog i
harnessets teckengräns på 150 000: den beskrev arrangemang som bor i den här katalogen och gäller
varje privat session i varje privat repo, alltså precis vad projektfilens eget undantagstest
säger inte hör hemma i ett repo. Regeln hade tillämpats på filerna och aldrig på texten som
beskriver dem.

**Tre saker läses härifrån och inte därifrån**, och de är skälet att filen inte bara är ett
arkiv: runbooken för att skapa en ny PAT när token gått ut, statusradens segmentdesign, och
avsnittet nedan om varför en privat lokal adress inte går att öppna i Chrome.

**Och en tredje sorts blandning finns, vid sidan av de två resten av filen handlar om.** Allt
härunder gäller vad som *läcker* – härifrån till jobbet, och sedan granskningen 2026-08-28 även
åt andra hållet. Det som upptäcktes 2026-09-20 läcker ingenting åt något håll: det är jobbets
styrning av maskinen som **hindrar** det privata arbetet. Ingen hemlighet rör sig, och ändå
avgör arrangemanget vad som går att göra. Leta efter den sorten också.

## Chrome når inga lokala nät, och felet ser ut som ett nätverksfel

**Symptomet:** `http://192.168.50.120:8080/` ger `ERR_ADDRESS_UNREACHABLE` i Chrome, medan
maskinen svarar på ping, `curl` får 200, och Firefox öppnar sidan utan problem.

**Orsaken är en påtvingad Chrome-policy**, `/Library/Managed Preferences/com.google.Chrome.plist`,
som 2026-09-20 innehöll exakt fyra nycklar:

```
LocalNetworkAccessRestrictionsEnabled = true
LocalNetworkAccessAllowedForUrls = [ https://[*.]okta.com, https://[*.]oktapreview.com ]
```

Jobbet har alltså stängt av all åtkomst till lokala nät från Chrome, med Okta som enda undantag.

**Läs den filen först nästa gång något privat inte går att nå härifrån.** Det tog tio minuters
felsökning i fel ände att hitta – jag letade efter VPN, rutter och proxy, och gissade först på
AppGate SDP, som ligger i samma katalog som en påtvingad profil och kör åtta `utun`-gränssnitt.
Den var oskyldig. **Läxan är att ett fel som ser ut att sitta i nätet kan sitta i en policy**, och
att `route -n get` och `curl` bägge säger att allt är bra medan browsern säger motsatsen.

Det som skiljer processerna åt är vilken *applikation* som frågar, inte vilket nät den frågar
över: Chrome lyder policyn, Firefox och `curl` gör det inte, och Playwrights egen Chromium under
`~/Library/Caches/ms-playwright` gör det inte heller – vilket är värt att veta, eftersom
browsergenomgången därför fortsätter fungera mot lokala adresser som Chrome vägrar öppna.

**Åtgärden är Firefox för privata lokala adresser**, och den är bättre än ett undantag även om
ett gick att få: den privata demon hör ändå inte hemma i den Chrome-profil som bär jobbets
bokmärken.

---

Maskinen det här byggs på är en jobblaptop, och projektet är privat. Kravet är uttryckligen
ställt 2026-08-26: **ingenting härifrån får blanda sig med det jobbrelaterade**, åt något håll.
Det är inte en preferens utan en förutsättning, och tre saker håller det – varav två är en rad
var och därför lätta att radera av misstag.

- **Remoten går genom ett värdalias, inte genom github.com.**
  `origin` är `git@github-attgora:tsandfors/att-gora.git`, och `github-attgora` är en Host-post
  i `~/.ssh/config` som pekar på github.com med en **egen ed25519-nyckel** och
  `IdentitiesOnly yes`. Utan den raden erbjuder ssh jobbets `id_rsa` mot github.com också.
  Mätt när nyckeln lades upp: bara den ena nyckeln erbjuds. Skriv aldrig om remoten till
  `git@github.com:` – då tappas hela arrangemanget tyst.
- **`user.email` är repo-lokal och ska förbli det.** Den globala git-identiteten är
  jobbadressen. Tas den lokala överskrivningen bort bär nästa commit fel namn, och hela
  historiken är i dag ren: en enda författare och committer, `tsandfors
  <tomas.sandfors@gmail.com>`, över alla commits.
- **`gh` är isolerat sedan 2026-09-05, och var förbjudet fram till dess.** Den gamla lydelsen
  sa att verktyget inte skulle användas alls: dess github.com-konto på den här maskinen är ett
  jobbrelaterat konto, och `gh auth login` skriver in nya konton i samma
  `~/.config/gh/hosts.yml` som jobbets värd. Skälet var riktigt, men förbudet var bredare än
  det behövde vara – frågan *går det att isolera?* hade aldrig ställts.

  Kontot är dessutom **suspenderat** och inte bara försett med en ogiltig token, vilket stod
  här förr. Skillnaden ser akademisk ut och var det inte: det var suspenderingens 403 som
  avslöjade hålet i vägran nedan. Ett friskt jobbkonto hade svarat 200, och felet hade stått
  kvar.

  **Det gör det, men inte med det man först griper efter.** `GH_CONFIG_DIR` flyttar hela
  `hosts.yml`, och det är mätt: med en tom katalog svarar `gh` *"not logged into any GitHub
  hosts"*, alltså är jobbets bägge värdar osynliga. Men **den isolerar inte token**, och det
  var fyndet. `hosts.yml` har noll `oauth_token`-rader på den här maskinen, för gh lägger
  token i systemets nyckelring – `gh:github.com` ligger i `login.keychain-db`. En inloggning i
  en isolerad konfigkatalog hade alltså ändå lagt det privata kontots token i samma keychain
  som allt jobbrelaterat. Ett skott som bara prövas på det man tittar på är inget skott, vilket
  minneslagrets läcka 2026-08-28 redan lärde ut.

  Arrangemanget är därför **tre variabler och ingen inloggning**: `GH_CONFIG_DIR` mot
  `~/.claude-private/gh`, `GH_HOST=github.com`, och `GH_TOKEN` läst ur
  `~/.claude-private/gh/token` (600, i en katalog med 700). Med `GH_TOKEN` satt lagrar gh
  ingenting alls – mätt efter ett prov: den isolerade katalogen innehöll bara tokenfilen, ingen
  `hosts.yml` och ingen `config.yml`.

  Tre saker som **aldrig** ska göras, och skälet till var och en:

  - **`gh auth login`** – det är kommandot som skriver till nyckelringen. Hela poängen med
    `GH_TOKEN` är att slippa det.
  - **`gh auth setup-git`** – den skriver `credential.https://github.com.helper` till den
    **globala** gitconfigen, som delas med jobbet. Kontrollerat: noll sådana rader i dag. Repot
    går över ssh via värdaliaset och behöver ingen helper.
  - **`GH_ENTERPRISE_TOKEN`** – gh skickar `GH_TOKEN` bara till `github.com` och
    `ghe.com`-subdomäner, medan en Enterprise **Server** kräver den andra variabeln. Jobbets
    värd är en sådan (noll träffar på `ghe.com` i `hosts.yml`), så den privata token kan
    strukturellt inte nå den. Sätts `GH_ENTERPRISE_TOKEN` faller den spärren.

  **Två ytor bär variablerna, och det är med avsikt.** En `gh()`-funktion i
  `~/.claude-private/shell/functions.zsh`, byggd
  precis som `claude()` bredvid den, täcker terminalen och därmed också Bash-anrop i en session
  – funktionen är katalogbunden till projektträdet, så jobbets `gh` är orört utanför det (mätt
  åt bägge håll). Och `GH_CONFIG_DIR` plus `GH_HOST` ligger dessutom i
  `~/.claude-private/settings.json`, som gäller varje privat session i **varje** privat repo,
  alltså även där funktionen inte slår till. Ingen av dem bär hemligheten.

  **Saknas token vägrar funktionen i stället för att falla tillbaka.** Ett tyst fallback till
  jobbets konfiguration vore precis det utfall arrangemanget finns för att hindra, och en
  reservutväg som gör fel sak tyst är sämre än ett fel. Mätt: exitkod 1 och ett meddelande som
  säger var filen ska ligga och var det här stycket står.

  **Men vägran dömde filens storlek och inte tokenens värde, och det höll inte.**
  `[[ ! -s $fil ]]` frågar *har filen bytes?*, och en misslyckad inklistring lämnade en fil med
  enbart en radbrytning – 1 byte, alltså inte tom, alltså igenom. `$(<...)` klipper avslutande
  radbrytningar, så `GH_TOKEN` blev tomma strängen, och en tom `GH_TOKEN` behandlar gh som
  osatt: den gick vidare till nyckelringen och autentiserade som **jobbets konto**. Alltså
  precis det fallback stycket ovan påstår är omöjligt.

  Rättat 2026-09-06: vägran döms på värdet efter strippade blanktecken, vilket också gör att en
  token med skräpblanksteg omkring inte skickas vidare som den är. Läxan är den om
  `claude-latest` i ny skepnad – **kontrollen satt på en egenskap bredvid saken**, storleken i
  stället för innehållet. Sex fall är mätta mot en påhittad `$HOME` och en stubbad `gh`; tre
  vände med rättelsen och tre stod stilla, vilket är beskedet att provet mäter något.

  **Så skapas token, och så byts den.** Det här är den enda delen av arrangemanget som inte går
  att automatisera, för värdet finns bara bakom en inloggning – och det är också den del som
  återkommer, eftersom en token med utgångsdatum tar slut. Står det här för att slippa räknas
  ut en andra gång.

  En PAT är ett lösenord för program i stället för för människor, och till skillnad från ett
  lösenord kan den begränsas till vissa repon, vissa rättigheter och ett datum. **Den går inte
  att leta fram i efterhand** – GitHub visar värdet en enda gång, direkt efter att den skapats,
  och lagrar sedan bara ett hashvärde. Har du tappat bort en är svaret alltid att skapa en ny.

  Kontrollera först *Signed in as* i avatarmenyn. Browsern bär jobbets github-sessioner också,
  och en token skapad på fel konto ser i övrigt ut precis som en riktig.

  1. <https://github.com/settings/personal-access-tokens> → **Generate new token**. I UI:t:
     profilbilden → *Settings* → *Developer settings* → *Personal access tokens* →
     *Fine-grained tokens*.
  2. **Resource owner** `tsandfors`, **Repository access** *Only select repositories* →
     `tsandfors/att-gora`, och ett **Expiration**-datum.
  3. **Repository permissions**: *Contents* och *Pull requests* på **Read and write**,
     *Metadata* på *Read-only* (sätts automatiskt). *Actions: Read-only* om `gh run` ska gå.
  4. Kopiera värdet. Det börjar med `github_pat_`; `ghp_` är den gamla *classic*-varianten.

  **Skriv in den i en vanlig terminal och inte i en Claude-prompt.** `!`-prefixet kör
  kommandot i sessionen, alltså hamnar tokenen i transkriptet – vilket är att förstöra
  hemligheten i samma andetag som man skyddar den:

  ```
  read -rs GH_PAT && printf '%s' "$GH_PAT" > ~/.claude-private/gh/token && unset GH_PAT
  ```

  `-s` ekar ingenting, och värdet står aldrig på kommandoraden och därmed inte i historiken.
  En editor går lika bra. **Kontrollera rättigheterna efteråt** – filen ska vara `600`, och en
  editor kan skapa om den med andra.

  Kontrollera sedan att den kom in hel, utan att skriva ut den. Det tar tio sekunder och är
  precis vad som fattades den gång en tom inklistring blev en 403 från fel konto:

  ```bash
  head -c 11 ~/.claude-private/gh/token   # ska bli github_pat_
  wc -c < ~/.claude-private/gh/token      # ska bli ~90-100, inte 1
  gh api user --jq .login                 # ska bli tsandfors
  ```

  Att den gått ut syns som att `gh` säger att tokenen är ogiltig. Det är inte ett fel i
  arrangemanget, och åtgärden är listan ovan en gång till. En reservation: fine-grained tokens
  räcker för allt `gh pr` och `gh repo` behöver, men enstaka `gh`-kommandon är skrivna för de
  gamla classic-scopen och kan klaga – det är en gräns i verktyget och inte i uppsättningen.

- **Claude Codes state ligger i `~/.claude-private/`, inte i jobbets katalog.** Sessioner
  startas med `CLAUDE_CONFIG_DIR="$HOME/.claude-private"`, vilket en `chpwd`-hook i
  `~/.claude-private/shell/functions.zsh` sätter automatiskt när man står i projektträdet.
  Saknas filen säger `~/.zshrc` ifrån vid varje ny terminal i stället för att låta `claude` och
  `gh` tyst falla tillbaka på jobbets konfiguration - mätt åt bägge håll.
  Dit flyttar transkript, historik, plugins och `.claude.json`, som hamnar
  **inuti** katalogen (mätt). Jobbets `settings.json` läses inte, och med den faller
  OTel-blocket, jobbets plugins och marketplace, statusraden och de två SessionStart-hookarna
  plus commit-hooken bort. Det är avsikten.

- **Villkoret satt på kommandonamnet fram till 2026-09-05, och det räckte inte.** Här stod att
  en `claude()`-funktion sätter variabeln, och att den ersatte ett alias eftersom *ett alias
  kräver att man minns att skriva det*. Argumentet var riktigt och slog tillbaka mot funktionen
  själv: **en funktion kräver att man minns att inte skriva något annat.**

  Det andra namnet fanns redan. `~/bin/claude-latest` pekar på en andra installation i
  `~/.local/bin` och `~/bin/claude-stable` på homebrews, och bägge når binären utan att gå genom
  funktionen. En hel session i det här repot kördes därför på jobbets konfiguration: jobbets
  `CLAUDE.md`, jobbets minneslager, jobbets PR-hook vid start, och sessionsdatan skriven till
  `~/.claude/`. Den upptäcktes inifrån sig själv, av en fråga om något annat.

  Villkoret sitter nu på **katalogen**: en `chpwd`-hook plus ett anrop vid skalstart, för Warp
  öppnar en flik direkt i en katalog utan att köra `cd`. Tio fall är mätta i ett rent zsh –
  in i trädet, djupare ner, ut igen, skalstart på bägge sidor om gränsen, två besök i rad, och
  att `~/ts_projects` **inte** räknas som trädet, eftersom jobbrepot ligger där. `claude()` står
  kvar som andra skott men är inte längre mekanismen; att lägga till `claude-latest()` bredvid
  hade varit att räkna upp namn igen.

  **Ett fel hittades av mätningen och inte av tanken**: första versionen gjorde `unset` på vägen
  ut, vilket förstörde ett värde någon satt för hand utanför trädet – på vägen ut var variabeln
  redan vår egen och gick inte att skilja från en vi hittat på. Funktionen lånar den nu och
  lämnar tillbaka den.

  `gh` följde medvetet inte med till `chpwd`. `GH_TOKEN` i den exporterade miljön hade legat i
  varje barnprocess i hela trädet i stället för i ett kommandos miljö, och gh har ingen andra
  ingång på den här maskinen. Dyker det upp en är det den raden som ska läsas om.

  Läxan är inte om skal. **Skottet prövades aldrig mot frågan "hur skulle någon nå binären utan
  att gå genom vakten?"** – och det är samma fråga som `history.jsonl`-städningen 2026-08-28
  redan lärt ut i en annan skepnad: en backup svarar på *togs fel saker bort?*, aldrig på
  *ligger något kvar?*. Här var motsvarigheten *finns det en väg till?*.

- **Jobbets `~/.claude/CLAUDE.md` lästes ändå fram till 2026-08-27, och skälet var inget av det
  som gissades.** Först stod här att `CLAUDE_CONFIG_DIR` flyttar *varje* `~/.claude`-sökväg. Det
  var fel. Rättelsen – att **bägge** användarfilerna läses – var också fel. Jobbfilen kom aldrig
  in som användarfil: Claude Code går uppåt från arbetskatalogen mot roten och läser `CLAUDE.md`
  i varje förälder **och** `<förälder>/.claude/CLAUDE.md`. Hemkatalogen är förälder till
  `ts_projects/att-gora`, så jobbfilen lästes som **projektfil**, precis som etiketten i
  kontexten sa rakt ut. `CLAUDE_CONFIG_DIR` hade aldrig en chans att stoppa den, och två
  resonemang i rad missade det för att ingen provade att flytta sig i katalogträdet.

  Provet som avgjorde: samma prompt och samma konfigkatalog, körd från `/tmp` och från
  `~/ts_projects`. Utanför hemkatalogen var jobbfilen borta, under den var den tillbaka.

  **Nu är den utesluten**, via `claudeMdExcludes` i `~/.claude-private/settings.json` med
  jobbfilens absoluta sökväg. Mätt efteråt från projektkatalogen: jobbsträngen `false`, den
  privata markören `true`, projektets egen fil `true`, kontrollsträngen `false`. Därmed faller
  jobbets PR-granskning, `gh`-instruktioner och Slack-plugin bort – och med dem konflikten
  mellan jobbets *"visa commit-meddelandet före `git commit`"* och projektets *commita utan att
  fråga*.

  Två saker att veta om valet. Sökvägen är **absolut och inte globen** `**/.claude/CLAUDE.md`,
  som hade tystat framtida privata repons egna `.claude/CLAUDE.md` på köpet. Och raden ligger
  medvetet **utanför repot** trots regeln nedan: den ska gälla alla privata sessioner i alla
  repon, och den bär hemkatalogens namn och därmed jobbadressen, som inte får committas.

  **Obsidian-rutinen och "Slutar för dagen" följde med i snittet.** De låg i jobbets fil men är
  Tomas egna, inte jobbets, och är därför kopierade till `~/.claude-private/CLAUDE.md`. Svepet är
  omskrivet för det här sammanhanget: `~/.claude/bin/end-of-day-check.sh` frågar `gh` mot
  jobbets värd och ska **inte** köras härifrån.

- **Jobbets globala minnesstore laddas inte, och det är mätt 2026-08-28.** Påståendet stod här
  som *resonerat, inte mätt* med en varning om att inte tro det hårdare än så – nu är det
  prövat: 94 filer ligger i `~/.claude/memory/`, noll av dem i kontexten, medan de privata
  ligger project-scoped under `projects/<sökväg>/memory/` och laddas. `autoMemoryDirectory`
  pekar dit från jobbets `settings.json`, som inte läses.

  **Läckan gick åt bägge håll, och det upptäcktes samma dag.** Jobbets store bar två minnen om
  *det här* projektet – ett om commit-undantaget och ett om att databasen är slängbar – med
  `scope: att-gora`, sökvägen i klartext och en egen `## att-gora`-rubrik i indexet. De är
  raderade, och indexet med dem. Tre generella arbetssättsminnen fick stanna i jobbet men är
  **avidentifierade**: lärdomen är Tomas egen och gäller i vilket repo som helst, men de
  namngav Byrå-CRM:et som platsen där den lärdes, och det behövde de inte. Noll träffar på
  projektet i jobbets 94 filer efteråt.

  Läxan är värd en rad: **isoleringen prövades bara i en riktning.** Allt arbete på skotten
  handlade om vad som läcker *in* hit – konfiguration, instruktioner, plugins. Att det här
  projektet samtidigt skrev om sig självt i jobbets lager föll ingen in, för det lagret läses
  inte längre härifrån och syntes därför aldrig. Nästa gång ett skott granskas: gå åt bägge
  hållen.

- **Det privata minneslagret är gemensamt sedan 2026-08-28, med `scope` i varje fil.**
  Minnena låg katalogbundet under `projects/<sökväg>/memory/` – exakt den struktur jobbets
  lager övergav 2026-08-26, och av samma skäl: en katalog gör varje generell lärdom osynlig
  utanför det repo den råkade upptäckas i. Nu ligger de i `~/.claude-private/memory/`, pekade
  dit av `autoMemoryDirectory`, och bär `scope: global` eller ett repo ur
  `~/.claude-private/repos.txt`.

  **`scope` svarar på var något gäller, aldrig på var det lärdes** – provenansen står i
  `originSessionId`. Vid tvekan `global`: ett för brett scope ger brus som avfärdas, ett för
  smalt gör minnet osynligt, och det märks aldrig. **Räkna dem inte här.** Den här filen sa
  *fem av de sex* och de var åtta innan dygnet var slut – `check-memory.py` skriver ut både
  antalet och vilka scope som är i bruk, och det svaret kan inte bli osant.

  `python3 ~/.claude-private/bin/check-memory.py` underkänner saknat eller okänt scope, minnen
  utanför indexet och indexrader utan fil. **Att den biter är mätt**, alla fyra felen
  framkallade var för sig, och exit 1 kontrollerad separat – en kontroll som aldrig faller är
  värdelös. Listan över giltiga repon är en fil och inte en katalogskanning, för `~/ts_projects`
  rymmer också jobbrepot `motor-pro-import-api` och en skanning hade tyst godtagit det som
  privat scope.

  **Att lagret laddas från den nya sökvägen är mätt 2026-08-28**, i sessionen efter flytten,
  vilket var den enda plats det gick att mäta på: `MEMORY.md`-raderna stod i kontexten utan att
  någon hade läst filen, och `check-memory.py` gav exit 0. Hade de inte gjort det vore
  `autoMemoryDirectory` fel och minnena tysta – den sortens fel som inte märks av sig självt,
  och därför var kontrollen värd att skriva ner i förväg.

- **41 MB sessionsdata om det här projektet låg i jobbets katalog, och är flyttad 2026-08-28.**
  Det var elva sessionstranskript, 442 filsnapshots i `file-history/` och 95 rader i
  `history.jsonl` – alltså varje prompt och varje svar, inte metadata. *Nittiofem var en
  underräkning; de rätta siffrorna står längre ner.* De blev kvar när
  konfigurationen delades 2026-08-26: uppdelningen *kopierade* i stället för att flytta, och
  ingen tittade efteråt.

  **Åtta av nio transkript var byte-identiska dubbletter, men tre filer fanns bara hos jobbet**
  – och den viktigaste var `5a82546a`, 11 MB och 4 267 rader: hela originalbygget 13–14
  augusti. Sammanfattningen av det ligger i Obsidian, men rådatat fanns i en enda fil, i fel
  katalog. En rak `rm -rf` hade tagit den. **Bevara, verifiera, radera – i den ordningen**, och
  verifieringen ska vara `cmp` och inte en filräkning.

  En fil till var värd omsorgen: `ba6c9217` hade 494 rader privat och 642 hos jobbet, där den
  privata var ett exakt *prefix*. Sessionen kopierades vid uppdelningen och fortsatte sedan
  under jobbets konfiguration till 27 aug – samma dygn som jobbets `CLAUDE.md` slutade läsas,
  alltså sessionen där just det utreddes. Lika stora filnamn betyder inte lika filer.

  **Det som är kvar är av annan art och ska inte städas bort.** Fyra jobbsessioner nämner
  `att-gora` i förbigående: en `docker ps` som visar `attgora-attgora-api-1` (Docker-instansen
  är delad), en `ls` i Obsidian-valvet, en kataloglistning. Det är jobbsessioner i jobbrepon
  som råkat se namnet i utdata – att radera dem vore att förstöra jobbdata för ett spår som
  inte går att undvika på en delad maskin. Gränsen går vid *vems session det är*, inte vid om
  strängen förekommer.

  Jobbets `check-memory.py` hade dessutom `att-gora` i `EXTRA_SCOPES` och släppte alltså igenom
  ett privat minne utan att fela. Rättat och mätt: den underkänner nu det scopet med exit 1.

  **Filtreringen granskades samma kväll och var ofullständig: 49 rader låg kvar.** De 95 som
  togs bort var rätt rader – alla bar `project` = `.../ts_projects/att-gora`, inga jobbrader
  rök, och resten av filen var backupen minus dem i oförändrad ordning. Men filtret matchade
  den **fulla sökvägen**, och originalbygget 13–15 augusti kördes från `~/ts_projects`,
  katalogen ovanför. Sessionen är `5a82546a` – alltså exakt den 11 MB-fil som flyttades några
  timmar tidigare. **Sessionsdatan flyttades, prompterna blev kvar**, och bland dem stod
  gmail-adressen i klartext.

  Det är samma katalogträdsläxa som gav `claudeMdExcludes`: Claude Code arbetar uppåt genom
  träd, så det som gäller `att-gora/` gäller inte automatiskt `ts_projects/`. Läxan användes
  för att förklara ett fel och inte för att leta efter nästa.

  **Den verkliga läxan är dock om verifieringen, och den är värd mer än fyndet.** En backup
  svarar bara på *togs fel rader bort?* – den kan aldrig svara på *ligger något kvar?*. Det är
  två frågor, bara den ena har ett facit, och det var den andra som inte var ställd. Frågan att
  ställa efter en städning är alltså inte "kan jag ångra det här?" utan **"hur skulle jag se det
  jag missade?"** Här var svaret att räkna projekt- och sessions-id i den *kvarvarande* filen
  och jämföra mot vad som ligger i den privata katalogen.

  **Åtgärdat 2026-08-28**: 49 + 7 rader bort, den senare gruppen personlig men inte om
  projektet – Raspberry Pi:n i stugan, maj 2026, borttagen på Tomas begäran. Filen har 4 043
  rader och noll träffar på `ts_projects`, `claude_temp` och `att-gora`; ordningen är obruten
  och rättigheterna kvar på 600. **En träff står kvar med avsikt**: en jobbsession i
  `claude_space` 2026-05-12 där gmail-adressen skickades in som testdata i en API-payload. Den
  stannar, för gränsen går vid *vems session det är* och inte vid om strängen förekommer – samma
  gräns som lät fyra jobbsessioner behålla sina `att-gora`-omnämnanden.

  **`history.jsonl.bak` är raderad 2026-08-28, och därmed är tråden stängd.** Ordningen var
  bevara, verifiera, radera – och radera kom sist av ett skäl som visade sig hålla: backupen var
  det enda som avslöjade att filtreringen missat 49 rader. Hade den gått samma kväll som
  städningen hade felet aldrig gått att hitta.

  Före `rm` kontrollerades att varje borttagen rad hade sitt innehåll bevarat på annat håll –
  transkript för 11 av 11 privata sessioner i `~/.claude-private/projects/`. **En grupp hade
  det inte**: sju rader från en personlig felsökning i maj 2026 vars transkript var borta sedan
  tidigare. De raderades på Tomas begäran, som ett eget beslut och inte som en följd av det
  andra – *att radera en rad ur en delad fil* och *att förstöra enda kopian* är två olika saker,
  och den andra ska frågas om separat.

  Kvar i jobbets katalog: noll backupfiler, noll träffar på `att-gora`, `attgora`, `claude_temp`
  och `ts_projects` i `history.jsonl`. Stod här och inte i backloggen eftersom det rörde
  konfigurationen och inte appen.

**Ett undantag, och bara ett: inferensen går genom jobbets Vertex.** Valt 2026-08-26 och inte
en glömska. Det betyder att varje prompt och svar går via jobbets
GCP-projekt; OTel-exporten till jobbets kollektor följer däremot *inte* med, för
den satt i `settings.json` som inte längre läses.

- **Vertex-variablerna bor i `~/.claude-private/settings.json` och får inte flytta in i
  repot.** `ANTHROPIC_VERTEX_PROJECT_ID` namnger arbetsgivarens GCP-projekt, och att committa
  det vore samma skott brutet åt andra hållet. Det är hela skälet till att just de tre
  raderna ligger utanför git.
- **Ingen Anthropic-inloggning behövs.** Vertex autentiserar mot GCP:s ADC i
  `~/.config/gcloud/`, som ligger utanför alla konfigkataloger och därför gäller likadant i
  den privata. Byter Vertex-svaret någon gång är det *då* en inloggning tillkommer.

**Allt annat som går att lägga i repot ligger i repot** – det är regeln, uttryckligen begärd
2026-08-26, och den gäller framåt: hamnar en ny projektinställning i en konfigkatalog ska den
flyttas hit i stället. Undantagna är Vertex-variablerna, `claudeMdExcludes`, sedan
2026-08-28 **SessionStart-hooken** och **statusraden** nedan, och sedan 2026-09-05
**gh-isoleringen** ovan – den svarar ja på bägge undantagsfrågorna, för `GH_CONFIG_DIR` bär
hemkatalogens sökväg och arrangemanget ska gälla varje privat repo. Tokenfilen är dessutom det
enda undantaget som bär en riktig hemlighet, och ligger därför utanför även konfigrepot.

**Undantagen är sedan 2026-08-29 inte längre detsamma som oversionerade.** De ligger utanför
*det här* repot, vilket är vad regeln säger, och i ett andra privat repo –
`tsandfors/claude-private-config`, beskrivet längst ner i den här sektionen. Skillnaden är
värd att hålla isär: undantagsregeln handlar om **var** något hör hemma, aldrig om huruvida
det ska ha en historik. Att de två lästes som samma sak i tre dagar är hela skälet att tråden
kunde stå öppen.

**Testet för ett undantag stod fel här fram till 2026-08-28.** Det löd att det som inte kan
committas är det som *namnger arbetsgivaren eller hemkatalogen*, och att det var "hela testet".
Det var en hopslagning av två skäl till ett. `claudeMdExcludes` bar bägge – den namnger
hemkatalogen **och** den ska gälla alla privata sessioner i alla repon – och när skälen
komprimerades till en rad föll det andra bort utan att någon märkte det, för den enda punkt
regeln dittills prövats på uppfyllde bägge.

Hooken visade vad som saknades: den namnger ingenting hemligt, men den ska gälla varje privat
repo och kan därför inte bo i ett av dem. Testet är alltså **två frågor, och en räcker**:
*namnger raden arbetsgivaren eller hemkatalogen?* och *ska den gälla utanför det här repot?*
Svaras nej på bägge hör den hemma i repot.

- **SessionStart-hooken injicerar `BACKLOG.md`s *Var man börjar* vid varje sessionsstart.**
  `~/.claude-private/bin/session-start-orientation.sh`, kopplad i `settings.json` bredvid.
  Skälet är att den här filen *ber* varje session läsa tre filer i tur och ordning, och den
  begäran gick att hoppa över – vilket den blev, mätt i sessionen där hooken byggdes. En regel
  harnesset kör är något annat än en mening jag kan glömma på rad 40 av en lång fil.

  Den injicerar **sektionen och inte filen**. `BACKLOG.md` är 65 kB mot den här filens 73 kB,
  så en `@BACKLOG.md`-import hade nästan fördubblat vad varje session betalar innan den börjat;
  sektionen är 4 kB. Den klipper vid 120 rader och **säger till när den klipper** – en tyst
  avkortning läses som att allt kom med. Saknas rubriken, eller saknas `BACKLOG.md`, är den
  tyst och nöjd, så det andra privata repot som vill ha den behöver skriva en rubrik och
  ingenting annat.

  **Skriptet mättes när det byggdes, kopplingen 2026-08-28.** Fem fall är körda för hand –
  sektionen hittad, ingen `BACKLOG.md`, fel rubrik, avkortning vid 120 rader, och fallbacken
  från `CLAUDE_PROJECT_DIR` till `PWD`. Att harnesset faktiskt kör hooken och lägger utdatat i
  kontexten gick däremot bara att se i en **ny** session, precis som `autoMemoryDirectory`
  dagen innan: *Var man börjar* stod överst under sin egen rubrik, utan avkortningsnotis och
  utan att någon hade läst `BACKLOG.md`. Hade den varit tyst hade ingenting sagt ifrån.

- **Statusraden är byggd ur en skärmbild av jobbets, inte kopierad från den.**
  `~/.claude-private/bin/statusline.sh`, kopplad i `settings.json` bredvid, och den ligger
  utanför repot av hookens andra skäl: den namnger ingenting hemligt men ska gälla varje privat
  session i varje repo.

  Att den inte gick att kopiera är värt en rad, för det första svaret såg självklart ut. Jobbets
  `statusLine` pekar på en helt annan rad – emoji, inga segment – och ingen plugin,
  `settings.local.json` eller projektfil definierar den i skärmbilden. Den kom alltså inte ur
  jobbets konfiguration, och **att leta där var ändå rätt drag**: det är så man får veta att
  segmenten måste räknas fram från grunden i stället för att ärvas.

  **PR-segmentet finns inte här, och det är inget som fattas.** Skälet stod fel här fram till
  2026-09-05: det löd att segmentet krävde `gh`, som var avstängt och bar en ogiltig token.
  `gh` är inte avstängt längre – se *Täta skott mot jobbet* – så det argumentet finns inte
  kvar. Det som finns kvar är det starkare: segmentet hade kostat **ett nätanrop per
  omritning**, i en rad vars hela designfråga var att hålla nere processerna, och `gh` är
  dessutom långsammare att starta än de ~45 ms ett git-anrop kostar. Vill någon ha det är
  vägen densamma som versionskontrollens – en cachefil som skrivs av något annat, aldrig ett
  anrop inline. I stället står ahead/behind mot origin, som svarar på den fråga man faktiskt
  ställer i slutet av dagen: finns det opushat? Det läses ur `.git` utan nätverk.

  **Raden bär en vakt längst till vänster, och den är inte den vakt den först skulle vara.**
  Tanken var att varna för en session som körs mot jobbets konfiguration – men skriptet bor i
  `~/.claude-private/` och körs bara när den privata redan är laddad, så i just det fallet är
  det jobbets emojirad som ritas och min vakt är aldrig där för att säga ifrån. *En kontroll
  som aldrig kan falla är värdelös*, precis som det står om `check-memory.py` ovan.

  Det som räddade segmentet var att leta efter ett grannfel som **kan** inträffa, och det stod
  redan skrivet här: `user.email` är repo-lokal, och tas den överskrivningen bort bär nästa
  commit jobbadressen utan att någonting säger till. Vakten läser därför bägge och visar
  `▲ GLOBAL E-POST` när den lokala saknas. Den syns **i alla lägen**, även det goda – en
  markering som bara dyker upp vid fel går inte att skilja från en markering som slutat
  fungera, vilket är samma skäl som `Nothing.tsx` har tre lägen och inte två.

  Övriga segment: version, modell och effort, kontextfyllnad, sessionens kostnad, sökväg,
  branch, diff och ahead/behind. Modellen står där för att **upptäckas** och inte läsas – `.claude/settings.json`
  pinnar en, och byts den tyst syns det ingen annanstans. Kontexten är grå tills 50 % och röd
  vid 80; grönt vore ett beröm, och en rad som lugnar i färg har inget kvar att säga med när
  det väl gäller. Diffen räknar numera även otrackade filer som `?N`, eftersom `git diff` är
  blind för en fil som aldrig lagts till – en glömd `git add` såg ut precis som ett rent träd.

  **Kostnaden kom till 2026-08-29 på Tomas begäran**, som har den i jobbets rad. Den står
  bredvid kontextfyllnaden, för de två svarar på samma fråga från var sitt håll – vad den här
  sessionen förbrukat – och allt efter dem handlar om plats och inte om förbrukning. Källan är
  `.cost.total_cost_usd` i den JSON harnesset skickar på stdin, alltså samma fält jobbets rad
  läser, och den ryms i den jq-passning som redan görs: noll nya processer, mätt.

  Två val skiljer den från jobbets. Den har **två decimaler och inte en** – `%.1f` skriver
  `$0.0` en förmiddag i sträck, ett tal som antingen betyder ingenting eller att segmentet
  slutat fungera, och de går inte att skilja åt. Och den har **ingen tröskelfärg**, till
  skillnad från kontexten bredvid: en skala måste brytas vid ett tal, och det finns ingen
  budget här för talet att betyda något mot. Ett larm vars jämförelse är påhittad är precis vad
  versionssegmentet redan lärt ut. Siffran finns för att kastas ett öga på, inte för att lyda.

  Värt att veta om vad den mäter: inferensen går genom Vertex, så det här är Claude Codes egen
  uppskattning ur tokens och en prislista – formen på en sessions förbrukning, inte en faktura.

  **Ett segment till är tyst när allt är i sin ordning, och det är enda stället där det är
  rätt:** beskedet att en nyare Claude Code finns att hämta. Det gör felet osynligt – slutar
  kontrollen fungera nämner raden aldrig en uppdatering igen – men en missad versionshöjning
  kostar en dag, medan vakten ovan handlar om en commit under fel namn. Skadan avgör, inte
  principen.

  Ingenting hämtas inline. `bin/claude-version-check.sh` körs **detached, som mest var sjätte
  timme**, och lämnar `cache/claude-version` efter sig med installerad och senaste version;
  statusraden läser bara filen. En `touch` före starten tar platsen, så en skur av omritningar
  inte blir en skur av kontroller – mätt: tio omritningar i rad startade noll processer.

  **Senaste versionen kommer från `formulae.brew.sh` och inte från `brew update`**, och det är
  ett medvetet val. Lokal cask-metadata är gammal tills någon uppdaterar och kan därför aldrig
  rapportera något nytt – men `brew update` ändrar tillstånd som delas med allt annat på
  maskinen, jobbet inräknat, och det ska en privat statusrad inte göra i bakgrunden. API:et är
  en läsning. (`claude-code` är förresten en **cask**, inte en formula; `brew list --formula`
  hittar den inte.)

  **Men brew räcker inte som enda källa, och det tog två rättelser att landa rätt – bägge från
  Tomas.** Segmentet byggdes mot brew allena, precis som beställt, och var därmed tyst. Då kom
  invändningen att senaste versionen var en annan: GitHub hade `2.1.250` publicerad samma
  morgon medan casket satt på `2.1.231`. Jag lade till GitHub som andra källa – och det var
  också fel, vilket nästa fråga avslöjade.

  **Skälet är att det finns två utgivningskanaler, inte en långsam paketerare.** Mätt
  2026-08-28: `downloads.claude.ai/claude-code-releases/stable` gav `2.1.236` och `/latest` gav
  `2.1.250`. Casket `claude-code` har en `livecheck` mot **stable**-URL:en, medan
  `claude-code@latest` är en egen cask för den andra kanalen – de två `conflicts_with` varandra
  uttryckligen. GitHubs senaste release är alltså `latest`. Hade segmentet fått stå kvar mot
  den hade det lyst **permanent** för en stable-installation, och en signal som alltid är på
  säger lika lite som en som aldrig är det. Källan blev därför stable-endpointen, som dessutom
  är en radig textfil: billigare än GitHub-API:et och utan svarsgräns att hushålla med.

  **Och där stod en tredje rättelse, gjord 2026-09-06.** Här stod *"en kanal den här maskinen
  inte kör"* och *"bytte du installationskanal är den raden i `claude-version-check.sh` det som
  måste följa med"*. Kanalen var redan bytt när det skrevs: `~/bin/claude-latest` →
  `~/.local/bin/claude` är den binär Tomas startar, och den kör latest. Raden följde inte med,
  för ingen läste om meningen efteråt.

  **Felet var värre än en fel kanal: hela jämförelsen hade fel subjekt.** Alla tre tillstånden
  mätte mot `INSTALLED`, alltså brews cask – en binär ingen startar på den här maskinen. Mätt
  samma dag: körande `2.1.263`, cachen `2.1.236|2.1.236|2.1.236`, varje jämförelse falsk,
  segmentet tyst. Inte tyst för att det inte fanns något att säga, utan för att det frågade om
  fel sak, och det hade förblivit tyst för alltid.

  **Nu jämförs allt mot `$VERSION`, den version harnesset säger *kör*** – det enda ärliga
  referensvärdet, och det låg redan i raden. Skriptet slutade välja kanal och rapporterar båda;
  statusraden härleder vilken som gäller **ur datan**: en version över stable kan bara ha kommit
  från latest-kanalen. Därmed hålls den gamla fällan stängd utan en inställning som ruttnar,
  vilket är precis hur den förra versionen gick sönder. Ordningen är också omkastad – omstarten
  kommer före brew, för efter en `brew upgrade` är bägge före den körande versionen och den
  nyttiga meningen är den om binären som redan ligger på disk.

  Åtta fall och fyra mutationer körda för hand 2026-09-06; alla fyra gav fel svar och
  kontrollen rätt. Mutationerna är valda så att var och en återskapar ett känt fel: kanalen
  alltid stable (buggen ovan), kanalen alltid latest (den gamla fällan), subjektet tillbaka
  till `INSTALLED` (falsklarm om en version man redan kör), och `sort -V` utbytt mot en
  strängjämförelse.

  Läxan är inte om versioner, och den gäller åt tre håll nu: **ett tyst larm kan vara tyst för
  att allt är bra, för att det frågar fel källa, eller för att det frågar om fel sak – och ett
  larm som alltid låter har samma problem.** Frågan att ställa om en kontroll är inte om den
  fungerar utan *vad den jämför, mot vad, och är det samma sak som jag bryr mig om*. Och den
  fjärde läxan är den dyraste: **en kommentar som säger "ändra den här raden om X" är ingen
  spärr.** X inträffade, raden ändrades inte, och det tog nio dagar och en slump att märka det.

  Tre meddelanden, **i den ordning man skulle göra dem**.
  Gult ` brew: X` när brew faktiskt kan ge dig något – det enda som går att åtgärda på
  stället. Cyan `⟳ starta om för X` när uppgraderingen är gjord men den gamla fortfarande kör.
  Grått ` X ute` när kanalen rört sig men casket inte hunnit ikapp: ingen åtgärd, alltså inget
  kommando utpekat. `brew upgrade` hade inte hämtat den, och att peka på ett kommando som inte
  kan hjälpa är precis vad *"Ladda om sidan"* på en 404 gör.

  Bägge nätanropen är **anonyma curl mot publika endpoints, och inget av dem är `gh`.** Skälet
  var förr att verktyget bar jobbets konto; sedan 2026-09-05 gör det inte det, och skälet är i
  stället att anropen inte behöver ett konto alls. En anonym `curl` mot en publik endpoint kan
  inte läcka en identitet, och `gh` hade dragit in en autentiserad session i en bakgrundskontroll
  som inte frågar efter något privat.

  Sju fall är körda för hand: rent repo, två färgtrösklar, saknad `CLAUDE_CONFIG_DIR`, saknad
  lokal e-post, otrackade filer, katalog utan git och tom indata. Kostnaden har åtta egna –
  normalfall, `.cost` saknas, `null`, tomt effort, noll, fyrsiffrigt, en sträng där ett tal
  skulle stå, och tom indata – och det var **felfallen som bar hela fyndet** igen: allt utom
  det fjärde passerade lika glatt före som efter fixen. Versionssegmentet har sju
  egna, och **två buggar hittades på vägen – bägge av felfallen, inget av lyckofallen**.
  `2.1.99` mot `2.1.231`: `sort -V` sorterar dem rätt, medan en strängjämförelse hade läst
  `2.1.24` som nyare än `2.1.231` eftersom `4` slår `3` på femte tecknet. Och cachen är
  **pipe-separerad, inte tabb-separerad** – tabb är IFS-blanksteg, så bash slår ihop en följd
  av dem, och med ett tomt cask-fält gled kanalversionen in på caskets plats. Raden sa då
  `brew: X` om något brew inte hade, alltså exakt det fel de tre lydelserna finns för att
  undvika.

  **Och samma bugg satt i huvudraden hela tiden, tre rader ovanför den kommentar som beskrev
  den.** Upptäckt 2026-08-29 när kostnaden skulle in som ett sjätte fält: `read` matades
  tabbseparerat, alltså med IFS-blanksteg, så ett tomt fält i mitten sköt varje senare värde
  ett steg åt vänster. Med `effort` osatt – fullt normalt – visade raden `Opus 5 · 12` och
  tappade kontextsegmentet helt. Med kostnaden tillagd blev det värre än så: mutationsprovet
  gav `1.77%` som kontextfyllnad, ett tal som ser alldeles rimligt ut och är fel. Separatorn är
  nu unit separator, skriven som jq-escapen `\u001f` och inte som ett rått tecken:
  ett osynligt kontrolltecken i källkoden är nästa redigerings tysta fel. Den är inte
  blanksteg och bevarar därför tomma fält.

  Läxan är inte om IFS. **Buggen var redan hittad, förklarad och nedskriven – för cachefilen –
  medan den satt kvar oåtgärdad i samma fil, i den enda rad som läser hela indatan.** Ingen
  letade efter fler instanser, vilket är exakt den läxa som står under *Vyer som läser
  bokslutsår* och som appen fått lära om sig tre gånger: greppa fram alla instanser, nöj dig
  inte med den du råkade stå på. Den gäller uppenbarligen skript också.

  Sökvägen klipps vid 32 tecken
  från vänster – svansen är det som namnger en katalog – med `…` framför, för en avkortad sökväg
  utan märke läses som en riktig. **Antalet processer är det som kostar, och ska hållas nere**:
  varje git-anrop tar ~45 ms på den här maskinen och raden ritas om ideligen. Därför får
  `git status --porcelain=v2` svara på fyra frågor samtidigt – repo eller inte, branch, avstånd
  till origin och vad som är otrackat – och ett separat `rev-parse` och `ls-files` ströks, som
  betalade för svar den redan gav. En omritning ligger på ~95 ms, varav versionskontrollens
  cacheläsning är ~16.

  **Siffran är omätt 2026-08-29 och ligger då på ~110 ms, men det är inte kostnadssegmentets
  fel** – samma rad utan det mäter likadant, och variansen mellan identiska körningar var
  ±20 ms med Docker-stacken igång. Det är värt en rad just för att frestelsen är att skriva
  *före 95, efter 110* och kalla det en regression: en mätning utan ett kontrollfall mäter
  maskinen lika mycket som koden. Kontrollfallet var en kopia av skriptet med de två raderna
  borttagna.

  **Att harnesset ritar raden syns bara på din skärm**, precis som med hooken.

- **Konfigurationen har en egen historik sedan 2026-08-29, i ett andra privat repo.** Fram till
  dess låg fyra skript i `~/.claude-private/bin/` plus minneslagret på den här laptopen och
  ingen annanstans – ingen historik, ingen ångra, ingen kopia, alltså exakt det hål som
  stängdes för appen 2026-08-26. Tråden stod öppen för att undantagsregeln säger *utanför det
  här repot*, inte *utanför versionshantering*; de två råkade sammanfalla så länge det bara
  fanns en rad i en konfigfil.

  Repot är `tsandfors/claude-private-config`, och **arbetskatalogen är `~/.claude-private`
  själv** – ingen kopia, inga symlinks, ingenting som kan glida isär. Priset är att katalogen
  också rymmer 64 MB sessionsdata, så `.gitignore` är en **whitelist**: `*` först, sedan
  `!bin/`, `!memory/`, sedan 2026-09-05 `!shell/`, och tre filer till. En blacklist hade behövt
  utökas varje gång harnesset
  börjar lägga en ny fil där, och den utökningen hade glömts tyst. Det som ignoreras av misstag
  märks aldrig; det som committas av misstag går inte att ta tillbaka.

  **Att whitelisten är rätt form syntes först när något farligt kom in i katalogen.** Fram till
  2026-09-05 var det värsta som låg där hemkatalogens sökväg och ett GCP-projektnamn; nu ligger
  `gh/token` där, en personal access token i klartext. Den är ignorerad utan att någon rörde
  filen – vilket är hela skillnaden mot en blacklist, som hade krävt att någon kom ihåg att
  utöka den innan token skrevs. Det som ignoreras av misstag märks aldrig, men det gör inte det
  som **inte** ignorerades av misstag heller, förrän det ligger på en remote.

  **Kontrollen som gällde var den negativa.** Att rätt filer kom med syns i `git status`; att
  inget farligt kom med gör det inte, och det var den frågan som behövde ställas – samma läxa
  som `history.jsonl`-städningen gav under punkten ovan. Tre svep före commit: staged
  **filnamn** mot `projects/`, `sessions/`, `history`, `.claude.json` och `cache/`; staged
  **innehåll** mot jobbsträngarna; och `git check-ignore` på sex farliga sökvägar som faktiskt
  finns på disk. Alla tre rena. 20 filer, 88 kB.

  Två filer är utelämnade, bägge på undantagsregelns första fråga. `settings.json` bär
  Vertex-projektets namn och hemkatalogen i `claudeMdExcludes`, och ersätts av
  `settings.example.json` – samma fil med två platshållare, och diffen mot originalet är exakt
  de två raderna. **`~/.claude-private/CLAUDE.md` är utelämnad av ett skäl som var ett fynd och
  inte en gissning:** den namnger jobbets GitHub Enterprise-värd i klartext, i meningen om varför
  `end-of-day-check.sh` inte ska köras privat. Den privata användarfilen bar alltså en
  jobbsträng, vilket ingen hade letat efter – skotten hade granskats åt bägge håll, men ingen
  hade greppat i själva instruktionsfilen.

  **Raden är omskriven 2026-08-29 på Tomas begäran, och svepet gav mer än han frågade om.**
  Han bad om värdnamnet; ett brett svep efter åtta jobbsträngar hittade fyra i
  arbetsträdet, och den allvarligaste var inte den efterfrågade: **`CLAUDE.md` bar
  Vertex-projektets namn i klartext**, alltså precis den sträng samma fil på annat håll säger
  aldrig får committas. Regeln bröts av texten som beskrev regeln. De andra två var jobbets
  plugin-marketplace i `BACKLOG.md` och jobbets uppslagsserver här. Alla fyra är ersatta av
  generella omskrivningar – betydelsen bevaras, namnet försvinner – och `~/.claude-private/`
  är därmed också ren och kan tas in i konfigrepot.

  **Men historiken bär dem kvar, och det är ett medvetet val.** Sju commits är berörda, äldst
  `4c55ba1` från 2026-08-26, och en omskrivning hade gett 39 commits nya SHA och gjort sju
  Obsidian-noter osanna. Ingen av strängarna är en credential – ett internt GCP-projektnamn och
  tre interna verktygsnamn, i ett privat repo med en användare – så priset översteg nyttan.
  **Läs alltså inte ett rent `git grep` som att repot aldrig burit dem**, och gör inte om
  svepet i tron att historiken är ren: den är det inte, och den ska inte vara det.

- `.claude/settings.json` – modell, `alwaysThinkingEnabled`, attribution,
  `enableAllProjectMcpServers` (så att servern nedan slipper godkännas manuellt) och de två
  hookarna i `.claude/hooks/`: `PreToolUse` sedan 2026-08-30 och `SessionStart` sedan
  2026-09-05. Att de ligger i repot och inte i konfigrepot är undantagstestets bägge frågor
  besvarade med nej – och för den andra finns ett skäl till som väger tyngre än testet, se
  *Spärrar i harnesset*.
- `.mcp.json` – **playwright bor numera i repot**, inte i någon konfigkatalog. Browser-
  genomgången fungerar därmed oavsett var sessionen startas, och jobbets egen
  uppslagsserver kan inte följa med på köpet.
- `.claude/skills/genomgang/` – `/genomgang`, sedan 2026-09-06, plus de tre sondskript
  browsergenomgången kör. Undantagstestets bägge frågor besvaras nej precis som för hookarna:
  den namnger ingenting hemligt, och den handlar om den här appens sidor.
- `.claude/settings.local.json` är undantaget som **ska** stanna utanför: den bär
  hemkatalogens namn och därmed jobbadressen. Ignoreras via `~/.config/git/ignore`.
