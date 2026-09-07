---
name: mat-takten-inte-bara-nivan
description: "Ett tak som nås av något som växer är ingen engångsstädning - mät takten ur historiken först, annars köper åtgärden dagar"
metadata:
  type: feedback
  originSessionId: a520435d-5639-4a46-8adc-b489da824856
  scope: global
  modified: 2026-09-07T09:44:13.359Z
---

Byrå-CRM:ets `CLAUDE.md` slog i harnessets gräns på 150 000 tecken. Den självklara åtgärden var
att korta filen, och den hade varit fel svar på rätt fråga.

Två mätningar avgjorde i stället. Den första: **klipptes något bort?** Texten efter tecken
150 000 nådde kontexten, alltså var varningen en varning och ingen tyst avkortning – brådskan
var mindre än den lät. Den andra, som ändrade vad åtgärden skulle vara: **hur snabbt växer
filen?** `git show <sha>:CLAUDE.md` på sex punkter genom historiken gav 18k tecken den 16
augusti och 154k tjugoen dagar senare, alltså 6,2k om dagen. En trimning till 90k hade köpt tio
dagar.

**Why:** Nivån är symtomet, takten är orsaken, och bara den ena syns när man tittar på filen.
Ett tak som nås av något som växer varje dag är aldrig en städuppgift utan en fråga om **var ny
text hamnar** – och den frågan ställs inte av sig själv, eftersom en trimning känns som en
lösning i det ögonblick den görs. Historiken hade svaret hela tiden och kostade ett kommando att
läsa.

**How to apply:** När något slår i ett tak – en fil, en logg, en kvot, en tabell – mät två saker
innan jag åtgärdar. *Går något förlorat just nu?* avgör hur bråttom det är. *Hur snabbt närmade
det sig?*, läst ur git eller ur en tidsserie och inte gissad, avgör om åtgärden är en städning
eller en regeländring. Räkna ut hur länge den tänkta åtgärden räcker och säg den siffran högt:
"tio dagar" är det som gör att regeln också skrivs.

Regeln jag skriver är dock fortfarande bara en instruktion, och kan hoppas över precis som den
som gav [[instruktion-ar-ingen-sparr]]. Ligger det inom räckhåll att låta harnesset räkna
i stället – en hook som mäter och säger ifrån långt före taket – är det den riktiga åtgärden.

En rider som kostade fem minuter att laga: **när text flyttas mellan filer uppstår kopior.** Jag
lyfte ut ett stycke ur det som skulle arkiveras och skrev det till den nya filen, men byggde
arkivet ur originalet – alltså låg stycket i bägge. Kontrollen är att räkna förekomsterna av en
nyckelsträng i bägge filerna efteråt, inte att läsa igenom dem. Se
[[korrigera-inte-bara-komplettera]] och [[ett-fel-sitter-sallan-ensamt]].
