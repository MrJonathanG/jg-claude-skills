# clickup-pm-workflow

Opinionated ClickUp project-tracking conventions, sitting on top of the ClickUp MCP. Encodes hierarchy decisions, exact status vocabulary, closeout format, surface tags, parent/subtask sync rules, and the discovered-work routing matrix — including the **outcome-evidence rule** for closure comments.

## What it does

The ClickUp MCP handles API mechanics (status changes, comments, task creation). This skill handles workflow decisions: which list a task lives in, what status strings to use, what a closeout comment must contain, which tag to apply when work moves to `complete`, where insights go versus where backlog items go.

The most important decision the skill encodes is the **outcome-evidence rule for closeout**: a task closes on evidence that the system behaves the intended way end-to-end, not on evidence that artifacts got produced. Input-evidence (edits made, commits landed, fixtures pass) is necessary but not sufficient. The rule has examples and a deferred-validation pattern for cases where outcome-evidence requires a downstream consumer that doesn't exist yet.

Detailed lookup tables (closeout format with outcome-evidence examples, surface tag catalogue, discovered-work routing, status transition table, insights vs. backlog distinction) live in `references/tables.md`. Load that when actively performing tracking operations.

## When it activates

Triggers on:

- Any ClickUp work in the conversation — status changes, task creation, closeout, milestone management
- Phrases like "close this task," "mark complete," "update the tracker," "create a subtask," "what tag should this get"
- Project tracking discussions even without an immediate API call
- Compositions with `dev-session-protocol` (which calls into this skill for tracker sync)

Doesn't trigger on:

- General project management discussion that doesn't reference ClickUp specifically
- Discussions about tracking philosophy that aren't actionable
- Use of other PM tools (Linear, Jira, etc.) — those need different conventions

## What you need to provide

The skill works without configuration; a few things in the conversation context make it sharper:

| Required/Optional | What to specify | Example |
|---|---|---|
| Required for API actions | ClickUp MCP authenticated and available | The skill cannot make tracker calls without the MCP |
| Recommended | The task ID being worked on | "Working on 86e1bhbn6" — anchors closeout and parent-sync checks |
| Recommended | Which surface is doing the work | Determines which `claude-*` surface tag to apply at close |
| Optional | Parent task ID if working on a subtask | Lets the skill audit parent-state at close |
| Optional | Existing tags / lists / milestones in the project | Helps the skill route discovered work correctly |

## What it produces

When the skill fires, expect:

- Status changes using exact strings (`to do`, `in progress`, `complete` — lowercase, with space, no hyphens or alternatives)
- Closeout comments in the format specified in `references/tables.md`, with the **Done:** block citing outcome-evidence per done-when item
- Deferred-validation flagging when outcome-evidence isn't yet observable — closeout explicitly says "pending outcome-evidence — verified by [linked task]; reopen if validation fails"
- Surface tags applied at completion (not at creation)
- Discovered work routed correctly (subtask under current, new task in phase list, backlog item, or insight comment — not all four interchangeable)
- Parent/subtask sync handled manually (ClickUp doesn't auto-sync; the skill catches `to do` parents with all-`complete` subtasks)
- A correction-comment pattern when a posted comment is wrong (no edit support in MCP — post a new "Correction to comment [id]" rather than delete-and-repost)

## Composition with other skills

- **`dev-session-protocol`** — composes tightly. dev-session-protocol's close-audit step delegates tracker operations here. dev-session-protocol's loose-ends sweep also references this skill's outcome-evidence rule for the closeout-content check. Don't disable either when both apply.
- **`app-build-orchestrator`** — independent. Build orchestration may create tasks; this skill formats the closeout when those tasks close. No interference.
- **`skill-creation-protocol`** — independent. The protocol may co-fire if a skill creation is being tracked as ClickUp work, but neither calls the other.

This skill doesn't call other skills directly. It's loaded as context when ClickUp work is happening.

## Common usage patterns

**Closing a task with outcome-evidence:**
> User: "Mark TST-X complete — fixtures pass."
>
> Claude (with clickup-pm-workflow): asks whether the live consumer behavior was verified. If yes — closes with outcome-evidence citation. If no — proposes either running the live verification before closing, or closing with "pending outcome-evidence — verified by [linked task]" wording.

**Closing a task with deferred outcome:**
> User: "Close SPEC-X — the spec edits are committed and the eval task is queued."
>
> Claude (with clickup-pm-workflow): closes with the deferred-validation pattern. **Done:** input-evidence summary + "pending outcome-evidence — to be verified by TST-X (linked); reopen if validation fails." Routes the live verification as a tracked next task, not a free-floating expectation.

**Discovered work mid-task:**
> User: "While doing this I noticed an unrelated bug in X."
>
> Claude (with clickup-pm-workflow): asks whether the bug is part of the current task (subtask), a separate concern in this phase (new task in phase list), out-of-scope (backlog item), or a retrospective lesson (insight). Routes per the discovered-work table. Never merges into the current task's description.

**Parent/subtask drift at session close:**
> User: "Wrap this session."
>
> Claude (with dev-session-protocol + clickup-pm-workflow): the session protocol's loose-ends sweep delegates the parent-sync audit here. If any parent is `to do` or `in progress` while all subtasks are `complete`, the skill surfaces it as a sweep failure — close summary cannot mark "clean handoff" until reconciled.

**Correcting a posted comment:**
> User: "The closeout I just posted has a wrong commit hash."
>
> Claude (with clickup-pm-workflow): doesn't try to delete-and-repost (loses thread). Posts a new comment `Correction to comment [id]: [corrected content]`.

## Common mistakes

- **Closing on input-evidence and routing the live verification as a backlog item.** Backlog is for prospective work, not "I'll verify later." Use the deferred-validation pattern instead — the closure stays conditional, the linked task carries the verification.
- **Skipping `in progress`.** Direct `to do` → `complete` is incorrect. Even brief work passes through `in progress` so the audit trail reflects reality.
- **Using `done` instead of `complete`** (or `todo` instead of `to do`, or `in-progress` with a hyphen). ClickUp MCP rejects variants. The lowercase-with-space form is the only valid input.
- **Applying surface tags at task creation.** Tags reflect what surface actually did the work. Applied at completion.
- **Combining insight and backlog containers.** Insights are retrospective ("I just learned X"); backlog items are prospective ("I want to do X eventually"). Different lifecycles, different audiences, never merged.
- **Moving backlog items into phase lists by reassignment.** Triage creates a real task in the phase list; the backlog item is then marked `complete` with closeout pointing to the new task. Tag transitions from `*-backlog` to `roadmap`.
- **Editing a posted comment via delete-and-repost.** MCP doesn't support edit; the new-comment correction pattern preserves thread.

## Files in this skill

- `SKILL.md` — the skill itself (Claude reads this)
- `README.md` — this file (human-readable documentation)
- `references/tables.md` — closeout format with outcome-evidence examples, deferred-validation pattern, surface tags catalogue, status transition table, discovered-work routing, insights vs. backlog distinction, milestone naming, parent/subtask sync rules; loaded on demand when actively performing tracker operations
- No evals/ folder — skipped intentionally. The rules this skill enforces (status string casing, closeout content quality, parent-sync correctness, outcome-evidence in closeout phrasing) are post-hoc assertions about closeout comment text and tracker state, not behaviors that map cleanly to skill-firing test cases. The closure-evidence rule in particular governs the quality of natural-language closeout phrasing, which isn't easily testable as an isolated skill response. Re-evaluate eval inclusion after 5-10 closeout reviews under the new rule reveal what patterns repeat.
