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
area: "<parent area, e.g. IBM>"
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
- Every deliverable, file, and folder with its FULL path. So any session can find them.

## 5. Open items
- Unresolved questions and decisions. Each item one line. Remove when resolved (and log in Changelog).

## 6. How to use (for future AIs / sessions)
- Precedence rules, the must-not-lose anchors, anything an incoming session needs to not break the thread.

## Changelog
<!-- APPEND ONLY. One line per change. Never rewrite existing lines. -->
- YYYY-MM-DD · created · initial context captured
```

**Note:** no "skills / tooling" section. Skill references are Claude-only and live in the in-app project instructions (layer 1), keeping this file portable to any AI.

---

## 2. Root directory + global rules — template

Lives at the parent-area root, e.g. `/AI Projects/IBM/README.md` (or `_GLOBAL.md`). Portable, AI-agnostic.

```markdown
# <Area> — project directory & global rules

## Projects
| Project | Folder location |
|---|---|
| <Project A> | /AI Projects/<Area>/<Folder A> |
| <Project B> | /AI Projects/<Area>/<Folder B> |

Each project folder contains a project-instructions file in its "Project Instructions"
subfolder, following the project-context-sync schema.

## Global rules (apply to all projects in this area; any AI should honor)
- No em-dash; use commas, parentheses, or separate sentences.
- Do not open sentences with filler ("Honestly,", "Genuinely,", "Actually,").
- Sentence case for titles and labels; minimal bold.
- <add your portable style/behavior rules here>
```

---

## 3. In-app project instructions — template (Claude project settings)

Thin bootloader. This is the ONLY place skill references live.

```
This project manages several project objectives. Context for each lives in its
storage folder as a project-instructions file (see the project-context-sync skill).

Projects & folder locations:
- <Project A> : /AI Projects/<Area>/<Folder A>
- <Project B> : /AI Projects/<Area>/<Folder B>

Global rules: see the directory/README at /AI Projects/<Area>/README.md

Global skills used across these projects:
- project-context-sync   (load/update project context)
- <domain skill, e.g. ibm-deck-themes>
- <other skills>

Standard: every project folder contains a project-instructions file in its
"Project Instructions" subfolder, following the project-context-sync schema.
At session start, confirm the project, load its file, and run the close
ceremony before ending.
```

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
- Decisions as resolved facts, not narrative ("EMC = 1.0 FTE", not "we discussed and thought maybe").
- Full paths always (`/AI Projects/IBM/...`), never "the folder".
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
