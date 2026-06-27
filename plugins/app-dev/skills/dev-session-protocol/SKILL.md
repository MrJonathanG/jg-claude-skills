---
name: dev-session-protocol
description: Session boundary discipline for development work with Claude. Apply at the start of any work session (verify entry conditions, surface the 4-line opener) and at the end (audit completion, hunt loose ends, sync the project tracker, capture insights and backlog, draft the next-session handoff). Trigger explicitly on phrases like "start a session", "new session", "working on [task]", "wrap this session", "close this session", "session handoff", "prep next prompt", "audit and close". Also infer handoff moments without explicit cue — recognize cross-surface handoffs ("send this to Cowork", "continue in a fresh chat", "moving on"). Encodes the 4-line opener, 5-part close summary that doubles as the next-session handoff, end-of-phase audit when a session closes a milestone, and stop-and-surface triggers for broken state. Composes with clickup-pm-workflow (defers tracker conventions) and app-build-orchestrator (independent stop scopes).
---

# Dev Session Protocol

Session boundary discipline for development work. The **timing layer** for sessions: this skill governs WHEN open/close ceremony happens. Other skills handle HOW the work inside that ceremony is recorded.

For full templates and detailed checklists (4-line opener notes, 5-part summary, loose-ends sweep, end-of-phase audit, stop-and-surface format, handoff phrase list), see `references/templates.md`. Load that whenever actively running the protocol.

## Composition

- **Tracker operations** (status strings, closeout format, surface tags, parent-sync, backlog/insights routing) → defer to `clickup-pm-workflow`. State *what* needs to happen; let that skill state *how*.
- **Surface routing** (which Claude product to use) → defer to `app-build-orchestrator`. If user asks "Code or Chat?" mid-session, that's not this skill's question.
- **Stop scopes are different.** `app-build-orchestrator` pauses for producer-side actions (domain, accounts, secrets). This skill halts for broken state (entry conditions failed, tracker contradicts reality, work skipped silently).

## Why this skill exists

To prevent loose ends on session handoffs — work "done" but not pushed, opener criteria silently half-met, undocumented decisions, tracker state diverging from disk. The audit hunts these specifically. The close summary IS the handoff document — copy-paste ready for the next session.

## Session-open verification

Before producing any session output, run these checks:

1. **Tracker state matches claim.** Is the task being claimed actually `to do`? If `complete`, surface contradiction. If `in progress` from prior session, confirm continuation rather than assume.
2. **Dependencies present.** Inputs the task references — verify they exist or are accessible.
3. **Repo state matches expectation.** Expected branch, no unexpected uncommitted changes.
4. **Parent task in valid state.** Parent should be `in progress` (not `to do`, not `complete`).

If any check fails → **stop and surface, don't proceed.**

## The 4-line opener

When verification passes, surface this at session start:

```
Working on: [task-id] — [task name]
Goal: [what this session will produce, one sentence]
Done when: [exit criteria, one sentence]
Out of scope: [optional]
```

Brief, specific, oriented to the deliverable. The opener is the contract for the session — the close audit measures against it.

## Session-close audit

When wrapping a session:

**1. Exit criteria audit.** Did each opener "Done when" criterion get done? Anything skipped, half-done, or quietly deferred?

**2. Loose-ends sweep.** The high-value checks: code committed AND pushed, no stray scope creep, subtasks created mid-session have descriptions, decisions captured somewhere, tracker matches reality on disk. **Outcome-evidence check** — for every "Done when" item, ask "what behavior change does this produce, and have I observed it?" Input-evidence (artifact got made, tests pass against fixtures) is not the same as outcome-evidence (system behaves the intended way end-to-end). When outcome-evidence is deferred to a downstream task or eval run, surface that explicitly in the close summary so the closeout itself stays conditional — defer to `clickup-pm-workflow`'s outcome-evidence rule for the closeout phrasing. Full sweep checklist in `references/templates.md` — run every check.

**3. Tracker sync.** Perform per `clickup-pm-workflow` (closeout comment, surface tags, parent-sync, status transitions). This skill calls it; that skill defines it.

**4. Capture flows.** Insights → propose for `Project Build Insights`. Prospective work → propose as backlog. User approves before posting (per `clickup-pm-workflow`).

## The 5-part close summary (this IS the handoff)

```
**Done this session:** [bullets vs. opener criteria + loose-ends results — each bullet
                       cites outcome-evidence per opener criterion (system behaves the
                       intended way), not input-evidence (artifact got produced).
                       Deferred outcome-evidence → flag explicitly with the linked
                       validation task, per clickup-pm-workflow's outcome-evidence rule.]
**Need from you:** [decisions, approvals, producer-side actions, blockers — or "Nothing — clean handoff"]
**Insights logged this session:** [proposed text — user approves before posting, or "None"]
**Backlog items added this session:** [proposed text — user approves before posting, or "None"]
**Next session:** [A] Drafted opener for next task — copy-paste ready, OR [B] Issues to resolve before next session.
```

A if everything closed cleanly. B if something needs user resolution. Default to B if uncertain.

A session is **not** "clean handoff" if any Done-this-session bullet is input-evidence-only (artifact produced without verified outcome). Either upgrade the evidence by running the verification before closing, or flag the deferred-validation per `clickup-pm-workflow`'s outcome-evidence rule and route the validation as its own next-session task.

## End-of-phase extension

Run only when the closing session also completes a phase/milestone. Additional checks: all phase tasks `complete`, milestone task identified, no pending insights/backlog from earlier in phase, deliverables outside tracker accessible, cross-storage alignment.

If all pass → close milestone, post phase-completion comment, propose phase summary.
If any fail → surface gaps, do NOT declare phase complete.

Full phase checklist in `references/templates.md`.

## Recognize handoff moments without explicit cue

The user may not say "wrap this session." Infer the boundary when conversation signals one — cross-surface handoff ("send to Cowork now"), session change ("continue in a fresh chat"), task change ("moving on"), or natural stopping point.

When you infer a boundary, **propose** the audit: *"Sounds like we're closing this session — want me to run the audit and prep the handoff?"* User confirms or skips.

## Stop-and-surface triggers (priority halts)

Halt and surface immediately when:

- Entry condition fails at open
- Tracker shows contradictory state
- Repo state diverges from expectation
- Parent/subtask state inconsistent
- Phase-end audit fails
- Loose-ends sweep finds something silently broken

Don't reconcile silently. Don't proceed with caveats.

## Quick self-check before reporting session as closed

1. Every opener "Done when" criterion bulleted in the close summary?
2. **Each "Done this session" bullet cites outcome-evidence, not input-evidence?** (Deferred outcome → explicitly flagged with the linked validation task per `clickup-pm-workflow`'s outcome-evidence rule.)
3. Loose-ends sweep performed (commits pushed, subtask descriptions, decisions captured)?
4. Tracker sync delegated to `clickup-pm-workflow` and confirmed complete?
5. Insights and backlog proposals shown to user for approval before posting?
6. Next-session block populated (drafted opener OR explicit issues to resolve)?
7. If a phase closed: end-of-phase extension run, milestone task closed?

## Bootstrap instruction (optional, for global preferences)

To make Claude proactively recognize session boundaries without explicit cue, copy this into global Claude preferences:

```
Apply the dev-session-protocol skill at the start of any development session
and when wrapping one. Recognize handoff moments even without explicit cue —
when conversation signals a boundary (cross-surface handoff, task change,
"continue in a fresh chat"), propose the audit before context is lost.
```

Opt-in. The skill works without it; the bootstrap raises sensitivity to inferred boundaries.
