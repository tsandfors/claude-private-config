---
name: frun-nar-inte-demon
description: "Tomas fru har ett superanvändarkonto på demon men hennes MacBook når inte 192.168.50.120:8080 - felet är oläst, misstanken är AP-isolering per radio i routern"
metadata:
  type: project
  originSessionId: 7c6cecd4-6001-499d-bcda-5e47e4b83809
  modified: 2026-09-30T08:41:13.561Z
  scope: att-gora
---

Tomas gav sin fru tillgång till demostacken 2026-09-27. **Hon ska räknas som han** – hans
uttryckliga ord, upprepade efter att jag invänt en gång: hon ska kunna testa allt,
superanvändaren inräknad. Invändningen är därmed avförd och ska inte tas upp igen.

Kontot heter **`pennan`** och skapades på demomaskinen med `createsuperuser` följt av
`seed_demo --user pennan --password <samma>`. Ordningen spelar roll: `createsuperuser` vägrar
ett befintligt användarnamn medan `seed_demo` tar ett utan att blinka, och `_account`
(`crm/management/commands/seed_demo.py:215`) sätter om lösenordet – ett annat lösenord i steg
två skriver tyst över det man just valde. Lösenordet står inte här; Tomas valde det själv och
det går att sätta om med `yarn demo:manage changepassword pennan`.

Superanvändarskapet räcker hela vägen: `unbound_superuser` kortsluter både grinden och
`CompanyAdmin` (`app/permissions.py:147` och `:175`), och första medlemskapet skapas med
`is_company_admin=True` (`app/services.py:122`). Ingen extra bockning behövs.

**Problemet: hon kommer inte åt appen, och det är olöst.** Adresserna i sammanhanget är
demomaskinen `192.168.50.120:8080`, Tomas maskin `192.168.50.194`, hennes `192.168.50.124`,
routern `192.168.50.1` (ASUS-standardsubnät). Hennes maskin är en äldre MacBook Pro på macOS
Monterey 12.7.1 med Norton 360.

Vad som är mätt:

| | |
|---|---|
| Tomas maskin → demon | `HTTP 200` på 9 ms, upprepade gånger |
| Hennes maskin → demon | timeout på både ping och TCP 8080, tyst drop och inget `refused` |
| Hennes maskin → routern | webbgränssnittet laddar |
| Tomas maskin → hennes | ping utan svar |
| Wifi | samma SSID `cybernexus`, men **hon kanal 36, han kanal 100** |
| Norton Smart Firewall | **avstängd** under det misslyckade testet – utrett som orsak |

Kanalerna är nyckeln. En radio sänder på en kanal i taget, så de sitter på olika radio trots
samma nätnamn – antingen en tri-band-router (5 GHz-1 på kanal 36–64, 5 GHz-2 på 100–144, ett
SSID via Smart Connect) eller en mesh-nod. **`Set AP Isolated` sätts per radio på ASUS**, och en
isolerad klient får exakt det uppmätta mönstret: internet och gateway fungerar, varje annan värd
på LAN:et är död.

**Två saker återstår, och bägge är okörda:**

1. `netstat -rn -f inet` på hennes maskin. Går `default` via ett `utun`-interface är det
   **Norton Secure VPN** som är påslagen, och då hjälper ingen routerinställning. Den ingår i
   Norton 360, startar av sig själv, och rörs inte av att Smart Firewall stängs av.
2. Routern på `http://192.168.50.1` → *Wireless → Professional* → **`Set AP Isolated: No` för
   varje band var för sig**. Finns en AiMesh-nod ska den kontrolleras också. Tomas har inte gett
   klartecken att jag går in i routern, och inloggningen är inte lämnad.

**Demomaskinen var nere när sessionen avslutades 2026-09-30** – varken ping eller HTTP, till
skillnad från tidigare samma session. **Kontrollera det först nästa gång**, annars felsöks ett
nät som inte har något att svara.

**Varför:** Felsökningen hann utesluta fel saker tre gånger innan mönstret satt, och det som
kostade mest var att dra en slutsats ur en mätning jag läst fel – se
[[en-matning-kan-vara-inaktuell-eller-stympad]]. Det som återstår är två kommandon och en
routerinställning, inte en utredning från början.

**How to apply:** Börja nästa gång med `curl` mot `192.168.50.120:8080` från Tomas maskin för
att se att demon alls står. Kör sedan punkt 1, som är gratis och stänger VPN-frågan helt, före
punkt 2, som kräver hans klartecken. Föreslå inte Norton Smart Firewall igen och inte heller
gästnätverk – bägge är mätta och avförda. Se även [[databasen-ar-slangbar]] om demodatan kommer
på tal: går den förlorad är det ingen katastrof.
