---
name: verifiering-hor-till-leveransen
description: "Tomas förväntar sig tester som del av leveransen, och att jag säger högt när en lucka i verifieringen finns i stället för att låta den passera"
metadata: 
  type: feedback
  originSessionId: 053b15f7-c4a3-44ea-971f-bfe661272012
  modified: 2026-08-22T03:18:21.410Z
  scope: global
---

Tomas tar för givet att en implementation kommer med tester. Lika viktigt: han förväntar sig
att jag **säger ifrån själv** när jag inte har verifierat något, i stället för att låta en
rapport låta färdig.

**Varför:** 2026-08-22 levererade jag felrutan i Byrå-CRM:et med "verifierat i browsern" som
enda belägg och nämnde aldrig att jag inte skrivit ett enda test. Han frågade "Jag tar för
givet att du skrivit nya tester för det du implementerat nu?" — och svaret var nej, för
projektet hade då ingen frontend-testinfrastruktur alls. Formuleringen hade dolt en lucka jag
kände till.

Han nöjde sig inte heller med fixen utan frågade vidare om *metoden*: "hade felet kunnat
hittas via ett test som använder webbläsaren?" Han vill veta varför ett verktyg missade något,
inte bara att det är lagat. Det svaret blev mönster 6 i `GENOMGANG.md` — ett träd visar, en
fråga kastar — och var mer värt än buggen.

**How to apply:** Skriv testerna i samma svep som koden. Har jag inte gjort det, säg det i
första meningen av rapporten och varför. Redovisa vad verifieringen *inte* täcker lika tydligt
som vad den täcker. Och när ett fel slunkit igenom ett verktyg jag redan kört: undersök varför
verktyget missade det och gör om steget mekaniskt, i stället för att lova att titta noggrannare.
Se även [[utmana-oklarheter]] och [[tomas-ar-backendutvecklare]].
