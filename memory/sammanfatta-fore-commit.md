---
name: sammanfatta-fore-commit
description: Ge en skumbar sammanfattning av vad som ändrats bredvid commit-meddelandet - de två har olika läsare och ska inte vara samma text
metadata: 
  node_type: memory
  type: feedback
  scope: global
  modified: 2026-09-20T01:53:47.204Z
  originSessionId: 8f8dbf6c-c26b-49af-9781-6c22cd683b80
---

Före varje commit: visa **både** commit-meddelandet och en kort sammanfattning av vad som
faktiskt ändrats — vilka filer, vad som konkret gjorts i var och en, och vad som *inte* ingår.

**Varför:** Tomas bad om det 2026-09-20. Commit-meddelandena i hans projekt är med flit långa
och argumenterande, skrivna för den som gräver i historiken om ett halvår och behöver veta
varför ett beslut togs. Den som ska godkänna *nu* har ett annat behov och läser en annan sak:
omfattning och innehåll, inte resonemang. Att låta en text tjäna bägge gör den sämre för bägge
— antingen blir meddelandet tunnare än historiken förtjänar, eller så måste godkännaren
skumma tjugo rader prosa för att hitta filnamnen.

**How to apply:** sammanfattningen är strukturerad och kort — gärna rubrik per fil eller per
ändring, med en rad om *varför* under varje. Nämn uttryckligen vad som inte ingår, och vilka
påståenden som är mätta snarare än antagna. Den **committas inte**; den hör till samtalet.
Commit-meddelandet behåller sin form. Se [[no-commit-or-push-without-approval]] för själva
godkännandet, som är en skild sak: sammanfattningen gör det lättare att säga ja eller nej, men
den ersätter inte att man ska fråga.
