---
name: en-uppdelning-gar-att-granska
description: "När text ska krympas: flytta hela stycken oförändrade i stället för att formulera om, för en omskrivning av resonerande prosa går inte att granska"
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 8309c397-54f3-49b6-a685-1a0a01352b78
  modified: 2026-09-11T20:51:58.510Z
---

Ska en lång text kortas, gör det som en **uppdelning** och inte som en omskrivning: varje stycke
står antingen kvar oförändrat eller flyttar oförändrat. Då är hela ändringen en partition som
går att läsa rad för rad i en diff.

**Varför:** i `att-gora` skulle `CLAUDE.md` ner i storlek, och den största sektionen var 22 % av
filen. Frestelsen var att komprimera den – men filen säger själv om sig själv att den är
argumenterande prosa där **ett fel läser precis lika rätt som originalet**. En komprimering går
alltså inte att granska genom att läsa; bara genom att jämföra varje påstående mot koden. En
flytt går att granska på en minut. Jag plockade dessutom ut de stycken som skulle stanna
**programmatiskt** ur blocket, så att inget kunde bli omformulerat på vägen.

**How to apply:** när jag städar dokumentation, fråga först *vad kan flyttas helt?* och först
därefter *vad måste skrivas om?* – och gör de två i olika commits om bägge behövs. Två saker att
avgöra före flytten: vad i texten **binder framtida arbete** (det ska stanna där det läses) och
vad som bara **berättar hur det blev så** (det kan flytta). Och lämna arkivkopian *hel*, även om
några stycken därmed finns i två filer – säg i stället ut vilken av dem som är den levande.
Släkt med [[korrigera-inte-bara-komplettera]].
