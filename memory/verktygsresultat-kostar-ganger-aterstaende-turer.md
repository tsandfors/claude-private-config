---
name: verktygsresultat-kostar-ganger-aterstaende-turer
description: "Ett stort verktygsresultat betalas inte en gång utan en gång per återstående tur i sessionen - attackera medelkontexten, inte svarslängden"
metadata:
  type: feedback
  originSessionId: f8cc2cb7-478d-4aaa-b52d-8c2fc718aa9e
  scope: global
  modified: 2026-09-10T01:25:30.277Z
---

Tomas frågade vad som driver tokenkostnaden och om det var mina utskrivna diffar. Svaret föll ut
av en mätning över tolv sessioners JSONL i `~/.claude-private/projects/<repo>/`, där varje
assistent-meddelande bär ett `usage`-block:

| post | tokens | andel av kostnaden |
|---|---|---|
| cache-läsning (0,1×) | 341 640 000 | 56 % |
| cache-skrivning (1,25×) | 13 807 000 | 28 % |
| output inkl. thinking (5×) | 1 867 000 | 15 % |

341 miljoner cache-läsningar delat på 1 929 turer är **177 000 tokens genomsnittlig kontext per
tur**.

**Why:** Kontexten är en prefix som läses om vid *varje* tur. Alltså betalas ett verktygsresultat
en gång som cache-skrivning och sedan en gång per återstående tur som cache-läsning. En
Playwright-snapshot på 20k tokens i tur 5 av 100 kostar 20k×1,25 + 20k×0,1×95, alltså tio gånger
mer i läsningar än i skrivningen. Intuitionen säger tvärtom – att ett resultat kostar när det
uppstår – och den intuitionen får en att optimera svarslängden, som här var 15 % av kostnaden och
till 91 % bestod av thinking. Att korta *prosan* är att såga i den minsta posten.

**How to apply:** När kostnad eller kontextfyllnad kommer på tal: mät `usage` ur sessionens JSONL
innan jag föreslår något, och räkna **medelkontext per tur** (cache-läsning delat på antal turer).
Är den hög är åtgärden färre och kortare sessioner – `/clear` när ett arbetsstycke är klart, dyra
verktyg som browsergenomgångar i egen session – plus riktade läsningar i stället för hela filer.
Föreslå inte kortare svar eller lägre reasoning effort som besparing utan att först ha vägt
output-posten mot de andra två; se [[caveman-avvisad-effort-high-behalls]].

Samma sort som [[mat-takten-inte-bara-nivan]]: det synliga talet är inte det som driver, och
skillnaden syns bara om man mäter i stället för att titta.
