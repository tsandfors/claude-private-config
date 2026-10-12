---
name: roblocks
description: "Äggön, Roblox-husdjurssimulatorn i ~/ts_projects/roblocks (tsandfors/aggon) – Rojo + Lune, scripts/check.sh, sonen testar dist/Aggon.rbxl på Windows, och balansbesluten med siffrorna"
metadata:
  node_type: memory
  type: project
  scope: roblocks
  originSessionId: 20abbf4f-a53f-41a2-91a4-450f3ed9ad24
  modified: 2026-10-12T18:14:52.980Z
---

Byggt 2026-10-12, i en enda session som **gick på jobbets konfiguration** – chpwd-villkoret
täckte då bara att-gora. Transkriptet är flyttat till `~/.claude-private/projects/`, planen
till `~/.claude-private/plans/zesty-wishing-gosling.md`. Repots `CLAUDE.md` skrevs av den sessionen som överlämning, okommittad 2026-10-12.
Spelet heter **Äggön**, repot `tsandfors/aggon`, remoten går genom värdaliaset
`github-attgora` och `user.email` är repo-lokal – samma arrangemang som att-gora.

**Verktygen.** Rojo synkar `src/` till Studio enligt `default.project.json`. Lune kör
Luau-testerna lokalt utan Studio (`lune run tests/run`), StyLua och Selene formaterar och
lintar, och luau-lsp typkollar. Versionerna står i `rokit.toml` och ligger i `~/.rokit/bin`.
ProfileStore är vendrad i `src/server/Packages/`; Wally fanns i planen men används inte.

**`scripts/check.sh` är grinden**, fem steg: stylua, selene, Lune-testerna, luau-lsp och ett
`rojo build`. Den hämtar `globalTypes.None.d.luau` över nätet första gången. Testerna täcker
bara den rena logiken i `src/shared/Logic` – kartan, gränssnittet och sparningen syns först i
Studio, och **spelet har aldrig körts i Studio** när det här skrevs.

**Testningen sker hos Tomas son, på hans Windows-maskin som redan har Roblox Studio.** Studio
installeras inte på den här datorn, Tomas val. Han får `dist/Aggon.rbxl` – byggd med
`rojo build -o dist/Aggon.rbxl` – och `TESTA.md`, som är en checklista skriven för ett barn.
`dist/` är gitignorerad, så filen följer **inte** med en `git pull`: den måste byggas om och
skickas över för hand efter varje ändring. Han ska inte spara egna ändringar i filen i Studio,
för nästa version skriver över dem. Som fristående fil sparar spelet ingenting mellan
testerna, och det står i `TESTA.md` som avsiktligt. Fynd kommer tillbaka som ✅/❌ och
skärmbilder från *View → Output*.

**Balansbesluten.** Målgruppen är barn 8–12, och målet satt till **8–15 timmars spel till
första rebirth**. Med planens startvärden kom rebirth efter 12 minuter. Elva config-ändringar,
framtagna med `lune run tools/simulate` och godkända av Tomas, plus två beslut ovanpå:

- **Rebirth-kravet är 400 miljarder mynt *intjänade sedan förra rebirth*,** inte sparade – man
  kan fortsätta köpa under tiden, och längsta sträckan utan köp gick från 1,5 h till 11 min.
  400 miljarder är taket: högre gav döda sträckor på 1–2 h. Med 30 min spel om dagen ger det
  Kristallgrottan efter 32 min (dag 2), Molnriket efter 3 h (dag 7) och första rebirth efter
  7,5–8,5 h (dag ~15), som längst 6 min utan något att köpa.
- **Kravet växer inte mellan rebirths**, Tomas val, så rebirth 2 och 3 kommer ungefär en timme
  isär. Flaggat som det första att ändra om det känns för snabbt i speltestet.

Siffrorna bor i `src/shared/Config/` (`Economy.luau` m.fl.). Kostnads- och rebirth-testerna
har egna fasta siffror och provar formlerna, inte balansen – **balansen provas bara av
simulatorn**, så en ändring i config ska köras genom den.

Gamepasses har id `0` och visas som *Kommer snart* tills Tomas skapat dem på
create.roblox.com. Äggen säljs bara för mynt, aldrig för Robux, för att slippa Robloxs regler
om betalda slumplådor.

**Det gamla transkriptet är ett arkiv och ingen startpunkt.** Det bär jobbets `CLAUDE.md` och
minnesindex som kontext, så en session som återupptar det (`claude --resume bda862b0…`) läser
jobbets regler som sin egen historik. Börja nya sessioner från repots `CLAUDE.md`, skriven av
den gamla sessionen som överlämning, och exportera inte transkriptet rakt av till Obsidian.
Se SKOTT.md.
