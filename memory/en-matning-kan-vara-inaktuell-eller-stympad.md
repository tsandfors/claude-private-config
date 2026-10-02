---
name: en-matning-kan-vara-inaktuell-eller-stympad
description: "En mätning som ser avgörande ut kan vara cachad, avklippt eller tystad av behörigheter - kontrollera vad kommandot faktiskt svarar innan en hypotes stryks"
metadata:
  type: feedback
  originSessionId: 7c6cecd4-6001-499d-bcda-5e47e4b83809
  modified: 2026-09-30T08:41:41.599Z
  scope: global
---

Under en nätverksfelsökning 2026-09-30 byggde jag tre slutsatser på kommandoutdata jag hade
läst fel, och två av dem strök en riktig hypotes ur listan.

- **`arp -n <ip>` svarade med en MAC-adress**, och jag skrev att motparten "svarar på ARP,
  alltså går paket fram på länknivå – klientisolering är utesluten". Men en ARP-post är en
  **cache**. Den säger att adressen löstes ut någon gång, inte att den svarar nu. Isolering var
  fortfarande fullt möjlig.
- **`networksetup -listallhardwareports | grep -A2 "en0"`** gav `Device: en0` och
  `Ethernet Address: …`, och jag drog slutsatsen att maskinen satt på kabel. Raden som säger
  `Hardware Port: Wi-Fi` står **före** `Device:`, alltså utanför `-A2`. Interfacet var wifi hela
  tiden, och hela resonemanget om kabel-mot-trådlöst byggde på den avklippta raden.
- **`networksetup -getairportnetwork en0` sa "You are not associated with an AirPort network"**
  på ett interface som hade en fungerande adress. Det var en behörighetsartefakt – nyare macOS
  lämnar inte ut SSID utan platstjänster – och inte ett besked om anslutningen.

**Varför:** En uteslutning är dyrare än en gissning. En hypotes jag inte tänkt på kommer
tillbaka så fort mätningarna pekar dit, men en hypotes jag aktivt strukit är borta ur listan,
och ingenting påminner om den. Att jag strök rätt svar två gånger i rad kostade flera
turer i en felsökning som annars hade varit kort. Det är samma sort som
[[gront-test-bevisar-inget-i-sig]] och [[en-gron-mutation-ar-inte-ett-besked]] handlar om, en
våning ner: utdatan var sann, men den mätte inte det jag trodde.

**How to apply:** Innan en hypotes stryks på styrkan av ett kommandos utdata, ställ tre frågor
om utdatan: **är den live eller cachad** (`arp`, DNS, `ps`-liknande ögonblicksbilder, allt med
TTL), **är den hel eller beskuren** (`grep -A/-B` klipper i förhållande till träffen, och
rubrikraden ligger ofta före), och **kan den vara tyst av ett annat skäl än det jag läser in**
(behörigheter, deprecation, sandlåda). Föredra en mätning som bara kan vara sann om saken är
sann just nu – `curl`/`nc` mot en port slår `ping`, och en tom ARP-post slår en fylld. Och när
en uteslutning visar sig fel: säg det rakt och gå vidare, se
[[korrigera-inte-bara-komplettera]]. Jämför [[tystnad-ar-tvetydig]], som är samma fråga ställd
om ett uteblivet svar.
