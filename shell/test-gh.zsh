#!/bin/zsh -f
# Prov för gh() i functions.zsh: de fem nejen, det som ska gå igenom, och
# gränsen mot jobbets gh. Körs av pre-commit-hooken i githooks/, och för hand med
#
#   zsh -f ~/.claude-private/shell/test-gh.zsh
#
# Allt kör mot en påhittad HOME och ett falskt gh på PATH, som skriver ner vad
# det fick i stället för att göra något. Det riktiga gh anropas aldrig, och den
# riktiga tokenfilen läses aldrig - ett prov på en spärr kring en hemlighet får
# inte kunna läcka hemligheten det skyddar.
#
# Nejen mäts som frånvaro: det falska gh fick ingenting. Frånvaro är grön av fel
# skäl om det falska gh aldrig gick att nå, så tabellen över det som ska gå
# igenom är kvittot på att det gick - den kör i samma uppsättning, och utan den
# säger nejen ingenting.

functions_file="${0:A:h}/functions.zsh"
scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT

export HOME="$scratch/home"
export GH_TEST_LOG="$scratch/log"
export PATH="$scratch/bin:/usr/bin:/bin"
mkdir -p "$HOME/ts_projects/repo" "$HOME/annat" "$HOME/.claude-private/gh" "$scratch/bin"
token="github_pat_provtoken"
print -rn -- "$token" > "$HOME/.claude-private/gh/token"

cat > "$scratch/bin/gh" <<'STUB'
#!/bin/sh
printf 'REAL %s|TOKEN=%s\n' "$*" "${GH_TOKEN-}" >> "$GH_TEST_LOG"
STUB
chmod +x "$scratch/bin/gh"

source "$functions_file"

failures=0
cases=0
failed_cases=0
counted=-1

# Räknar fall och inte rader: ett fall som brister på två sätt är ett fall.
fail() {
  print -r -- "FEL: $1"
  (( failures++ ))
  if (( counted != cases )); then
    (( failed_cases++ ))
    counted=$cases
  fi
}

# Kör ett gh-kommando i en underprocess och lämnar utfallet i rc, err och log.
attempt() {
  : > "$GH_TEST_LOG"
  err="$( { eval "$1" } 2>&1 >/dev/null )"
  rc=$?
  log="$(<"$GH_TEST_LOG")"
  (( cases++ ))
}

cd "$HOME/ts_projects/repo"

# Nejen, och vad varje nej ska peka på. Tre skäl, tre åtgärder.
refused=(
  "gh auth login"                              "gh/token"
  "gh auth login --hostname github.com --web"  "gh/token"
  "gh auth refresh --scopes repo"              "gh/token"
  "gh auth logout"                             "gh/token"
  "gh auth setup-git"                          "ssh"
  "gh auth token"                              "test -s"
  'x=$(gh auth token)'                         "test -s"
  'eval "gh auth token"'                       "test -s"
  'true && gh auth setup-git'                  "ssh"
)
for command advice in "${refused[@]}"; do
  attempt "$command"
  (( rc != 0 )) || fail "släpptes igenom: $command"
  [[ -z "$log" ]] || fail "nådde gh: $command -> $log"
  [[ "$err" == *"$advice"* ]] || fail "nejet saknar '$advice': $command -> $err"
done

# Det gh är isolerat *för*. Varje rad ska nå det falska gh, med token.
allowed=(
  "gh pr list --state open"
  "gh pr create --draft --fill"
  "gh auth status"
  "gh api /user"
  "gh run view --log"
  "gh --version"
)
for command in "${allowed[@]}"; do
  attempt "$command"
  expected="REAL ${command#gh }|TOKEN=$token"
  (( rc == 0 )) || fail "nekades: $command -> $err"
  [[ "$log" == "$expected" ]] || fail "fel anrop: $command -> '$log', väntat '$expected'"
done

# Utanför trädet är gh jobbets, och funktionen ska inte ha någon åsikt alls:
# varken nej eller token.
cd "$HOME/annat"
attempt "gh auth token"
(( rc == 0 )) || fail "nekades utanför trädet: $err"
[[ "$log" == "REAL auth token|TOKEN=" ]] || fail "fel anrop utanför trädet: '$log'"

# En token som bara är en radbrytning är ingen token. Felet 2026-09-06.
cd "$HOME/ts_projects/repo"
print > "$HOME/.claude-private/gh/token"
attempt "gh pr list"
(( rc != 0 )) || fail "en tom token släpptes igenom"
[[ -z "$log" ]] || fail "en tom token nådde gh: $log"
[[ "$err" == *"SKOTT.md"* ]] || fail "vägran pekar inte på SKOTT.md: $err"

if (( failures )); then
  print -r -- "gh-test: $failed_cases av $cases fall FAILED"
  exit 1
fi
print -r -- "gh-test: $cases fall, alla gröna"
