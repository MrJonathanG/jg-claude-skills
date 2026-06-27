---
name: clickup-pm-workflow
description: Project tracking workflow conventions for ClickUp. Use when the user mentions ClickUp, project tracking, task status, milestones, backlog, project insights, or asks how to update project state. Encodes hierarchy decisions, exact status vocabulary ("to do", "in progress", "complete"), description-vs-activity rules, surface tags applied at completion, milestone naming, discovered work routing (subtask vs new task vs backlog vs insight), parent/subtask status sync, and ClickUp MCP-specific limitations (comment edits not supported, status string casing). Skill is guidance on top of the ClickUp MCP — MCP handles API mechanics, skill encodes opinionated workflow decisions. Composes with app-build-orchestrator (which routes work to surfaces) but is independent of it. Detailed lookup tables live in references/tables.md.
---

# ClickUp PM Workflow

Workflow conventions for tracking project work in ClickUp. This skill is **guidance on top of the ClickUp MCP**, which handles API mechanics. The skill encodes opinionated decisions about how to use those mechanics.

For full lookup tables (closeout format, surface tags, routing destinations, etc.), see `references/tables.md`. Load that reference whenever actively performing tracking operations.

## When to apply

Applies whenever ClickUp work is happening — see description for triggers. Composes with other skills (does not override them).

## Hierarchy decisions

- **Project = top-level folder.** Each project gets its own folder. The project is the folder, not the space.
- **Phases = numbered lists inside the project folder.** Lists named with leading numbers ("0. Discovery", "1. Build", "2. Validate") to enforce order.
- **Tasks live inside phase lists.** A task is a deliverable for that phase.
- **Subtasks live under their parent task.** No cross-list subtasks.
- **Insights** live as comments on a single dedicated `Project Build Insights` task in a `_Governance` folder at the space root.
- **Backlog** lives in the project folder's `Backlog / Operations` list (per-project).

## Status vocabulary (exact strings)

Use exactly — lowercase, with space, no hyphens:

- `to do`
- `in progress`
- `complete`

Variants like `todo`, `in-progress`, or `done` will fail MCP calls. Do not invent alternatives.

## Status transitions (key rule)

- `to do` → `in progress` when work begins
- `in progress` → `complete` when work done AND closeout comment posted
- Direct `to do` → `complete` without an `in progress` interval is incorrect
- See `references/tables.md` for full transition table

## Task / subtask / comment

- **Task** — distinct deliverable with a clear done-state
- **Subtask** — bounded work that emerged during the parent; too distinct for a comment, too dependent to stand alone
- **Comment** — incremental progress; not a new tracking item

**Test:** if you'd want to know later "did we do that thing?" → task or subtask. If it's just "the work continues" → comment.

## Description requirements

When creating any tracked item (task, subtask, milestone), include:

- **Description = the objective.** What this item produces. 1–2 sentences minimum. Written before work starts.

Optional: done-when criteria, inputs needed, out of scope.

## Closeout discipline

When status moves to `complete`, post a closeout comment with: what got produced (Done), surface tags used (Surface), commit hashes if applicable (Commits), and optional notes. Full format in `references/tables.md`.

Activity = what got accomplished. Description = what was supposed to be accomplished. Different audiences.

### Outcome-evidence rule (the closeout-must-prove-it-works rule)

Closure requires citing **outcome-evidence per done-when item, not input-evidence**. Input-evidence is what got produced (artifacts, edits, commits). Outcome-evidence is what those artifacts cause when exercised — does the system actually behave the intended way end-to-end?

- ❌ Insufficient — input-evidence: *"Edited FRAMEWORK.md §10.3 (commit X)"*, *"Tier 1 fixtures pass 7/7"*, *"All three doc edits landed"*
- ✅ Sufficient — outcome-evidence: *"Live agent emits §12 Appendices subsection per spec — verified via session sesn_01XvTPN…"*, *"End-to-end run against synthetic CSV produces 12-section report with §12 data-interpretation populated"*

When outcome-evidence requires deferred validation (an eval run, a next-task verification session, a downstream consumer's confirmation), the closeout must say so explicitly:

> *"Closure pending outcome-evidence — to be verified by [linked task]; reopen if validation fails."*

Don't close on input-evidence and frame the deferred validation as a backlog item — the closure itself stays conditional until outcome is observed. This rule exists because input-evidence closures repeatedly missed real drift between artifact and behavior; see PBI 86e134hpp friction-test #1 and #2 for the originating incidents.

Full closeout format with outcome-evidence examples in `references/tables.md`.

## Surface tags

Applied at completion (NOT creation). Multiple surfaces → multiple tags. Tag values: `claude-chat`, `claude-code`, `claude-cowork`, `claude-chrome`, `claude-design`, `claude-excel`, `claude-powerpoint`, `claude-platform`. Full list and usage in `references/tables.md`.

## Milestones

ClickUp's built-in milestone flag (diamond icon) marks phase boundaries. Naming: `M1: <n>`, `M2: <n>`, etc. One milestone per phase, marking phase **exit**. Closed when all phase tasks `complete` AND end-of-phase audit performed.

## Discovered work routing

When new work surfaces, route by relationship to current task:

- Part of current task → **subtask**
- Different task, same phase → **new task in phase list**, status `to do`
- Out of scope / future / factory work → **task in `Backlog / Operations`**, tagged
- Retrospective observation → **comment on `Project Build Insights` in `_Governance`**

Full routing table in `references/tables.md`.

## Insights vs. backlog (must keep separate)

Insights are **retrospective** ("I just learned X"). Backlog items are **prospective** ("I want to do X eventually"). Different containers, never combined.

- Insights → comment on `Project Build Insights` task in `_Governance`. Rolling log, never closed.
- Backlog → task in project's `Backlog / Operations` list, tagged `product-backlog`, `project-backlog`, or `roadmap`.

**Backlog lifecycle:** items NEVER move to a phase list directly. Triage creates a real task in the appropriate phase list; the backlog item is then marked `complete` with closeout pointing to the new task. Tag changes from `*-backlog` to `roadmap` when committed.

## Parent/subtask sync (ClickUp doesn't auto-sync)

- All subtasks `complete` → manually move parent to `complete` via MCP
- Do not close a parent while subtasks remain open — surface and resolve first
- Audit at session close: no parent should be `to do`/`in progress` while all subtasks are `complete`

## MCP limitation: no comment editing

To correct a comment, post a new one: `Correction to comment [comment-id]: [corrected content]`. Do NOT delete and repost — loses the conversation thread.

## Cross-list task linkage

Subtasks auto-link to parents. Cross-list discovered tasks do NOT. Reference originating task in description: `Discovered while working on [task-id]: [description]`. Use ClickUp's "Linked Tasks" feature where appropriate.

## Quick self-check before reporting work as done

1. Status moved through `in progress` (not `to do` → `complete` directly)?
2. Closeout comment posted in required format?
3. **Each done-when item cited with outcome-evidence (system behaves the intended way), not input-evidence (artifact got produced)?** If any item's evidence is deferred, closeout explicitly says "pending outcome-evidence — verified by [linked task]; reopen if validation fails."
4. Surface tag(s) applied?
5. If subtasks exist — all `complete` before parent?
6. Discovered work routed correctly (subtask vs. new task vs. backlog vs. insight)?
7. Status strings spelled exactly: `to do`, `in progress`, `complete`?
