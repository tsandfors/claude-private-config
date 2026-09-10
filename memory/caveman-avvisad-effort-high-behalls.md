---
name: caveman-avvisad-effort-high-behalls
description: "Caveman-skillen och sänkt reasoning effort är bägge prövade 2026-09-10 och avvisade som besparing - föreslå dem inte igen utan nya siffror"
metadata:
  type: feedback
  originSessionId: f8cc2cb7-478d-4aaa-b52d-8c2fc718aa9e
  scope: global
  modified: 2026-09-10T01:25:51.671Z
---

Tomas övervägde två sätt att sänka tokenkostnaden 2026-09-10 och avvisade bägge efter mätning.
Beslutet är hans; det som står här är siffrorna som gav det, så att ingen session tar om
utredningen.

**Caveman** (`JuliusBrussee/caveman`, en skill som gör svaren telegramkorta) kapar output, och
output var 15 % av kostnaden – varav 91 % thinking, som skillen inte rör. Repot medger själv att
dess regler kostar 1–1,5k input-tokens per tur, och oberoende mätningar säger att en enrads
"fatta dig kort" tar hem det mesta. Dess `/caveman-compress`, som skriver om `CLAUDE.md` till
caveman-format, är **särskilt fel i att-gora**: filen avvisade engelsk översättning 2026-09-09
med skälet att argumenterande prosa inte går att granska efter en omskrivning, eftersom ett fel
läser precis lika rätt som originalet. En lossy komprimering har samma defekt och tar dessutom
bort skälen, som är det enda filen finns för.

**Reasoning effort `high`** (syns i statusraden ur `.effort.level`) rör bara output-posten. Halva
tankarna bort ≈ 6–7 % lägre totalkostnad. Det priset betalar för mutationsproven, sveppen efter
samma fel på fler ställen, och frågan om en regel är sann som den står – alltså precis det arbete
[[en-spec-ar-inte-sann-for-att-den-ar-skriven]] och [[gront-test-bevisar-inget-i-sig]] handlar om.

**Why:** Bägge förslagen angriper den minsta posten och betalar med det som faktiskt ger värde.
Att de känns som besparingar beror på att svarslängd är det enda man ser; kostnaden ligger i
prefixen, se [[verktygsresultat-kostar-ganger-aterstaende-turer]].

**How to apply:** Föreslå inte caveman, komprimering av `CLAUDE.md`, eller lägre effort som
kostnadsåtgärd. Vill Tomas ha kortare svar säger han det, och då räcker en instruktion. Kommer
frågan upp igen: mät om sammansättningen först – slutsatsen hänger på att output är en liten
andel, och den andelen kan ändras.
