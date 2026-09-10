---
name: en-spec-ar-inte-sann-for-att-den-ar-skriven
description: "När en regel i prosa ska bli kod är första frågan om den är sann som den står, inte hur den ska implementeras"
metadata: 
  node_type: memory
  scope: global
  type: feedback
  originSessionId: 61bdd32a-1c87-4222-992d-cd47b160409c
  modified: 2026-09-09T20:38:57.361Z
---

En mening i en spec, en instruktion eller en kontextfil är ett påstående som ingen har provat.
När den ska bli kod eller en spärr är första frågan **är den sann som den står?** – inte hur
den ska implementeras. Prosa granskas aldrig av något; den läser lika rätt när den är för brett
eller för smalt skriven.

**Why:** Två gånger i samma kodbas har en skriven regel visat sig falsk först när någon försökte
upprätthålla den. *"Kör aldrig python på värden"* var för brett skrivet – två andra regler i
samma fil krävde python på värden, och en spärr byggd på meningen hade brutit bägge sin första
dag. *"Skriv och radera upprätthålls som en härledd union per resurs"* var för trubbigt – en vy
som skriver till en resurs raderar inte nödvändigtvis i den, och unionen behövde ett tak per
lånande vy för att inte dela ut raderingsrätt ingen bett om. Bägge gångerna hade felet legat
oupptäckt så länge ingen försökte koda meningen.

**How to apply:** Innan jag implementerar en skriven regel: leta upp de konkreta fallen den
påstår något om och pröva meningen mot vart och ett. Motsäger något annat i samma fil den?
Slår den ihop två saker som beter sig olika? Säg det högt och bygg det sanna, i stället för att
koda meningen och låta den bära skulden. Läxan är värd mer än instansen och hör i regeltexten
själv, på en rad.

Släkt med [[rakna-omfattningen-fore-spec]], som är samma misstro riktad mot omfattningen i
stället för mot innehållet, och med [[en-vakt-pa-namnet-tacker-inte-saken]]. Att prosan sedan
blir en spärr och inte en bön är [[instruktion-ar-ingen-sparr]].
