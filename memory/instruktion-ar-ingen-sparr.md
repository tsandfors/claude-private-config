---
name: instruktion-ar-ingen-sparr
description: En rutin som står i en kontextfil hoppas över förr eller senare; upprepas det ska den flyttas till harnesset i stället för att skrivas tydligare
metadata:
  type: feedback
  originSessionId: cc180170-0edd-405f-8317-e200404cdef7
  scope: global
  modified: 2026-09-04T09:00:31.188Z
---

En instruktion i en `CLAUDE.md` är en påminnelse jag kan glömma, inte en spärr. 2026-08-28
bad Byrå-CRM:ets `CLAUDE.md` varje session läsa tre filer i tur och ordning; jag läste den
ena och började svara. Det syntes bara för att Tomas frågade **"vad har du laddat?"** – utan
frågan hade sessionen fortsatt på en fjärdedel av det underlag den var tänkt att ha, och
ingenting hade sagt ifrån.

**Varför:** en regel i en lång fil konkurrerar med allt annat i samma fil, och den förlorar
just när filen är som längst – alltså när den behövs mest. Att skriva om den tydligare
flyttar ingenting; nästa session läser samma prosa med samma resultat. Skillnaden mellan en
regel som *står skriven* och en som *upprätthålls* är den mest användbara saken att förstå om
agenter, och den går att bygga: hooks, tester, typer, obligatoriska fält.

**How to apply:** Har jag brutit mot en nedskriven rutin, fråga inte "hur skriver jag den
tydligare?" utan **"kan harnesset göra det åt mig?"** SessionStart-hook för läsordning,
PreToolUse för förbud, ett test för en konvention, ett obligatoriskt fält för en etikett.
Två egenskaper gör en sådan spärr värd att lita på: den ska kunna vara **tyst** där den inte
är relevant, så att den tål att ligga globalt, och den ska **säga ifrån när den klipper eller
hoppar över något** – en tyst avkortning läses som att allt kom med.

Bevaka gränsen åt andra hållet också: en spärr som injicerar sammanhang kostar tokens i varje
session. Injicera **sektionen och inte filen** när skillnaden är 4 kB mot 65.

**Och räkna med att prosan visar sig vara fel när den ska bli en spärr.** 2026-08-30 gjordes två
förbud i samma `CLAUDE.md` till en `PreToolUse`-hook. Det ena löd *"kör aldrig pytest, python
eller manage.py direkt på värden"* – men två andra regler i samma fil **kräver** host-python: ett
python-heredoc för stora textändringar, och minnesstorens egen kontroll. En spärr byggd som
meningen stod hade brutit bägge sin första dag. En regel i prosa är ofta för brett skriven, och
**det märks aldrig så länge ingen försöker upprätthålla den** – ingen läser en instruktion och
frågar sig om den är sann i varje hörn, men en spärr tvingar fram exakt den frågan. Så första
frågan när prosa ska bli kod är inte *hur kodar jag den* utan **är den sann som den står?**

Spärren ska dessutom bevisas med en mutation, inte med gröna fall. Samma dag: 43 provfall gav noll
fel på första körningen, och åtta muterade kopior av skriptet avslöjade två riktiga buggar i det –
varav en gren som inget prov kunde nå. Se [[gront-test-bevisar-inget-i-sig]].

Det här är samma läxa som [[korrigera-inte-bara-komplettera]] slutar med – gör kontrollen
mekanisk i stället för till en vana – men upptäckt från andra hållet: där var det ett påstående
som ruttnade, här en rutin som aldrig kördes. Se även [[verifiering-hor-till-leveransen]].
