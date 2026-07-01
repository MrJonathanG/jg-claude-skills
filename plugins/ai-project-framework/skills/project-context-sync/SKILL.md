---
name: project-context-sync
description: Portable, cross-session, cross-AI project context management. Keeps a durable per-project context file in cloud storage (any connected cloud-storage or file MCP, or local) so project state survives across Claude surfaces (Chat, Code, Cowork, Design) and other AIs. Apply when the user names a project to work in ("we're working in <project>", "load the <project> project", "switch to <project>"), starts or closes a project session, says "update the project instructions / context / file", or asks to create / set up project instructions for a new project. Runs propose-then-approve ceremonies (session-start load, new-project creation, session-close reconcile) plus real-time updates on cue. Organizes each project's storage folder per-project (derived, not templated) and validates skill triggers at session close. Never writes silently: verify, propose a diff, get approval, then write. Edits current-state sections in place, appends to a never-overwritten Changelog, uses a clobber guard against concurrent edits. Composes with dev-session-protocol (defers session timing to it when active) and domain packs. When the governing skills live where any AI can reach them (e.g. a git repository), the portable file may name them by access path and state each one's discipline in plain language; what is platform-specific is the auto-load mechanism, not the knowledge that the skills exist. The in-app instructions are themselves a portable bootloader, reusable verbatim in any AI app's project-instructions field.
---

# Project Context Sync

The portable context layer beneath every Claude surface and every other AI. Native project instructions are per-module, static, and the AI cannot write them — so context fragments across Chat / Code / Cowork / Design and is lost when switching AIs. This skill moves the source of truth into a cloud-storage file that every surface can read and write, and reduces the in-app instructions to a thin pointer.

For full templates (per-project file schema, root directory + global-rules template, in-app pointer template, style spec, ceremony scripts), see `references/templates.md`. Load it whenever actively running a ceremony or creating/standardizing a file.

## The three layers (know which is which)

1. **In-app project instructions** — the **portable bootloader**. It is itself universal: the same minimal pointer drops verbatim into any AI app's project-instructions field (Claude projects and the equivalent feature in other AI apps), so its body carries no platform-specific mechanics. By rule it holds only: a one-line purpose; a **reachability-aware pointer** to the context file (the storage system / MCP *and* the full path); a short graceful-degradation **fallback** carrying only the load-bearing essentials (the scope guard, the project's core discipline, the producer/executor split of who proposes vs. who approves and executes, and where the skills live in the repo) so the bootloader never hard-fails when storage is unreachable; and a short **platform-notes** block (see the layer-1 template in `references/templates.md`). Minimal by rule — a handful of lines, never a copy of the context file.
2. **Root directory + global rules file** (cloud storage, e.g. `<storage system / MCP> (<account or scope>) : /<area>/README.md`) — portable, AI-agnostic. Holds the project directory and the global behavior rules (e.g. no em-dash, style preferences) that any AI should honor.
3. **Per-project context file** (one per project, e.g. `/<area>/<project>/Project Instructions/<name>_Project_Instructions.md`) — the portable context. Current-state body edited in place + append-only Changelog. It **may** name the project's governing skills **when they live where any AI can reach them** (e.g. a git repository): list each by name and access path (repo + in-repo path such as `plugins/<domain>/skills/<name>/SKILL.md`) so a non-Claude AI can read the source and apply the discipline by hand, and pair each with a one-line plain-language statement of its discipline. What is platform-specific is the **auto-load mechanism** — a host platform auto-loads installed skills by name; other AIs read the same skills from the repo — not the knowledge that the skills exist.

## Disciplines are portable; the skills that enforce them may not be

Skills are universal artifacts: always point to a skill's **canonical repository location** (repo + in-repo path such as `plugins/<domain>/skills/<name>/SKILL.md`) so any AI on any surface can retrieve and apply it. But a skill's *enforcement mechanism* (auto-loading and running it) is not portable, while the *discipline it enforces* is. So for each governing skill the portable file carries two separate things: the **skill reference** (name + access path — the mechanism) and a **one-line plain-language statement of the discipline** it enforces (the rule). An AI that cannot run the skill still reads the rule and behaves consistently.

## Ceremonies + real-time, all propose-then-approve

**Never write silently.** Every write path is: verify → propose a diff → get user approval → write. This is the trust model for a file that is the user's cross-system source of truth.

### Session-start (load / bootstrap)
1. Resolve the project. The user normally names it ("we're working in X"). If known, confirm the path. If ambiguous or unknown, **ask** — do not guess.
2. Read the per-project file (and the root global-rules file).
3. Give a short "here's where we left off" opener (3-4 lines: status, current focus, top open items).
4. Note the file's `last_updated` for the clobber guard. Don't start work until loaded.

### Creating project instructions (new project)
When the user asks to **create** project instructions for a new project (as opposed to loading or updating an existing one), run the creation flow instead of the load flow.

**Default to the cross-functional, portable structure.** It works for any AI and degrades gracefully to single-AI use. A single-AI-only setup does not port, so portable is the safe default. Build single-AI instead only when there is a genuine signal the project is platform-bound (e.g. it depends on platform-specific tooling with no portable equivalent) — ask in that case; otherwise build cross-functional without asking.

Build all three layers (full templates in `references/templates.md`):
1. **Per-project context file** (portable, in storage) — canonical schema; holds durable context, constraints, inventory/assets, decisions, open items, changelog. When the governing skills live in an any-AI-reachable repo, it names them (by name + access path) and states each one's discipline in plain language.
2. **Root / global-rules file** (only if the area lacks one) — portable behavior rules for the area.
3. **In-app bootloader** — output as text for the user to paste into any AI app's project-instructions field. Minimal by rule: a one-line purpose; a reachability-aware pointer to the context file (storage system / MCP + full path); a short fallback; and a short platform-notes block. The body is the same universal pointer for every AI.

**Pointer rule** (any layer that references a skill): reference shared skills by **name + canonical repository location** (repo + in-repo path such as `plugins/<domain>/skills/<name>/SKILL.md`) plus a short stable description — never copy a skill's body, never pin a version, never restate a skill's precise trigger (the precise trigger lives inside each skill). Pair each reference with a one-line plain-language statement of the discipline it enforces, so an AI that cannot run the skill can still apply the rule.

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

- Storage-agnostic by design: the same read / write / verify pattern works with any cloud storage or file MCP (and with local files). Use whichever storage system / MCP is connected, and name it explicitly wherever a location is recorded.
- **Degrade gracefully:** if no storage connector is reachable in the current surface, say so, and fall back to outputting the proposed file content inline for the user to paste/save manually. The ceremonies still run — only the write target changes.

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

Per-project files follow the canonical schema in `references/templates.md`: YAML frontmatter → purpose line → At a glance → Current state/model → Roles/scope/decisions → Assets & locations (storage/MCP + full path, table form) → Open items → How to use (for future AIs) → Changelog (append-only). Strict by default — reformat content to match. Flex is allowed when a project genuinely needs it, but **never lose content** to fit the schema. The "Assets & locations" section is a table mapping each artifact to its location and notes, with a **Storage** column naming which surface holds each item (cloud storage / git repo / the AI platform itself); it reflects the project's actual folder structure (see "Folder organization"), and when files move its paths update in the same write.

**Name the location, not just the path.** Everywhere a location is recorded (the layer-1 pointer, the layer-2 directory, the layer-3 assets table), name the storage system or MCP alongside the path, using the pattern `<storage system / MCP> (<account or scope>) : <full path>`. In multi-account, multi-service setups a bare path does not disambiguate which system or account holds the file, and different AIs reach different systems, so the reachable location must be explicit.

Style spec (keeps files clean and consistent across AIs): sentence case; no em-dash; decisions stated as resolved facts, not narrative; locations named with storage/MCP + full path; one Changelog line per change; current-state sections never narrate history (that is the Changelog's job).

## Composition

- **`dev-session-protocol`** — independent but interoperable. That skill owns session-boundary *timing* for code work. When it is active, run this skill's file load inside its session-open and the close reconcile inside its session-close, rather than starting a competing ceremony. When it is absent (non-code project), this skill runs its own start/close ceremonies.
- **Domain packs (e.g. a deck-theme or formatting pack)** — independent. Domain skills govern how deliverables look/behave; this skill governs the portable context file. They co-fire without conflict.
- **`clickup-pm-workflow` / `notion-pm-workflow`** — independent. Those track tasks in a PM tool; this tracks portable narrative context in a file. Use both when the project has a tracker and a context file.

## When NOT to apply

- One-off questions with no project continuity ("what's the capital of France").
- A project that has no context file and the user hasn't asked to create one — offer, don't impose.
- Editing a deliverable's content (that's the domain skill's job), unless a durable decision came out of it worth logging.
