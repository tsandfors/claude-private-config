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

# Privat projekt: att-gora. Villkoret sitter på katalogen och inte på
# kommandonamnet, och den skillnaden är hela omskrivningen 2026-09-05.
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
  if [[ "$PWD" == "$HOME/ts_projects/att-gora"* ]]; then
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
  if [[ "$PWD" == "$HOME/ts_projects/att-gora"* ]]; then
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
# gh flyttade medvetet *inte* till chpwd som claude gjorde 2026-09-05, och
# skälen är två. GH_TOKEN i den exporterade miljön hade legat i varje
# barnprocess i hela projektträdet i stället för i ett enda kommandos miljö, och
# en token som ligger framme är en annan sorts risk än en konfigkatalog som gör
# det. Och gh har ingen andra ingång på den här maskinen: det var två
# installationer av claude som gjorde namnvakten otillräcklig, och det finns
# inget `gh-latest`. Dyker det upp en är det här raden som ska läsas om.
gh() {
  if [[ "$PWD" == "$HOME/ts_projects/att-gora"* ]]; then
    local gh_token_file="$HOME/.claude-private/gh/token"
    if [[ ! -s "$gh_token_file" ]]; then
      print -u2 "gh: ingen privat token i $gh_token_file."
      print -u2 "    Vägrar köra, eftersom alternativet är jobbets konto."
      print -u2 "    Så skapas och skrivs en ny: att-gora/CLAUDE.md, Täta skott mot jobbet."
      return 1
    fi
    GH_CONFIG_DIR="$HOME/.claude-private/gh" \
    GH_HOST="github.com" \
    GH_TOKEN="$(<"$gh_token_file")" \
      command gh "$@"
  else
    command gh "$@"
  fi
}
