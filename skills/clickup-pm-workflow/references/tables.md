# ClickUp PM Workflow — Reference Tables

Detailed lookup tables and formats referenced from the main SKILL.md. Load this when actively performing tracking operations.

## Status transitions (full table)

| From | To | Trigger |
|---|---|---|
| `to do` | `in progress` | Work begins on the task in a session |
| `in progress` | `complete` | Work done AND closeout comment posted |
| `to do` | `to do` (no change) | Discovered during planning; no work yet |
| Any | `to do` | Reopened (rare; requires explanation comment) |

Moving directly from `to do` to `complete` without an `in progress` interval is incorrect. Even brief work passes through `in progress`.

## Task / subtask / comment decision criteria

| Type | Use when | Example |
|---|---|---|
| Task | Distinct deliverable with a clear done-state | "Draft system prompt v1.0" |
| Subtask | Bounded work that emerged during the parent task; too distinct for a comment but too dependent to stand alone | "Fix typo in NIST mapping" (came up while drafting prompt) |
| Comment | Incremental progress on existing task; not a new tracking item | "Tested with 3 sample incidents, all rendered correctly" |

**Test:** if you'd want to know later "did we do that thing?" → task or subtask. If it's just "the work continues" → comment.

## Closeout comment format

When a task closes (status → `complete`), post a closeout comment in this exact format:

```
**Done:** [outcome-evidence per done-when item — see Outcome-evidence rule below]
**Surface:** [Claude service tag(s) used during execution]
**Commits:** [hash(es) if applicable, or "n/a"]
**Notes:** [anything worth knowing later — optional]
```

Activity = what got accomplished. Description = what was supposed to be accomplished. Different audiences: description is for the person starting work; activity is for the person reviewing what got done.

### Outcome-evidence rule (closeout content)

The **Done:** block must cite outcome-evidence per done-when item — what the system actually does when exercised — not input-evidence (what artifacts got produced). Input-evidence is necessary but not sufficient: it proves something was written; it does not prove the system behaves the intended way.

Examples — closing the same task two ways:

| Done-when item | ❌ Input-evidence (insufficient) | ✅ Outcome-evidence (sufficient) |
|---|---|---|
| Spec edit lands new clause | "Edited FRAMEWORK.md §10.3 (commit X)" | "Live agent emits §12 Appendices subsection per spec — verified via session sesn_01XvTPN…" |
| Test fixtures cover new behavior | "Tier 1 fixtures pass 7/7" | "Tier 1 fixtures pass 7/7 AND live agent run against synthetic CSV emits the same data-interpretation surface as the fixtures — verified [session]" |
| Wrapper script supports new flag | "Added --input-file handling to wrapper.sh" | "Wrapper opens session with file mounted at /mnt/session/uploads/inputs/<file>; agent reads file at that path and emits report — verified [session]" |
| Doc clarification | "Added paragraph to README" | "Reader following the new paragraph reaches the intended action without further questions — verified by [reviewer / next-session opener that consumed it]" |

### Deferred-validation pattern

When outcome-evidence requires a downstream consumer (eval run, next task, live test session) that doesn't exist yet, the closeout must explicitly defer:

```
**Done:** [Input-evidence summary], pending outcome-evidence — to be verified by [linked task];
         reopen if validation fails.
**Surface:** ...
**Commits:** ...
```

Do not silently close on input-evidence and frame the deferred validation as a backlog item. The closure itself is conditional until the linked validation runs. Reopen this task — don't just observe failure in the downstream task — if validation surfaces a gap between artifact and intended behavior.

### Why this rule exists

Input-evidence closures repeatedly missed drift between artifact and behavior. Originating incidents in PBI 86e134hpp friction-test entries (occurrence #1 surface-keyword closure, occurrence #2 SPEC-MANUAL-DATA-INTERP premature closure on 2026-05-12). The rule promotes from "watch for the pattern" to "block closure that doesn't comply."

## Surface tags (full table)

Applied when status moves to `complete`. Multiple surfaces → multiple tags. No "multiple" meta-tag.

| Tag | Used for |
|---|---|
| `claude-chat` | Drafting, design, conversation, planning |
| `claude-code` | Repo, git, scripts, file ops, code work |
| `claude-cowork` | Async desktop work, batch jobs, file/data prep |
| `claude-chrome` | Browser-based testing, scraping, UI validation |
| `claude-design` | Visual artifacts, presentations, decks |
| `claude-excel` | Spreadsheet work |
| `claude-powerpoint` | Slide work |
| `claude-platform` | platform.claude.com UI work, deployment via Console |

## Discovered work routing (full table)

| Relationship to current task | Destination |
|---|---|
| Part of the current task | Subtask under current task |
| Different task, same milestone/phase | New task in appropriate phase list, status `to do`, with brief description |
| Out of scope for current MVP / future feature / factory work | Task in project's `Backlog / Operations` list, tagged `product-backlog`, `project-backlog`, or `roadmap` |
| Retrospective observation worth remembering | Comment on `Project Build Insights` task in `_Governance` |

## Insights vs. backlog (distinguishing)

| Item | Container | Format | Lifecycle |
|---|---|---|---|
| Insight | Comment on `Project Build Insights` task in `_Governance` | One line, action-oriented if behavioral | Never closed; rolling log |
| Backlog item | Task in project folder's `Backlog / Operations` list | Title + 1–2 sentence description, tagged | Triaged into real work when committed; tag changes from `*-backlog` to `roadmap` |

**Test:**
- "I just learned X about how to do this work" → insight
- "I want to do X eventually" → backlog item

Insights are **retrospective**; backlog items are **prospective**.

## Backlog tag taxonomy

| Tag | Meaning |
|---|---|
| `product-backlog` | Feature/capability for the product itself |
| `project-backlog` | Tooling/automation for the build process |
| `roadmap` | Committed-to-future work (was a backlog item, now committed) |

Backlog items NEVER move to a phase list directly. Triage creates a real task in the appropriate list; the backlog item is marked `complete` with closeout pointing to the new task.

## Parent/subtask sync rules

ClickUp does NOT auto-sync parent task status when subtasks complete.

- When all subtasks of a parent are `complete`, move the parent to `complete` manually via MCP.
- Do not close a parent while subtasks remain open — surface this and resolve before closing.
- During session-close audit, validate that no parent is `to do` or `in progress` while all its subtasks are `complete`.

## ClickUp MCP limitations

**Comment editing is not supported via MCP.** To correct a comment:

- Post a new comment referencing the original comment ID
- Format: `Correction to comment [comment-id]: [corrected content]`
- Do NOT delete and repost — that loses the conversation thread.

## Cross-list task linkage

When a subtask is created, ClickUp auto-links it to its parent. Cross-list discovered tasks (different milestone) are NOT auto-linked.

- Reference the originating task in the new task's description: `Discovered while working on [task-id]: [description]`
- Use ClickUp's "Linked Tasks" feature where appropriate

## Milestone naming and lifecycle

- Use ClickUp's built-in milestone flag (diamond icon) on tasks marking phase boundaries
- Naming: `M1: <name>`, `M2: <name>`, etc.
- One milestone task per phase, marking the **exit** of that phase
- Closed when all tasks in its phase are `complete` AND the end-of-phase audit has been performed
