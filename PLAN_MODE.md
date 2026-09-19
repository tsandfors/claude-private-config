# Plan mode: varför föreslås det så sällan?

En instruktion till en framtida session. Skriven 2026-09-19 av den session som fick frågan,
på Tomas begäran, för att han vill utforska den separat.

**Läs hela filen innan du svarar honom.** Den bär dels frågan, dels en mätning som redan är
gjord, dels två fällor som gör att en oförsiktig session kommer att svara fel med stor
säkerhet. Den andra fällan förstör dessutom mätdatan medan man mäter.

---

## 1. Frågan, som Tomas ställde den

Ordagrant, 2026-09-19, mitt i en session om ett annat ämne:

> *"du fråga aldrig om jag vill gå in i Plan mode längre, är det medvetet, då du tror att du kan
> lösa problemet själv, eller vad är orsaken till att du inte rekommenderar plan mode lika ofta
> numera? Är det din nya modell, eller vad beror det på?"*

Frågan rymmer tre olika frågor, och de har olika svarbarhet:

1. **Har beteendet ändrats?** Empirisk, och delvis mätbar. Se avsnitt 4.
2. **Varför?** Här ligger fällan. Se avsnitt 3.
3. **Vad borde gälla i stället?** Normativ, och den enda som ger något oavsett hur 1 och 2
   utfaller. Se avsnitt 6. **Om tiden är knapp, börja här.**

## 2. Vad som utlöste den

Sessionen 2026-09-19 (`8f8dbf6c-c26b-49af-9781-6c22cd683b80`) var en lång kedja av små,
självavgränsade uppgifter i `~/ts_projects/att-gora`: felsöka en container som inte startade,
låsa en Docker-tagg, skriva om ett README-steg, föra in en backloggpunkt. Plan mode
föreslogs inte en enda gång.

Det svar han fick, och som du inte behöver upprepa:

- Det var **inte** ett medvetet omdöme om att planering var onödig.
- Sessionen bestod av uppgifter där arbetet var mindre än planen hade varit.
- Repot har dessutom en **egen grind** – `CLAUDE.md` kräver att commit-meddelandet visas och
  godkänns före varje commit – och den har gjort en del av plan modes jobb. **Men grinden sitter
  efter arbetet och planen före.** Ett godkänt commit-meddelande betyder att koden redan är
  skriven; en godkänd plan betyder att den inte är det. Den skillnaden är sannolikt kärnan i
  hela frågan.
- Direkt efter utbytet kom en uppgift som *var* plan-mode-format – en ny modell, en migration,
  ett undantag från appens hårdaste regel, en endpoint, en frontend-ändring och tester – och
  då föreslogs det. Tomas hade alltså rätt i sak, och i rätt ögonblick.

## 3. Fälla ett: du kan inte introspektera på det här

**Du kan inte jämföra dig med en tidigare modellversion.** Du har ingen tillgång till hur en
annan version hade betett sig, inga minnen från dess sessioner som *upplevelser*, och ingen
förmåga att läsa av dina egna böjelser. Frågan *"är det din nya modell?"* är därför inte
besvarbar inifrån.

Frestelsen är stor att svara ändå, eftersom en kausal historia låter hjälpsam och är lätt att
formulera. **Gör inte det.** Säg att du inte kan verifiera det, och gå till det som går att
mäta. Tomas har uttryckligen sagt att han hellre får ett ärligt *"jag vet inte"* än en gissning
klädd som förklaring – se minnet `utmana-oklarheter`.

Det som *går* att säga inifrån är vad du gjorde i den session du sitter i, och varför, om den
finns i din kontext. Allt bortom det är arkivforskning, inte introspektion.

## 4. Mätningen som redan är gjord – och fälla två

Transkripten ligger i `~/.claude-private/projects/<sökväg-med-bindestreck>/<uuid>.jsonl`, en fil
per session. 2026-09-19 fanns 60 stycken, från 2026-08-19 och framåt.

**Fälla två: en naiv ordräkning mäter systemprompten, inte beteendet.** Nästan varje
transkript innehåller strängarna `EnterPlanMode` och `ExitPlanMode`, eftersom verktygslistan
står i varje sessions systemprompt. En räkning på bara ordet ger en falsk baslinje på ungefär
`Enter=2 Exit=4` per session, vilket ser ut som jämn användning och inte är någon användning
alls.

Räkna på JSON-nyckeln i stället:

```bash
cd ~/.claude-private/projects
grep -rl '"name":"EnterPlanMode"' .
```

**Resultatet 2026-09-19: exakt en session hade faktiska anrop** – `33e87f81-2d90-4a7a-af3e-
eb47997b389a`, daterad 2026-09-12, med 2 `EnterPlanMode` och 2 `ExitPlanMode`. Det var
demostacksbygget, alltså sessionens största och mest arkitektoniska uppgift under hela perioden.

**Det vänder på frågan.** Plan mode har inte "slutat" föreslås – det har använts i **en av 59**
sessioner, och i just den som var störst. Perceptionen att det skett en förändring kan alltså
inte bekräftas av verktygsanropen. Det betyder inte att Tomas har fel; se nästa avsnitt.

**Och fälla två har en andra hälft, som är värre: att mäta förorenar datan.** Ett
`grep '"name":"EnterPlanMode"'` skriver strängen `"name":"EnterPlanMode"` i transkriptet, som
en del av kommandot. Sessionen som utför mätningen ser därför ut att ha anropat verktyget.
Sessionen 2026-09-19 är av precis det skälet obrukbar som datapunkt om sig själv. **Uteslut den
session du sitter i, och varje session där någon har undersökt det här.** Samma mönster som
minnet `dokumentationen-av-en-sanering-lacker` beskriver: att beskriva en sträng återinför den.

## 5. Det som gör frågan svår att mäta alls

**Det intressanta beteendet lämnar inget strukturerat spår.** Ett *anrop* av `EnterPlanMode`
syns i JSON. Ett *förslag* – "ska jag gå in i plan mode för det här?" – är löptext i ett
assistentmeddelande, och ett uteblivet förslag lämnar ingenting alls. Frånvaro har ingen
representation, vilket minnet `franvaro-behover-ett-positivt-kvitto` handlar om.

Vill du mäta förslag måste du söka i textinnehållet, och då behöver du en definition som håller:
på svenska och engelska, med och utan verktygsnamnet, inklusive omskrivningar som *"vill du att
jag lägger upp en plan först"*. Räkna dem **per session och mot uppgiftens storlek**, annars
mäter du hur många sessioner som var stora och inte hur ofta förslaget kom när det borde.

Nämnaren är det svåraste. Ett rimligt mått på "borde": sessioner där det som slutligen
committades rörde fler än en fil eller fler än ett lager. Det går att läsa ur git-historiken i
`~/ts_projects/att-gora` och korsa mot sessionsdatum.

## 6. Hypoteser, som konkurrerande och inte som slutsats

- **H1 – uppgiftsformen.** Perioden efter 2026-09-12 bestod av små, sekventiella uppgifter.
  Plan mode föreslogs inte för att det sällan passade. *Motprov:* fanns det stora uppgifter
  under perioden som ändå gick utan plan? Sessionen 2026-09-11 (rollerna, del 4) är en kandidat.
- **H2 – repots egen grind konkurrerar ut den.** Kravet att visa commit-meddelandet ger en
  känsla av att beslutspunkter redan finns, så planen känns som en dubblering. *Motprov:*
  används plan mode oftare i privata repon **utan** den regeln? Det finns bara ett privat repo i
  dag, vilket gör motprovet omöjligt just nu – notera det hellre än att ignorera det.
- **H3 – användarens egen ton.** Tomas prompter i den här perioden är ofta imperativ och korta:
  *"Ja laga"*, *"commit och push"*, *"Ändra det i README.md!"* En sådan formulering inbjuder till
  handling, inte till planering. *Motprov:* jämför prompternas form mot sessioner där plan mode
  användes.
- **H4 – modellbyte eller harnessändring.** Kan inte prövas inifrån, men *kan* prövas utifrån:
  transkripten bär modellnamn. Korsa modellversion mot förslagsfrekvens. **Det är det enda
  hederliga sättet att svara på hans fråga om modellen**, och det är arkivarbete och inte
  självkännedom.

## 7. Det som gäller oavsett svaret

Det här är den del som är värd något även om orsaksfrågan förblir öppen, och den vilar på en
regel Tomas redan formulerat i minnet `instruktion-ar-ingen-sparr`:

> En bruten rutin flyttas till harnesset, inte skrivs om tydligare.

**Att jag "brukar beskriva upplägget först" är en instruktion jag ger mig själv, och den håller
tills den inte gör det. Plan mode är spärren.** Frågan är därför inte främst *varför slutade
det* utan **vad som skulle få det att ske av sig självt**. Uppslag att pröva, och de är uppslag
och inte beslut – Tomas väljer, se `mina-uppslag-rankas-inte`:

- ett kriterium skrivet i klartext, till exempel *rör uppgiften fler än ett lager, eller en regel
  som står under Hårda krav, så föreslås plan mode innan första redigeringen*
- en `UserPromptSubmit`-hook som påminner när prompten innehåller ord som *bygg*, *lägg till*,
  *ny modell*
- eller slutsatsen att det inte behövs, om mätningen visar att uppgifterna faktiskt var små –
  vilket är ett fullgott utfall och ska sägas rakt ut i så fall

## 8. Pekare

| Vad | Var |
|---|---|
| Transkript | `~/.claude-private/projects/<sökväg>/<uuid>.jsonl` |
| Sessionen som utlöste frågan | `8f8dbf6c-…` (2026-09-19) – **förorenad, se 4** |
| Enda sessionen med verkliga anrop | `33e87f81-…` (2026-09-12), demostacken |
| Repots commit-grind | `CLAUDE.md` → *Arbetssätt* i `~/ts_projects/att-gora` |
| Relevanta minnen | `instruktion-ar-ingen-sparr`, `utmana-oklarheter`, `franvaro-behover-ett-positivt-kvitto`, `dokumentationen-av-en-sanering-lacker`, `mina-uppslag-rankas-inte` |

**Filen ligger här och inte i `att-gora`** enligt undantagstestet i repots `CLAUDE.md`: frågan
gäller hur jag arbetar i varje privat session, inte den appen. Den hör därmed hemma i
konfigrepot, bredvid `SKOTT.md`, och är versionerad där.
