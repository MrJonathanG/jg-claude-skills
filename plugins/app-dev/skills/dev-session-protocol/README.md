# dev-session-protocol

Session boundary discipline for development work. Governs WHEN open/close ceremony happens; other skills handle HOW the work inside that ceremony is recorded. The skill enforces a 4-line opener, a 5-part close summary that doubles as the next-session handoff, a loose-ends sweep that includes an **outcome-evidence check**, and stop-and-surface triggers for broken state.

## What it does

Development sessions accumulate loose ends silently: work "done" but not pushed, opener criteria half-met without anyone noticing, decisions made and not captured, tracker state drifting from disk. This skill imposes a structured boundary at both ends of a session to catch those gaps.

At session start, the skill runs entry-condition checks and surfaces a 4-line opener that names the contract for the session (task, goal, exit criteria, optional out-of-scope). At session close, the skill runs an exit-criteria audit against that opener, a loose-ends sweep (commits pushed, subtask descriptions written, decisions captured, **outcome-evidence per criterion** observed not just artifact-produced), a tracker sync delegated to `clickup-pm-workflow`, and a 5-part close summary that's copy-paste-ready as the next session's opener.

The outcome-evidence check is the highest-value addition in the current version: a session is not "clean handoff" if any Done-this-session bullet is input-evidence-only. The skill defers to `clickup-pm-workflow` for the exact closeout phrasing rules; this skill governs the session-level audit that catches the gap before the closeout is even composed.

Full templates and checklists (4-line opener structure, 5-part summary, loose-ends sweep including the outcome-evidence section, end-of-phase audit) in `references/templates.md`.

## When it activates

Triggers on:

- Explicit phrases at session start: "start a session," "new session," "working on [task]"
- Explicit phrases at session close: "wrap this session," "close this session," "session handoff," "audit and close," "prep next prompt"
- Inferred handoff moments: cross-surface routing ("send this to Cowork"), session change ("continue in a fresh chat"), task change ("moving on to..."), natural stopping points

Doesn't trigger on:

- Mid-session work that doesn't involve crossing a session boundary
- Tracker operations themselves (those route to `clickup-pm-workflow`)
- Pure discussion or planning that doesn't end with a handoff or close

The skill stays out of the way during the body of a session — it activates at boundaries.

## What you need to provide

The skill works without configuration. A few things make the audit sharper:

| Required/Optional | What to specify | Example |
|---|---|---|
| Required at open | The task being worked on, by ID | "Working on 86e1bhbn6" — anchors entry-condition checks |
| Recommended at open | The opener's "Done when" criteria | The close audit measures against these — they're the contract |
| Recommended | Whether work is on a feature branch or main | The loose-ends sweep checks repo state |
| Optional | Whether this session is closing a phase/milestone | Activates the end-of-phase audit extension |
| Optional | Cross-surface handoff context | Helps the close summary include the handoff brief |

If the opener provides nothing, the close audit still runs the structural checks (commits pushed, tracker sync, outcome-evidence check) but can't measure against opener-specific criteria.

## What it produces

When the skill fires at session start, expect:

- Entry-condition verification — tracker state matches claim, dependencies present, repo state matches expectation, parent task in valid state
- Stop-and-surface if any check fails (don't proceed with caveats)
- The 4-line opener block surfaced for the user

When the skill fires at session close, expect:

- Exit-criteria audit — each opener "Done when" item evaluated for outcome (did it actually happen the way the opener said?)
- Loose-ends sweep — commits pushed, subtask descriptions, decisions captured, tracker matches disk, **outcome-evidence per criterion** (system behaves the intended way end-to-end, not just artifact produced)
- Tracker sync — delegated to `clickup-pm-workflow` (status, closeout comment with outcome-evidence per its rule, surface tags, parent-sync)
- 5-part close summary — Done-this-session (outcome-evidence cited per bullet), Need-from-you, Insights-logged, Backlog-added, Next-session (drafted opener if clean handoff; issues-to-resolve if not)
- End-of-phase audit if a phase is closing
- Pushback if the user asks to mark "clean handoff" while any criterion is input-evidence-only — either upgrade the evidence by running the verification, or route the verification as a tracked next-session task

## Composition with other skills

- **`clickup-pm-workflow`** — tight composition. The close audit's tracker-sync step calls this skill; the loose-ends sweep's outcome-evidence check defers to it for closeout phrasing. State *what* needs to happen; let `clickup-pm-workflow` state *how*.
- **`app-build-orchestrator`** — independent. Both can pause sessions, but for different reasons. `app-build-orchestrator` pauses for producer-side actions (domain purchase, account setup, secrets). This skill halts for broken state (entry conditions failed, tracker contradicts reality, work skipped silently).
- **`skill-creation-protocol`** — independent. The protocol may co-fire if a session involves creating a skill; the session protocol still runs at the boundaries.

This skill doesn't call other skills directly. It loads as context at session boundaries and delegates specific operations.

## Common usage patterns

**Clean session open:**
> User: "Start a session — working on TST-Y."
>
> Claude (with dev-session-protocol): runs the four entry checks. If all pass, surfaces the 4-line opener and proceeds. If any fail, stops and surfaces the contradiction (tracker says `complete`, no prerequisite met, branch state unexpected, etc.).

**Inferred handoff:**
> User: "Send this over to Cowork now."
>
> Claude (with dev-session-protocol): recognizes the cross-surface handoff cue, proposes running the close audit before context is lost: *"Sounds like we're closing this session — want me to run the audit and prep the handoff brief?"* User confirms or skips.

**Close with outcome-evidence gap:**
> User: "Wrap this session — spec edits committed."
>
> Claude (with dev-session-protocol): runs the close audit. Outcome-evidence check asks: did the live consumer (agent run, fixture exercise, downstream task) actually verify the spec-edit's intended behavior? If only the commit is observed, the session is not "clean handoff" — either propose running the live verification now (if it's cheap), or route the verification as a tracked next task and mark Done-this-session bullets with "pending outcome-evidence — verified by [linked task]" per `clickup-pm-workflow`'s rule.

**End-of-phase session:**
> User: "Closing M2."
>
> Claude (with dev-session-protocol): runs the standard close audit plus the end-of-phase extension — all phase tasks `complete` (queried, not from memory), no pending insights/backlog from the phase, cross-storage alignment. If all pass, closes the milestone and proposes the phase summary. If any fail, surfaces the gap and does not declare the phase closed.

**Loose-ends sweep catches an unpushed commit:**
> User: "Close it out."
>
> Claude (with dev-session-protocol): loose-ends sweep runs `git status` / `git log origin/main..HEAD`. Finds local commits ahead of remote. Surfaces in close summary as a sweep failure — refuses to mark "clean handoff" until pushed.

## Common mistakes

- **Marking a session "clean handoff" with input-evidence-only Done bullets.** This is the failure mode the outcome-evidence check exists to catch. Either upgrade the evidence in-session or route the verification as a tracked next task with the deferred-validation phrasing.
- **Skipping the loose-ends sweep because "it all feels fine."** The sweep catches things that feel fine but aren't (committed but not pushed, subtask without description, decision in chat but not in code). Run every check.
- **Doing the tracker sync without delegating to `clickup-pm-workflow`.** Reinventing closeout phrasing here means duplication and drift. State *what* needs to happen; let that skill state *how*.
- **Stop-and-surface treated as a warning instead of a halt.** When an entry condition fails or a sweep finds something silently broken, the right response is "don't proceed" until reconciled — not "proceed with caveats."
- **Inferred-handoff detection too eager.** The skill should propose the audit when it sees a cross-surface or task-change signal, but the user confirms before running. Forcing the close in the middle of active work is worse than missing one inferred boundary.
- **End-of-phase audit run silently when no phase is closing.** Adds noise. The extension is opt-in based on whether the session is actually closing a milestone.

## Files in this skill

- `SKILL.md` — the skill itself (Claude reads this)
- `README.md` — this file (human-readable documentation)
- `references/templates.md` — full 4-line opener structure, 5-part summary template, loose-ends sweep checklist (including outcome-evidence section), end-of-phase audit checklist, stop-and-surface format, handoff phrase examples; loaded on demand when actively running the protocol
- No evals/ folder — skipped intentionally. The skill's primary outputs are session-boundary audits and natural-language close summaries; eval cases would need to validate audit completeness against synthetic session transcripts, which is heavyweight relative to the value. The composition rule with `clickup-pm-workflow` and the outcome-evidence check could plausibly be evalled in isolation; deferred until 5-10 session closes under the new rule reveal what cases repeat. Track skipping reason here so future reconsideration has context.
