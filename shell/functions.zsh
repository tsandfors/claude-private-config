# Skalfunktioner för de privata projekten. Sourcas från ~/.zshrc.
#
# Filen ligger här och inte i ~/.zshrc av samma skäl som resten av konfigrepot
# finns: fram till 2026-09-05 bodde de två funktionerna nedan på en laptop och
# ingen annanstans, utan historik och utan kopia. Det är exakt det hål som
# stängdes för appen 2026-08-26 och för konfigurationen 2026-08-29.
#
# ~/.zshrc själv följer inte med, och ska inte göra det: den bär jobbets alias
# och är inte privat. Det som flyttade hit är bara det som rör de privata
# projekten.
#
# Ingenting här är ett alias, och skälet är detsamma överallt: ett alias kräver
# att man minns att skriva det, och glömmer man läser verktyget jobbets
# konfiguration utan att säga ifrån.

# Privata projekt: hela ~/ts_projects, katalogen själv och allt under den.
#
# Fram till 2026-10-12 var trädet bara ~/ts_projects/att-gora, eftersom
# jobbrepot motor-pro-import-api låg bredvid. Samma dag byggdes ett andra
# privat projekt, roblocks, och hela sessionen gick på jobbets konfiguration -
# villkoret kände inte till det, och ingenting sade ifrån. Jobbklonen raderades
# och gränsen flyttade upp en nivå. ts_projects själv räknas med, för
# originalbygget 13-15 augusti startades därifrån.
#
# Villkoret står en gång, i private_tree, och de tre funktionerna frågar den.
# Tre kopior hade glidit isär första gången någon rättade en av dem. Det är
# två jämförelser och inte ett prefix med *, för "$HOME/ts_projects"* hade
# också släppt in ~/ts_projects2 - och det gamla "…/att-gora"* släppte in
# ~/ts_projects/att-gora-kopia.
#
# Lägg aldrig ett jobbrepo under ~/ts_projects igen. Gör någon det kör det på
# den privata konfigurationen utan ett ord, alltså samma läcka åt andra hållet.
#
# Namnet får inte börja med _. Claude Code läser inte den här filen vid varje
# Bash-anrop utan tar en ögonblicksbild av skalets funktioner vid sessionsstart,
# och den hoppar över namn som börjar med understreck. Samma kväll som
# funktionen skrevs hette den _private_tree: gh() och claude() kom med i
# ögonblicksbilden, men inte den. Varje gh-anrop från en session svarade då
# "command not found", villkoret blev falskt, och i det privata trädet gick gh
# förbi tokenen till command gh, alltså jobbets väg. Det märktes som brus i en
# jobbsession, inte som ett fel i en privat.
private_tree() {
  [[ "$PWD" == "$HOME/ts_projects" || "$PWD" == "$HOME/ts_projects/"* ]]
}

# Villkoret sitter på katalogen och inte på kommandonamnet, och den skillnaden
# är hela omskrivningen 2026-09-05.
#
# Fram till dess fanns bara `claude()` nedan. Den vaktade namnet `claude` - men
# `~/bin/claude-latest` pekar på en andra installation i `~/.local/bin` och
# `~/bin/claude-stable` på homebrews, och bägge når samma binär utan att gå
# genom funktionen. En session startad med `claude-latest` läste därför jobbets
# konfiguration rakt igenom: jobbets CLAUDE.md, jobbets minneslager, jobbets
# PR-hook vid sessionsstart, och sessionsdatan skriven till `~/.claude/`. Mätt
# och inte gissat - det upptäcktes inifrån en sådan session.
#
# Filens egen invändning mot alias gällde alltså funktionen med: ett alias
# kräver att man minns att skriva det, och en funktion kräver att man minns att
# inte skriva något annat. Att stå i en katalog kan man inte glömma.
#
# chpwd täcker `cd`, och anropet efter täcker skalstart - Warp öppnar en flik
# direkt i en katalog utan att köra `cd`, så utan det vore en ny flik i
# projektträdet samma hål igen.
# Funktionen lånar CLAUDE_CONFIG_DIR i projektträdet och lämnar tillbaka den vid
# utgången. Första versionen gjorde bara `unset`, vilket såg rätt ut och mättes
# som fel: ett värde någon satt för hand utanför trädet överlevde inte ett besök
# inne i det, för på vägen ut var variabeln redan vår egen och gick inte att
# skilja från en vi själva hade hittat på. Att tyst förstöra någon annans
# inställning är precis den sortens fel hela den här omskrivningen handlar om.
_private_claude_config() {
  if private_tree; then
    if [[ "${CLAUDE_CONFIG_DIR-}" != "$HOME/.claude-private" ]]; then
      if [[ -n "${CLAUDE_CONFIG_DIR-}" ]]; then
        _private_claude_config_outside="$CLAUDE_CONFIG_DIR"
      else
        unset _private_claude_config_outside
      fi
    fi
    export CLAUDE_CONFIG_DIR="$HOME/.claude-private"
  elif [[ "${CLAUDE_CONFIG_DIR-}" == "$HOME/.claude-private" ]]; then
    if [[ -n "${_private_claude_config_outside-}" ]]; then
      export CLAUDE_CONFIG_DIR="$_private_claude_config_outside"
    else
      unset CLAUDE_CONFIG_DIR
    fi
    unset _private_claude_config_outside
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _private_claude_config
_private_claude_config

# Funktionen står kvar som andra skott, inte som mekanismen: sourcas filen i ett
# skal utan add-zsh-hook, eller faller raderna ovan bort, är det den här som
# fångar det vanligaste kommandot. Att lägga till `claude-latest()` och
# `claude-stable()` bredvid vore däremot att räkna upp namn igen, alltså precis
# det fel som just rättades.
claude() {
  if private_tree; then
    CLAUDE_CONFIG_DIR="$HOME/.claude-private" command claude "$@"
  else
    command claude "$@"
  fi
}

# Samma skott för gh, och av samma skäl - men det krävdes tre saker och inte en,
# vilket mättes 2026-09-05 innan något skrevs:
#
#   GH_CONFIG_DIR flyttar hela hosts.yml. Prövat med en tom katalog: gh svarar
#   "not logged into any GitHub hosts", alltså är jobbets bägge värdar osynliga.
#
#   GH_HOST pinnar värden, så ett kommando utanför ett git-repo inte kan gissa
#   fel.
#
#   GH_TOKEN läses ur en fil i stället för att `gh auth login` körs. Det är den
#   som inte var självklar: hosts.yml har noll oauth_token-rader på den här
#   maskinen, för gh lägger token i systemets nyckelring - `gh:github.com` finns
#   i login.keychain-db. GH_CONFIG_DIR isolerar inte nyckelringen, så en
#   inloggning hade lagt det privata kontots token i samma keychain som allt
#   jobbrelaterat. Med GH_TOKEN lagrar gh ingenting alls.
#
# GH_ENTERPRISE_TOKEN sätts medvetet inte. gh skickar GH_TOKEN bara till
# github.com och ghe.com-subdomäner, och jobbets värd är en Enterprise Server
# (noll träffar på ghe.com i hosts.yml). Den privata token kan därmed inte nå
# jobbets värd ens om någon står i fel katalog.
#
# Saknas token vägrar funktionen i stället för att falla tillbaka på jobbets
# konfiguration. Ett tyst fallback dit vore precis det utfall hela arrangemanget
# finns för att hindra - och ett fel som aldrig kan inträffa hade inte varit
# värt en rad.
#
# Vägran döms på tokenens *värde* och inte på filens storlek, och den skillnaden
# kostade en 403 att lära sig 2026-09-06. Villkoret var `[[ ! -s $fil ]]`, alltså
# "har filen bytes?" - och en fil som bara innehöll en radbrytning är 1 byte och
# passerade. `$(<...)` klipper i sin tur bort avslutande radbrytningar, så
# GH_TOKEN blev tomma strängen, och en tom GH_TOKEN behandlar gh som osatt: den
# gick vidare till nyckelringen och autentiserade som jobbets github.com-konto.
# Alltså precis det tysta fallback stycket ovan påstår är omöjligt.
#
# Att det upptäcktes var en tillfällighet: jobbets konto är suspenderat och
# svarade 403. Hade det varit friskt hade kommandot lyckats under fel identitet
# utan ett ord. Läxan är den om `claude-latest` i ny skepnad - kontrollen satt på
# en egenskap bredvid saken, storleken i stället för innehållet. Ett prefixprov
# på `github_pat_` vore möjligt ovanpå men är medvetet inte gjort: GitHub har
# lagt till tokenformat förr, och en lista över giltiga prefix ruttnar tyst.
#
# gh flyttade medvetet *inte* till chpwd som claude gjorde 2026-09-05, och
# skälen är två. GH_TOKEN i den exporterade miljön hade legat i varje
# barnprocess i hela projektträdet i stället för i ett enda kommandos miljö, och
# en token som ligger framme är en annan sorts risk än en konfigkatalog som gör
# det. Och gh har ingen andra ingång på den här maskinen: det var två
# installationer av claude som gjorde namnvakten otillräcklig, och det finns
# inget `gh-latest`. Dyker det upp en är det här raden som ska läsas om.
#
# Fem underkommandon nekas här, och de nekades förut av en PreToolUse-hook i
# att-gora (bash-guard.py, regel 3) - som bara gällde i att-gora. Den 2026-10-12
# blev roblocks det andra privata repot och gapet var öppet: isoleringen följde
# med dit, spärren gjorde det inte. Spärren flyttade hit 2026-10-13 i stället
# för till en hook i konfigrepot, och skälet är parsern. En hook får
# kommandoraden som en sträng och måste gissa vad skalet kommer att köra, så
# `git commit -m "... gh auth login ..."` måste släppas igenom medan
# `x && gh auth token` inte får det - att-goras hook bär sextio rader för just
# det, och en kopia här hade varit två parsrar som glider isär. Här har skalet
# redan svarat: funktionen anropas bara när gh faktiskt körs, och "$@" är
# argumenten som de blev.
#
# Login, refresh och logout skriver till systemets nyckelring, som GH_CONFIG_DIR
# inte isolerar. setup-git skriver en credential helper till den globala
# gitconfigen. token skriver hemligheten i klartext, i ett transkript som
# sparas. Tre skäl och tre svar, för en enda tillsägelse hade passat ingen av
# dem. Allt annat gh kan går igenom, `gh auth status` också - det är så man
# kontrollerar att isoleringen håller - men inte med -t eller --show-token, som
# skriver samma hemlighet som `gh auth token`. Hålet fanns i hooken också och
# stängdes samma dag som spärren flyttade hit.
#
# Vad den inte når, så att ingen litar på den längre än den räcker: `command
# gh`, en absolut sökväg till binären, och `bash -c` eller ett skript, där
# funktionen inte finns. Den fångar å andra sidan eval, ett kommando i en
# variabel och ett alias, som hooken inte kunde se. Det är en vakt mot en
# glidning och inte mot en motståndare, precis som hooken var.
#
# Jämförelsen är de två första argumenten, och flaggorna filtreras inte bort
# först fast hooken gjorde det. Mätt med en mutation: filtret spelar bara roll
# för en flagga utan värde *före* underkommandot, och gh har ingen sådan som
# leder till de fem - så grenen gick inte att få röd, och en gren inget prov
# kan nå säger ingenting.
gh() {
  if private_tree; then
    local gh_step="${1-} ${2-}"
    local gh_why=""
    case "$gh_step" in
      "auth login"|"auth refresh"|"auth logout")
        gh_why="skriver kontot till systemets nyckelring, som delas med jobbet.
    GH_TOKEN-arrangemanget finns för att slippa just det. Behöver du byta token:
    skriv den till ~/.claude-private/gh/token - se SKOTT.md, Så skapas token.
    Är en riktig inloggning ändå avsikten är det Tomas som gör den, med
    \`command gh\`, som går förbi den här funktionen." ;;
      "auth setup-git")
        gh_why="skriver en credential helper till den globala gitconfigen, som delas
    med jobbet. Repona går över ssh via värdalias och behöver ingen helper." ;;
      "auth token")
        gh_why="skriver den privata token i klartext, och transkriptet sparas.
    Vill du bara veta att den finns: \`test -s ~/.claude-private/gh/token\`." ;;
      "auth status")
        if (( ${argv[(I)(-t|--show-token|--show-token=*)]} )); then
          gh_why="med -t skriver den privata token i klartext, och transkriptet sparas.
    Utan -t visar den kontot och inte tokenen: \`gh auth status\`."
        fi ;;
    esac
    if [[ -n "$gh_why" ]]; then
      print -u2 "gh: \`gh $gh_step\` $gh_why"
      return 1
    fi
    local gh_token_file="$HOME/.claude-private/gh/token"
    local gh_token=""
    [[ -r "$gh_token_file" ]] && gh_token="$(<"$gh_token_file")"
    gh_token="${gh_token//[[:space:]]/}"
    if [[ -z "$gh_token" ]]; then
      print -u2 "gh: ingen privat token i $gh_token_file."
      print -u2 "    Vägrar köra, eftersom alternativet är jobbets konto."
      print -u2 "    Så skapas och skrivs en ny: ~/.claude-private/SKOTT.md, Så skapas token."
      return 1
    fi
    GH_CONFIG_DIR="$HOME/.claude-private/gh" \
    GH_HOST="github.com" \
    GH_TOKEN="$gh_token" \
      command gh "$@"
  else
    command gh "$@"
  fi
}
