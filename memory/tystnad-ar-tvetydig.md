---
name: tystnad-ar-tvetydig
description: "En kontroll säger inget om sig själv - fråga vad den jämför mot, för både evig tystnad och evigt larm ser ut som ett fungerande larm"
metadata:
  type: feedback
  originSessionId: 8479b2bf-2f82-476a-a176-e980b20e9f77
  scope: global
  modified: 2026-09-06T21:00:00.000Z
---

Jag byggde 2026-08-28 ett statusradssegment som skulle säga till när en nyare Claude Code
fanns. Det frågade Homebrew, som beställt, och var tyst. Jag rapporterade tystnaden som ett
kvitto: *"du kör senaste, därför syns inget."* Tomas invände att senaste releasen var en annan,
och han hade rätt.

**Rättelsen jag gjorde var också fel, och det är den intressanta halvan.** Jag bytte till
GitHubs senaste release – men det visade sig finnas två utgivningskanaler, `stable` och
`latest`, och GitHub visar den senare. Mot en stable-installation hade segmentet lyst
permanent. Först tyst i alla lägen, sedan tänt i alla lägen; bägge gångerna såg det ut att
fungera.

**Why:** Ett larm rapporterar aldrig vad det jämför mot. Både *inget att säga* och *jag tittar
på fel ställe* ger tystnad, och både *något är fel* och *jag jämför mot fel måttstock* ger
larm. Ingen av de fyra går att skilja åt utifrån. Samma fel som
[[backup-svarar-inte-pa-vad-som-blev-kvar]], där fel sida av en städning mättes.

**Samma fråga ställdes igen 2026-09-05, och jag svarade fel på ett tredje sätt.** Tomas
undrade vad som var nytt i senaste Claude Code. Jag körde `claude --version`, fick `2.1.236`,
och räknade upp allt han *saknade* – när han i själva verket körde `2.1.261`. Kommandot svarade
för vad `PATH` pekar på; den körande processen var en annan binär. Måttstocken var alltså inte
fel den här gången, **objektet var det**: mätningen rörde vid en annan sak än frågan gällde,
och svaret såg lika auktoritativt ut ändå. Processträdet gav facit på en rad.

**Och 2026-09-06 visade sig segmentet fortfarande mäta fel installation.** Tomas fick ett
meddelande om att `claude-latest` uppdaterats; statusradens cache stod på
`2.1.236|2.1.236|2.1.236`, alltså allt lika och därför tyst. Skriptet läser
`brew list --cask claude-code`, vilket är homebrews binär – medan den han faktiskt startar,
`~/bin/claude-latest` → `~/.local/bin/claude`, stod på `2.1.263`. Segmentet kan **strukturellt
inte** rapportera om den kanal han kör: det jämför rätt måttstock mot fel objekt, alltså exakt
felet stycket ovan beskriver, en gång till.

Det nya var inte felet utan att **läxan var nedskriven två gånger och koden ändå inte
rättades.** Bägge tidigare instanserna slutade i en förklaring, inte i en ändring. Skriptet bar
till och med en kommentar – *"byt installationskanal och den här raden är det som måste följa
med"* – och kanalen hade redan bytts när den skrevs. **En kommentar som säger "ändra den här
raden om X" är ingen spärr.**

**Lagat samma kväll**, sedan Tomas invände mot att jag antecknade buggen i stället för att fixa
den. Referenspunkten är nu `$VERSION` ur harnessets stdin, alltså den körande versionen;
skriptet rapporterar båda kanalerna och statusraden härleder vilken som gäller ur datan, för en
version över stable kan bara komma från latest. Åtta fall och fyra mutationer körda för hand.

**How to apply:** Fråga aldrig *fungerar kontrollen* utan **vad jämför den mot, vilket objekt
rör den faktiskt vid, och är det samma sak jag bryr mig om**. Verifiera måttstocken mot något oberoende innan ett resultat
rapporteras – särskilt när källan är känd för att ha kanaler, speglar eller cachar. När ett
larm bara syns vid fel: skriv i koden att dess tystnad inte är ett kvitto, annars läser nästa
läsare den så. Se även [[verifiering-hor-till-leveransen]] och [[utmana-oklarheter]].
