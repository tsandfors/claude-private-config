---
name: en-granskning-kan-be-om-att-angra-forra
description: "Innan ett granskningsfynd lagas – jämför mot main och mot förra granskningens lagningar; ett fynd om beteende från före PR:en, eller som ångrar en lagning, startar en felloop"
metadata:
  node_type: memory
  type: feedback
  scope: global
  originSessionId: 6eee39b9-3c69-4f33-ba89-f68c10733073
  modified: 2026-10-08T12:13:35.679Z
---

Två granskningar i rad av samma PR kan be om motsatta saker. 2026-10-08, PR #11 i att-gora:
första granskningen sa att `Donut` hade ändrat beteende för NaN, och det återställdes ordagrant.
Andra granskningen sa att samma beteende var en bugg och ville ändra summan – vilket hade ändrat
när platshållarringen ritas, alltså en ny ändring som en tredje granskning kunnat hitta fel i.
Samma omgång ville ändra en rad som var en lagning ur PR #10. Tomas namngav risken själv:
*"vi fixar ett problem och återinför ett nytt som redan fixats en gång"*.

**Why:** En granskning ser diffen och koden runt den, inte historiken. Den kan inte veta att det
den kallar en bugg är vad förra omgången bad om, eller att raden den vill röra är en lagning.
Varje lagning är ny kod och ny yta för nästa granskning, så en kedja av "små" lagningar konvergerar
inte – PR #10 fick tre granskningar med sju fynd var, och två av den tredjes kom ur den andras
lagningar.

**How to apply:** För varje fynd, innan det lagas, ställ två frågor:
1. **Fanns beteendet före PR:en?** `git show main:<fil>` – gör det det är det inte PR:ens fel,
   och ett fall som datan inte kan nå skrivs ner i stället för att lagas.
2. **Rör lagningen något en tidigare granskning bad om eller lagade?** Sök i backloggens
   granskningsavsnitt och i `git log -p` för raden. Gör den det, lagas den inte i
   granskningsomgången.
Det som klarar bägge frågorna och ändå har tyngd – i PR #11 att `known()` svarar ja över en
404 – är ofta en sort och blir ett eget steg, inte en lagning samma kväll.
Se [[ett-fynd-kan-vara-priset-for-ett-val]] och [[forklara-brus-dar-granskningen-letar]].
