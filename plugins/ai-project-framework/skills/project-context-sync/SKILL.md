---
name: project-context-sync
description: Portable, cross-session, cross-AI project context management. Keeps a durable per-project context file in cloud storage (Dropbox-first; also Box, Google Drive, local) so project state survives across Claude surfaces (Chat, Code, Cowork, Design) and other AIs. Apply when the user names a project to work in ("we're working in Weaver", "load the TMA project", "switch to Strongwatch"), starts or closes a project session, says "update the project instructions / context / file", or asks to create / set up project instructions for a new project. Runs propose-then-approve ceremonies (session-start load, new-project creation, session-close reconcile) plus real-time updates on cue. Organizes each project's storage folder per-project (derived, not templated) and validates skill triggers at session close. Never writes silently: verify, propose a diff, get approval, then write. Edits current-state sections in place, appends to a never-overwritten Changelog, uses a clobber guard against concurrent edits. Composes with dev-session-protocol (defers session timing to it when active) and domain packs like ibm-deck-themes. The portable file holds no Claude-only skill references; those live in the in-app project instructions.
---

# Project Context Sync

The portable context layer beneath every Claude surface and every other AI. Native project instructions are per-module, static, and the AI cannot write them — so context fragments across Chat / Code / Cowork / Design and is lost when switching AIs. This skill moves the source of truth into a cloud-storage file that every surface can read and write, and reduces the in-app instructions to a thin pointer.

For full templates (per-project file schema, root directory + global-rules template, in-app pointer template, style spec, ceremony scripts), see `references/templates.md`. Load it whenever actively running a ceremony or creating/standardizing a file.

## The three layers (know which is which)

1. **In-app project instructions** (Claude project settings) — the bootloader. Holds: a one-line purpose, the **directory** (project name → storage folder path), the **global skills list** (skills are Claude-only, so they live here, never in the portable file), and a pointer to the storage standard. Template in `references/templates.md`.
2. **Root directory + global rules file** (cloud storage, e.g. `/AI Projects/<area>/README.md` or `_GLOBAL.md`) — portable, AI-agnostic. Holds the project directory and the global behavior rules (e.g. no em-dash, style preferences) that any AI should honor.
3. **Per-project context file** (one per project, e.g. `/<area>/<project>/Project Instructions/<name>_Project_Instructions.md`) — the portable context. Current-state body edited in place + append-only Changelog. **No skill references** (Claude-only; those live in layer 1).

## Ceremonies + real-time, all propose-then-approve

**Never write silently.** Every write path is: verify → propose a diff → get user approval → write. This is the trust model for a file that is the user's cross-system source of truth.

### Session-start (load / bootstrap)
1. Resolve the project. The user normally names it ("we're working in X"). If known, confirm the path. If ambiguous or unknown, **ask** — do not guess.
2. Read the per-project file (and the root global-rules file).
3. Give a short "here's where we left off" opener (3-4 lines: status, current focus, top open items).
4. Note the file's `last_updated` for the clobber guard. Don't start work until loaded.

### Creating project instructions (new project)
When the user asks to **create** project instructions for a new project (as opposed to loading or updating an existing one), run the creation flow instead of the load flow.

**Default to the cross-functional, portable structure.** It works for any AI (Claude, ChatGPT, others) and degrades gracefully to single-AI use. A single-AI-only setup does not port, so portable is the safe default. Build single-AI instead only when there is a genuine signal the project is Claude-bound (e.g. it depends on Claude-only tooling with no portable equivalent) — ask in that case; otherwise build cross-functional without asking.

Build all three layers (full templates in `references/templates.md`):
1. **Per-project context file** (portable, in storage) — canonical schema; holds durable context, constraints, inventory/assets, decisions, open items, changelog. No Claude-only skill references.
2. **Root / global-rules file** (only if the area lacks one) — portable behavior rules for the area.
3. **In-app bootloader** — output as text for the user to paste into project settings. Thin pointer: purpose, storage location, the reserved `Project Instructions/` path, and the skill-pointer list. Claude-only skill references live **here**, never in the portable file.

**Pointer rule** (bootloader and context): reference shared skills by **name + location** (plus a short, stable description) — never copy a skill's body, never pin a version, never restate a skill's precise trigger. The precise trigger lives inside each skill; pointers carry only stable info.

### Real-time update (on cue)
When the user says "update the instructions / context": state exactly *what* will change and *where* (the verify step) → on approval, write.

### Session-close ceremony
1. Audit the session against the loaded file.
2. Produce a **diff proposal**: current-state edits + Changelog line(s) + any resolved open-items.
3. Folder-structure check (see "Folder organization"): if the flat folder has crossed the threshold or accumulated mixed document classes, include a grouping proposal in the diff. Propose; do not impose.
4. **Skill-trigger validation** (only if skills were used or referenced this session): for each skill used, check its stated trigger against how it actually fired. Flag mismatches — a stale path reference, a skill that fired outside its stated condition, or one that should have fired but didn't. Surface flagged triggers as proposed skill-level updates. Do **not** edit shared skills from a project close; route the change to the skill source via the deliberate skill-update path (propose-then-approve). The ceremony detects and proposes — it never edits shared skills directly.
5. User approves / edits / rejects.
6. On approval: edit current-state sections in place, append the Changelog line(s), bump `last_updated`.

Capture only **durable** changes — decisions, scope shifts, new assets, resolved/added open-items. Not chatter.

## Write discipline

- **In place** for current-state sections; the file must always read clean (it is re-loaded into every session).
- **Append-only `## Changelog`** at the bottom: one line per change — `YYYY-MM-DD · what changed · why/source`. Never rewrite it. This is the breadcrumb trail that in-place editing would otherwise lose.
- **Clobber guard:** view the file immediately before writing. If `last_updated` is newer than what was loaded at session start, re-read and reconcile before writing — another surface or AI may have edited it.
- **Newer human decisions supersede the file.** If the session contradicts the file, the session wins; update the file and log it.

## Storage-agnostic operation

- Dropbox-first, but the same read / write / verify pattern works with Box, Google Drive, or local files. Use whichever storage MCP is connected.
- **Degrade gracefully:** if no storage connector is available in the current module, say so, and fall back to outputting the proposed file content inline for the user to paste/save manually. The ceremonies still run — only the write target changes.

## Folder organization (per-project, derived not templated)

Each project's storage folder must be organized intelligently for that project — never a flat dump of every file in one directory, and never a rigid one-size template forced across different project types. Derive the structure from the project's own nature using the principles below.

### Principles

1. **One reserved slot, everything else derived.** `Project Instructions/` is the single universal convention — it holds only the per-project context file, in every project. Everything else is organized per project.
2. **Group by function, not by file type or by how a file was produced.** Name folders for the role documents play in this project's domain (e.g. "Maintenance Guides", "Source Material", "Deliverables"), not by process words ("Artifacts", "Outputs", "Files") or raw extension. If a folder name would not tell a newcomer what is inside and what it is for, rename it.
3. **Threshold before structure.** Stay flat while a project is small. Introduce subfolders once the project crosses roughly 4–5 non-context files, OR has two or more clearly distinct kinds of document. Below that, flat is correct — forcing folders on a 2-file project is overhead.
4. **Derive categories from what the project produces.** Identify the natural document classes for this specific project and cluster into named buckets. The classes differ by domain (a maintenance project yields guides and logs; a research project yields sources, drafts, outputs; a build yields specs, code, assets). Do not pre-assume a fixed set.
5. **Propose before restructuring; never silently reorganize.** Folder moves change paths other files reference. Propose the structure, get approval, move, then fix every stale reference in the same pass (same trust model as all writes in this skill).
6. **Keep the context file's map current.** The "Assets & locations" section of the per-project file is the authoritative map. Any folder change must update that section's paths in the same operation, and log it in the Changelog. A moved file with a stale map is a broken source of truth.

### When to apply (active + on request)

- **On request:** whenever the user asks to organize, restructure, or clean up a project's files.
- **Proactively (watch):** during the session-close ceremony, check the project folder against principle 3. If it has crossed the threshold or accumulated mixed document classes while still flat, raise it as a proposal in the close diff ("the folder now has N files spanning M kinds; propose grouping into …"). Propose; do not impose. If the user declines, log nothing and leave the structure flat.

## Schema (strict default, documented flex)

Per-project files follow the canonical schema in `references/templates.md`: YAML frontmatter → purpose line → At a glance → Current state/model → Roles/scope/decisions → Assets & locations (full paths) → Open items → How to use (for future AIs) → Changelog (append-only). Strict by default — reformat content to match. Flex is allowed when a project genuinely needs it, but **never lose content** to fit the schema. The "Assets & locations" section reflects the project's actual folder structure (see "Folder organization"); when files move, its paths update in the same write.

Style spec (keeps files clean and consistent across AIs): sentence case; no em-dash; decisions stated as resolved facts, not narrative; full paths always; one Changelog line per change; current-state sections never narrate history (that is the Changelog's job).

## Composition

- **`dev-session-protocol`** — independent but interoperable. That skill owns session-boundary *timing* for code work. When it is active, run this skill's file load inside its session-open and the close reconcile inside its session-close, rather than starting a competing ceremony. When it is absent (non-code project), this skill runs its own start/close ceremonies.
- **Domain packs (e.g. `ibm-deck-themes`)** — independent. Domain skills govern how deliverables look/behave; this skill governs the portable context file. They co-fire without conflict.
- **`clickup-pm-workflow` / `notion-pm-workflow`** — independent. Those track tasks in a PM tool; this tracks portable narrative context in a file. Use both when the project has a tracker and a context file.

## When NOT to apply

- One-off questions with no project continuity ("what's the capital of France").
- A project that has no context file and the user hasn't asked to create one — offer, don't impose.
- Editing a deliverable's content (that's the domain skill's job), unless a durable decision came out of it worth logging.
