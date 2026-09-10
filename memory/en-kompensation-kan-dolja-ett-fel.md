---
name: en-kompensation-kan-dolja-ett-fel
description: "Klampningar, golv och toleranser döljer fel lika gärna som de rättar dem - fråga vad raden skulle maskera om något annat gick sönder"
metadata: 
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 63310fb9-d8c0-488a-8e1d-d96e5545d2ef
  modified: 2026-09-10T01:08:03.355Z
---

En rad som kompenserar för något – en klampning, ett golv, en uppräkning, en tolerans – gör två
saker samtidigt. Den rättar det den skrevs för, och den **döljer allt annat som råkar hamna inom
samma marginal**. Den andra halvan står aldrig i kommentaren.

**Varför:** 2026-09-06 i Byrå-CRM:et. Seedern byggde säljplanen innan de accepterade offerterna
hunnit skapa sina affärer, så en affär på 49 000 stod utan mål bakom sig. Felet fanns från
första dagen och var osynligt i tre veckor, för affären låg i den *pågående* perioden – vars mål
räknas upp med `1/gone`, klampat till minst 0,4, alltså upp till 2,5 gånger. Ett mål som blåsts
upp 2,5 gånger sväljer en oplanerad affär utan att kvoten rör sig ur sina gränser.

Det som avslöjade det var inte en ändring i koden utan **att kalendern gick vidare**: sex dagar
in i ett nytt bokslutsår föll samma affär in i ett *avslutat* år, där målet är en rak faktor utan
uppräkning, och kvoten slog i 1,69 mot taket 1,5.

Två följdsatser är värda lika mycket som fyndet:

- **Ett test som blir rött av att tiden går är inte ett flakigt test.** Första impulsen var att
  datan "åldrats" och att gränsen borde vidgas. Det hade tagit bort mätaren och lämnat felet.
- **Marginalen avgör vad ett test kan se.** Ett prov som bara körs i det läge där kompensationen
  är aktiv kan aldrig fälla något som ryms i den. Regressionstestet fick därför datum strax
  efter ett årsskifte, alltså i det läge där uppräkningen *inte* gäller.

**Samma form, andra skepnaden – två skydd där det ena maskerar det andra.** 2026-09-10 i samma
repo: en borttagen medlem fick både `is_active = False` och sin token raderad. Mutationsprovet
som strök *tokenraderingen* blev **grönt**, för `is_active` ensamt räcker för att DRF ska neka.
Raden var alltså omätt, och en omätt rad är inte ett skydd utan en förhoppning. Provet som mäter
den måste stänga av det maskerande skyddet – här: öppna kontot igen, vilket är precis vad
Djangos admin gör. Klampningen och det dubbla skyddet är samma fråga ställd två gånger: **vad
finns det för läge där just den här raden är den enda som håller?**

**How to apply:** När jag skriver eller läser en rad som kompenserar – `max(...)`, ett golv, en
klampning, en generös tolerans i en assert – ställ frågan *vad skulle den här raden dölja om
något annat gick sönder?*, och se till att minst ett prov körs i läget där kompensationen inte
är aktiv. När ett test börjar falla av sig självt utan att koden ändrats: misstänk att något
slutat vara dolt, innan jag misstänker att testet är för strikt. Se även
[[gront-test-bevisar-inget-i-sig]] och [[tystnad-ar-tvetydig]], som är samma tanke om prov
respektive larm.
