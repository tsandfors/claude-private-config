---
name: en-annotering-skuggar-faltet
description: I Django skuggar en annotering med ett fälts namn fältet för uttryck i samma annotate – F("x") läser då aggregatet; ge summor egna alias
metadata:
  type: feedback
  scope: global
---

`.values("period").annotate(target_count=Sum("target_count"), target_amount=Sum(F("target_count") * F("product__price")))`
kastar `FieldError: Cannot compute Sum(...): ... is an aggregate`. Annoteringen `target_count`
skuggar fältet, så `F("target_count")` i nästa uttryck pekar på summan och inte på kolumnen.
Hittat 2026-10-14 i att-gora när ett lagrat fält byttes mot ett uträknat uttryck: koden hade
fungerat i månader så länge varje summa bara läste sitt eget fält.

**Why:** att återanvända fältnamnet som alias är en vana som ser städad ut och fungerar tills
ett uttryck läser fältet. Då kommer felet i en rad som inte ändrats.

**How to apply:** ge aggregat egna alias (`planned_count`, `planned_amount`) så fort ett
uttryck i samma `annotate` läser något fält, och greppa efter alias som heter som fält när ett
lagrat fält ersätts av en beräkning. Felet syns som ett `FieldError` och inte som fel siffror,
så ett test som rör vägen fångar det – se [[en-svit-bygger-sin-egen-varld]] för vad sviten
annars inte ser.
