---
name: ett-tomt-lage-kan-vara-anvandarens-vanliga
description: Ett villkor som döljer en funktion när underlaget saknas kan dölja den för den riktiga användaren; mät hennes data innan villkoret byggs
metadata:
  node_type: memory
  scope: global
  type: feedback
  originSessionId: c0693f7c-5ceb-4fb9-a1e3-0fbf176ab3ae
  modified: 2026-10-13T21:27:37.077Z
---

Ett tomt läge som döljer en funktion ("inget mål, alltså inget kort") är rätt mot demodatan och kan ändå vara den riktiga användarens vanliga läge. Mät därför vad den riktiga datan innehåller innan villkoret byggs, och fråga vad användaren då ser i stället.

**Why:** 2026-10-13 byggde jag periodmålets uppmuntrande text så att den bara syns när perioden har ett mål i kronor, med avsikt för att inte berömma ett mål som inte finns. Beställaren rapporterade samma kväll att texten inte syntes alls. Hennes säljplan på demon var bara i antal, 309 st och 0 kr i P1, så hela funktionen var osynlig för den enda som bett om den. Demodatan har alltid belopp och visade aldrig det läget.

**How to apply:** När en ny funktion har en gren som döljer den, räkna hur den riktiga användarens data ser ut, inte bara demodatans. Om den grenen är hennes normalläge ska det tomma läget peka mot nästa steg i stället för att tiga. Se [[en-nolla-som-ser-uppmatt-ut]] och [[beromet-ar-funktion]]. På demon får jag inte läsa själv, se [[demomaskinen]].
