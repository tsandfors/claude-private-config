---
name: olast-version-driver-isar
description: En rullande tagg eller ett olåst versionsintervall gör utvecklingsmaskinen och varje ny maskin olika - och den som redan har artefakten kan inte upptäcka det
metadata: 
  node_type: memory
  type: feedback
  scope: global
  modified: 2026-09-18T23:58:55.072Z
  originSessionId: 8f8dbf6c-c26b-49af-9781-6c22cd683b80
---

Ett beroende som inte är låst till en version löses om **vid varje hämtning**, och olika
maskiner hämtar vid olika tillfällen. Följden är inte att något går sönder direkt, utan att
maskinerna tyst glider isär tills någon sätter upp en ny.

**Den som redan har artefakten kan strukturellt inte upptäcka det.** En image som ligger på
disk löses aldrig om; en `node_modules`-volym som seedats en gång behåller sin upplösning.
Utvecklingsmaskinen är därför det enda stället där felet är osynligt, vilket är precis det
ställe man provar på.

**Varför:** 2026-09-19 föll demoinstallationen av Byrå-CRM:et på två av dem samtidigt.
`postgres:alpine` hade hämtats på utvecklingsmaskinen i maj 2025 och var 17.5; samma tagg på
en maskin som hämtade samma dag var 18, som flyttat datakatalogen och vägrar starta mot en
volym på `/var/lib/postgresql/data`. Och `web/Dockerfile` kopierade `package.json` men inte
`yarn.lock` före `yarn install`, så varje bygge löste om varje caret-intervall: dev-containern
stod på jsdom 30.0.1, en nybyggd testimage fick 30.1.0, och frontendsviten var röd i den ena
och grön i den andra utan att någon ändrat en rad kod.

Det andra fallet bar en läxa till: **ett test kan leva på driften.** Selektorn
`querySelectorAll("div div div")[0]` träffade rätt element bara så länge jsdom felaktigt
räknade `container` som rot. Att låsa lockfilen gjorde testet grönt igen, men inte ärligt —
det hade fallit på nytt vid nästa uppdatering. Jämför [[gront-test-bevisar-inget-i-sig]].

**How to apply:** när något ska köras på mer än en maskin, svep efter det som *inte* är låst
innan provet — image-taggar utan major, `^`/`~`-intervall, en lockfil som finns men inte
kopieras in före installationen, `latest` var som helst. Lås till det som redan är bevisat, och
låt en flagga som `--frozen-lockfile` göra nästa glidning högljudd. Mät driften i stället för
att anta den: jämför den installerade versionen i den gamla artefakten mot en nybyggd. Och när
ett test blir grönt av en låsning — fråga om det var testet eller driften som var fel, för
låsningen svarar inte på det. Se [[byggtidsvariabel-reser-med-imagen]] för samma fråga ställd om
konfiguration i stället för versioner, och [[en-svit-bygger-sin-egen-varld]] för varför en grön
svit inte säger något om miljön bredvid.
