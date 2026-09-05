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
# Bägge funktionerna finns i stället för alias, och skälet är detsamma för
# bägge: ett alias kräver att man minns att skriva det, och glömmer man läser
# verktyget jobbets konfiguration utan att säga ifrån.

# Privat projekt: att-gora. Står man i projektträdet används den privata
# konfigkatalogen, annars jobbets.
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
gh() {
  if [[ "$PWD" == "$HOME/ts_projects/att-gora"* ]]; then
    local gh_token_file="$HOME/.claude-private/gh/token"
    if [[ ! -s "$gh_token_file" ]]; then
      print -u2 "gh: ingen privat token i $gh_token_file."
      print -u2 "    Vägrar köra, eftersom alternativet är jobbets konto."
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
