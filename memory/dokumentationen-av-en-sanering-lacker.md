---
name: dokumentationen-av-en-sanering-lacker
description: När jag skriver ner varför något togs bort skriver jag ofta in det igen; kontrollen ska köras på det jag lägger till, inte bara på det jag städat
metadata:
  node_type: memory
  type: feedback
  scope: global
  originSessionId: fb4d44ef-2587-41d6-803b-254d0535d248
  modified: 2026-08-29T04:41:07.524Z
---

Att ta bort en sträng och att **beskriva** att man tagit bort den är två handlingar, och den
andra återinför den. Det låter för dumt för att hända och hände två gånger på en dag.

**Varför:** 2026-08-29 skulle jobbets GitHub-värd bort ur privata repon. Jag ersatte den överallt
– och skrev sedan, i två olika filer i två olika repon, meningar av formen *"filen var utelämnad
för att den namngav `<strängen>` i klartext"*. Bägge gångerna var det min egen dokumentation av
saneringen som var den enda kvarvarande förekomsten.

Mekanismen är värd att förstå, för den är inte slarv. När jag städar växlar jag till ett läge där
strängen är **ämnet** jag skriver om i stället för data jag hanterar, och i det läget känns det
naturligt att citera den exakt – det är ju precis vad noggrann dokumentation ser ut som. Samma
reflex som gör en bra commit-text gör läckan.

Det som fångade det var att den negativa kontrollen kördes på **den staged diffen** och inte på
arbetsträdet. Ett `git grep` i arbetsträdet hade sagt "rent" om allt utom den nyskrivna raden,
och den raden var min egen – alltså den enda plats jag inte misstänkte.

**How to apply:** Kör saneringskontrollen på **det som är på väg in**, inte bara på det som
städats: `git diff --cached | grep -E '<strängarna>'` före varje commit i en sanering, och inte
`git grep`, som mäter ett tillstånd i stället för en förändring. När jag skriver *varför* något
togs bort: beskriv strängen i stället för att citera den – "jobbets GitHub Enterprise-värd", inte
värden. Och misstänk särskilt commit-meddelanden, README-avsnitt och statusrapporter, som alla är
texter vars kvalitet mäts i hur konkreta de är.

Nära [[backup-svarar-inte-pa-vad-som-blev-kvar]], men spegelvänt: det minnet handlar om vad som
blev **kvar** efter en städning, det här om vad jag **lade till** under den. Se även
[[ett-fel-sitter-sallan-ensamt]] – samma dag, och det var det breda svepet som över huvud taget
visade hur många ställen som behövde röras.
