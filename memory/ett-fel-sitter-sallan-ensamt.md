---
name: ett-fel-sitter-sallan-ensamt
description: När jag hittat och förklarat ett fel ska jag genast leta efter samma mönster på andra ställen - annars fixar jag instansen jag råkade snubbla på
metadata:
  node_type: memory
  type: feedback
  scope: global
  originSessionId: fb4d44ef-2587-41d6-803b-254d0535d248
  modified: 2026-08-29T04:01:46.495Z
---

Ett fel jag just förstått är inte en instans utan ett **mönster**, och mönstret sitter nästan
alltid på fler ställen. Att förklara felet väl känns som att avsluta det, men förklaringen är
det som gör sökningen möjlig – jag vet först då vad jag ska greppa efter.

**Varför:** 2026-08-29 i Byrå-CRM:et lade jag till ett sjätte fält i statusradens `read` och
upptäckte att den var tabbseparerad. Tabb är IFS-blanksteg, så ett tomt fält i mitten sköt
varje senare värde ett steg åt vänster – med `effort` osatt visade raden fel siffra som effort
och tappade kontextsegmentet helt.

Det förödmjukande var inte buggen. **Exakt samma bugg var redan hittad, förklarad och
nedskriven i en kommentar tre rader längre ner i samma fil** – för cachefilen, som därför var
pipe-separerad. Någon (jag) hade skrivit ut lärdomen i klartext och sedan inte tittat på raden
ovanför. Den satt kvar i den enda rad som läser hela indatan.

Samma sak hade projektet redan lärt sig tre gånger på annat håll: ett laddningstillstånd som
saknades på tolv vyer, en radering utan konsekvens på sex, en rad som hoppade på fyra. Varje
gång var punkten skriven om **en** sida. Att det nu hände i ett bash-skript i stället för i
React är hela poängen – mönstret är inte språkbundet.

**How to apply:** I samma stund som jag kan formulera ett fel i en mening, greppa efter den
meningen. Börja i filen jag står i, som är den mest sannolika platsen och den jag är minst
benägen att söka igenom. Sök på mekanismen och inte på symptomet – `IFS=$'\t'` och inte
"statusraden visar fel". Och när jag skriver ner en lärdom i en kommentar eller i `CLAUDE.md`:
den texten är en sökterm jag själv har gett mig, så använd den innan den hinner bli arkeologi.

Skiljer sig från [[korrigera-inte-bara-komplettera]], som handlar om påståenden jag gjort som
blivit osanna. Det här handlar om ett fel som är sant på fler ställen än där jag såg det. Se
även [[gront-test-bevisar-inget-i-sig]]: mutationsprovet var det som visade att felet var
verkligt, sökningen är det som visar hur många gånger.
