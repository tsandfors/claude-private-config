#!/usr/bin/env python3
"""Validate the shared private memory store at ~/.claude-private/memory/.

Why this exists
---------------
Copied from the work store's `check-memory.py` on 2026-08-28, when the private memories
moved out of `projects/<cwd>/memory/` into one shared directory and gained a `scope:`
field. That move mirrors the one work made on 2026-08-26, and it is worth restating why:
a per-directory store carries "where does this apply" *structurally*, so it can never be
wrong — but it also makes every general lesson invisible from every other directory. A
shared store fixes that and moves the burden into a written field, and written-down facts
rot. So scope is checked rather than trusted.

Valid scopes are `global` plus the private repos listed in ~/.claude-private/repos.txt.
The list is a file and not a directory scan on purpose: ~/ts_projects holds work repos
too (motor-pro-import-api), and scanning it would quietly admit a work repo as a valid
private scope.

Failures (exit 1):
  - a memory with no scope
  - a scope naming something that is not `global` or a known private repo
  - a memory missing from MEMORY.md, or an index link with no file

Reported but not failed:
  - unresolved [[wikilinks]] — these legitimately mark memories worth writing later
  - scopes flagged with "# osäker" — a guess awaiting correction
"""
import os
import re
import sys
import glob

MEM = os.path.expanduser("~/.claude-private/memory")
REPOS_TXT = os.path.expanduser("~/.claude-private/repos.txt")
EXTRA_SCOPES = {"global"}


def known_scopes() -> set[str]:
    repos = set()
    try:
        with open(REPOS_TXT) as fh:
            repos = {l.strip() for l in fh if l.strip() and not l.startswith("#")}
    except OSError as e:
        print(f"  ! kunde inte läsa {REPOS_TXT}: {e}")
    return repos | EXTRA_SCOPES


def main() -> int:
    files = sorted(f for f in glob.glob(os.path.join(MEM, "*.md"))
                   if os.path.basename(f) != "MEMORY.md")
    valid = known_scopes()
    errors = []

    names, scopes, uncertain = set(), {}, []
    for f in files:
        b = os.path.basename(f)
        text = open(f).read()
        names.add(b[:-3])
        m = re.search(r"^\s*name:\s*(.+)$", text, re.M)
        if m:
            names.add(m.group(1).strip().strip('"'))

        s = re.search(r"^\s*scope:\s*([^#\n]+)(#.*)?$", text, re.M)
        if not s:
            errors.append(f"{b}: saknar scope")
            continue
        if s.group(2) and "osäker" in s.group(2):
            uncertain.append(b)
        vals = [v.strip() for v in s.group(1).split(",") if v.strip()]
        scopes[b] = vals
        for v in vals:
            if v not in valid:
                errors.append(f"{b}: okänt scope '{v}' (finns inte i repos.txt)")

    index = open(os.path.join(MEM, "MEMORY.md")).read()
    linked = re.findall(r"\]\(([^)]+\.md)\)", index)
    base = {os.path.basename(f) for f in files}
    for missing in sorted(base - set(linked)):
        errors.append(f"{missing}: finns inte i MEMORY.md")
    for ghost in sorted(set(linked) - base):
        errors.append(f"MEMORY.md länkar till {ghost}, som inte finns")

    wiki = set()
    for f in files:
        wiki |= set(re.findall(r"\[\[([^\]]+)\]\]", open(f).read()))
    unresolved = sorted(wiki - names)

    used = sorted({v for vs in scopes.values() for v in vs})
    print(f"minnen: {len(files)}   scope-värden i bruk: {', '.join(used) or '(inga)'}")
    if uncertain:
        print(f"\nosäkert klassificerade ({len(uncertain)}) — värda en blick:")
        for u in uncertain:
            print(f"  {u}  ->  {', '.join(scopes[u])}")
    if unresolved:
        print(f"\nolösta [[wikilänkar]] ({len(unresolved)}) — minnen värda att skriva:")
        for u in unresolved:
            print(f"  [[{u}]]")
    if errors:
        print(f"\nFEL ({len(errors)}):")
        for e in errors:
            print(f"  {e}")
        return 1
    print("\nallt konsistent")
    return 0


if __name__ == "__main__":
    sys.exit(main())
