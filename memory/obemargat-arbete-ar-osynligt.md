---
name: obemargat-arbete-ar-osynligt
description: Fråga vad som redan är gjort innan jag gör om det - obemärgade brancher syns inte i något vanligt tecken
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 63310fb9-d8c0-488a-8e1d-d96e5545d2ef
  modified: 2026-09-05T23:07:52.315Z
---

Innan jag börjar arbeta i ett repo, och särskilt innan jag skriver om dokumentation eller
"rättar" något som ser inaktuellt ut: **`git branch -a --no-merged main`**. Finns det arbete som
aldrig kom in, är det förmodligen om just det jag är på väg att göra.

**Varför:** 2026-09-06 i Byrå-CRM:et. Jag committade fyra gånger rakt på `main` och pushade,
utan att någon gång fråga om det fanns obemärgat arbete. Det fanns: två brancher, pushade till
origin dagen innan, och den ena bar hela den `CLAUDE.md`-text jag ägnat sessionen åt att skriva
om från grunden — inklusive en varning jag presenterade som mitt eget påpekande. Priset blev
dubbelt arbete och en konflikt i prosa som fick lösas för hand, mening för mening.

**Det som gör felet svårt är att frånvaron inte har någon representation.** `git status` var
ren, arbetsträdet aktuellt, filen jag redigerade såg ut som den senaste versionen — inget av de
tecken jag rutinmässigt läser nämner en branch. Ingenting *såg* fel ut, för det som saknades
syntes inte. Samma form som [[tystnad-ar-tvetydig]]: tystnad kan betyda att allt är bra eller
att ingen frågade.

En worktree-katalog i trädet är ett tecken i sig. Den betyder att någon arbetat parallellt, och
den säger ingenting om huruvida det arbetet kom in.

**How to apply:** Kör svepet när jag kommer in i ett repo jag inte precis lämnat, och alltid
innan jag skriver om ett dokument. Hittar jag en branch: läs dess commit-meddelanden innan jag
skriver en rad, för de säger vad någon redan tänkt. Och när jag *själv* lämnar arbete på en
branch — se till att det antingen slås ihop eller nämns där nästa session tittar, annars är det
osynligt på precis samma sätt. Släkt med [[korrigera-inte-bara-komplettera]], som handlar om
motsägelser inuti en fil; det här är motsägelser mellan brancher.
