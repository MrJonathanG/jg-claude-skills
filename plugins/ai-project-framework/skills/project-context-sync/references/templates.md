# Project Context Sync — templates & reference

Load this when actively running a ceremony, creating a new project file, or standardizing an existing one.

---

## 1. Per-project context file — canonical schema

One file per project. Lives at the storage standard path:
`/<area>/<project>/Project Instructions/<Project_Name>_Project_Instructions.md`

```markdown
---
title: "<Project> — Project Instructions & Context"
project: "<short project name>"
area: "<parent area>"
status: "<active | paused | complete>"
last_updated: "YYYY-MM-DD"
doc_type: "project-context / cross-session reference"
tags: [area, project, ...]
---

# <Project> — Project Instructions & Context

> Purpose: durable cross-session, cross-AI source of truth for <project>. Re-loadable by any
> Claude surface or other AI. Reflects decisions as of last_updated; newer human decisions supersede it.

## 1. At a glance
- What this project is, in 3-5 bullets. Owner, status, the one or two anchors that must never be lost.

## 2. Current state / model
- The substantive content: the model, architecture, approach. Edited in place. Never narrates history.

## 3. Roles / scope / decisions
- Who/what is involved; scope boundaries; resolved decisions stated as facts.

## 4. Assets & locations
| Artifact | Storage | Location — `<storage system / MCP> (<account or scope>) : <full path>` | Notes |
|---|---|---|---|
| <deliverable / file / folder> | <cloud storage / git repo / AI platform> | <storage system / MCP> (<account or scope>) : <full path> | <what it is> |

Every deliverable, file, and folder appears here so any session can find it. The **Storage** column names which surface holds each item (cloud storage / git repo / the AI platform itself); name the surface, not just the path (see "Name the location, not just the path" in `SKILL.md`). Update this table in the same write whenever a file moves.

## 5. Open items
- Unresolved questions and decisions. Each item one line. Remove when resolved (and log in Changelog).

## 6. How to use (for future AIs / sessions)
- Precedence rules, the must-not-lose anchors, anything an incoming session needs to not break the thread.
- **Governing disciplines (plain language):** one line per rule the project operates by, so any AI behaves consistently even if it cannot run the skills. Example: "Never write the context file without proposing a diff and getting approval first."
- **Skills that enforce them:** one line per governing skill — name + canonical repo location, e.g. `project-context-sync — <repo> : plugins/<domain>/skills/project-context-sync/SKILL.md`. A platform where these skills auto-load uses them directly; any other AI reads the source at that path and applies the discipline by hand.

## Changelog
<!-- APPEND ONLY. One line per change. Never rewrite existing lines. -->
- YYYY-MM-DD · created · initial context captured
```

**Note:** the portable file MAY name the project's governing skills when they live where any AI can reach them (e.g. a git repo) — listed by name + access path in "How to use", each paired with a plain-language discipline. What stays platform-specific is the auto-load mechanism, not the knowledge that the skills exist. Do not paste skill bodies or pin versions here; point to the canonical repo location.

---

## 2. Root directory + global rules — template

Lives at the parent-area root, e.g. `<storage system / MCP> (<account or scope>) : /<area>/README.md` (or `_GLOBAL.md`). Portable, AI-agnostic.

```markdown
# <Area> — project directory & global rules

## Projects
| Project | Location — `<storage system / MCP> (<account or scope>) : <full path>` |
|---|---|
| <Project A> | <storage system / MCP> (<account or scope>) : /<area>/<Folder A> |
| <Project B> | <storage system / MCP> (<account or scope>) : /<area>/<Folder B> |

Name the storage system / MCP alongside the path: a bare path does not say which system or
account holds the folder, and different AIs reach different systems.

Each project folder contains a project-instructions file in its "Project Instructions"
subfolder, following the project-context-sync schema.

## Global rules (apply to all projects in this area; any AI should honor)
- No em-dash; use commas, parentheses, or separate sentences.
- Do not open sentences with filler ("Honestly,", "Genuinely,", "Actually,").
- Sentence case for titles and labels; minimal bold.
- <add your portable style/behavior rules here>
```

---

## 3. In-app project instructions — universal portable bootloader

Drop-in for ANY AI app's project-instructions field (Claude projects and the equivalent
feature in other AI apps). The **universal body** is identical for every AI; only the short
**platform notes** differ, and each AI applies just the line that fits its capability. Keep it
to a handful of lines — never a copy of the context file.

```
# <project or area> — context bootloader

Purpose: this project's living context is maintained as a file in storage; load it before working.

Context file:
- <storage system / MCP> (<account or scope>) : /<area>/<project>/Project Instructions/<name>_Project_Instructions.md
  (Name the storage system / MCP, not just the path — reachability differs by AI and surface.)

If you cannot reach the context file, proceed on these essentials only:
- Scope: work only within <this project's scope>; if unsure, ask.
- Core discipline: <the project's one load-bearing rule, e.g. propose a diff and get approval before writing>.
- Producer/executor split: one side proposes, the other approves and executes; no silent writes.
- Skills live in the repo: <repo> : plugins/<domain>/skills/<name>/SKILL.md — read them there if your platform cannot auto-load them.

Platform notes (apply only the line that fits you):
- On a platform where these skills are installed and auto-load by name, use them directly.
- Otherwise, read the same skills from the repository at the named path and apply the discipline manually.
```

The universal body (purpose, pointer, fallback) reads the same for every AI. The platform-notes
block is the only place platform-specific capability appears, written by capability ("a platform
where the skills auto-load") rather than by product name, so the template stays portable.

---

## 4. Ceremony scripts

### Session-start opener (after loading the file)
```
Loaded <project> (last updated YYYY-MM-DD).
Status: <one line>.
Current focus: <one line>.
Top open items: <1-3 items>.
```
Then proceed with work. If the project can't be resolved, ask: "Which project are we in, and where's its folder?"

### Real-time update (on "update the instructions")
```
I'll update <project>'s context file:
- <section>: <what changes>
- Changelog: "YYYY-MM-DD · <change> · <why>"
Approve?
```
On approval → clobber-guard check → write.

### Session-close diff proposal
```
Close-out for <project>. Proposed updates to the context file:

Current-state edits:
- <section> → <change>

Open items:
- Resolved: <item>
- New: <item>

Changelog (append):
- YYYY-MM-DD · <change> · <why>

Approve / edit / skip?
```
On approval → clobber-guard check → edit in place + append Changelog + bump last_updated.

---

## 5. Style spec (enforce on every write)

- Sentence case; no em-dash.
- Decisions as resolved facts, not narrative ("scope = two workstreams", not "we discussed and might do two").
- Locations named with storage system / MCP + full path (`<storage / MCP> (<scope>) : /<area>/...`), never "the folder".
- One Changelog line per change; format `YYYY-MM-DD · what · why/source`.
- Current-state sections describe the present only. History belongs in the Changelog.
- Keep it simple and scannable — this file is re-read into every session; bloat costs every time.

---

## 6. Clobber guard (concurrency)

Before any write:
1. Re-read the file's `last_updated`.
2. If it is newer than the value loaded at session start, another surface/AI edited it. Re-read the file, reconcile the proposed diff against the new content, re-confirm with the user, then write.
3. If unchanged, proceed with the approved write.

Last-write-wins is the failure mode this prevents — a Code session silently overwriting a Chat session's edit from an hour earlier.

---

## 7. Folder organization (per-project, derived)

See "Folder organization" in `SKILL.md` for the decision procedure (principles, threshold, propose-then-approve). The example below illustrates one derived outcome; it is not a layout to copy.

### Example: a derived folder structure (illustrative, NOT a standard)

A maintenance project that accumulated a master document plus several print/reference files settled on two functional buckets beside the reserved slot:

```
/<area>/<project>/
├── Project Instructions/        (reserved — context file only)
│   └── <name>_Project_Instructions.md
└── Maintenance Guides/          (master doc + all print/reference files)
```

This is one project's derived answer, not a layout to copy. A research or build project would derive entirely different buckets by the same principles.
