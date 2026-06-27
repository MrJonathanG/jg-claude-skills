# Dev Session Protocol — Templates and Detailed Checklists

Detailed templates and checklists referenced from the main SKILL.md. Load this when actively running the protocol.

## The 4-line opener (full template)

When session-open verification passes, surface this exactly:

```
Working on: [task-id] — [task name]
Goal: [what this session will produce, one sentence]
Done when: [exit criteria, one sentence — multiple criteria allowed, separated by AND]
Out of scope: [optional — anything tempting that's explicitly not part of this session]
```

**Notes on each line:**

- **Working on** — task ID from the tracker plus the human-readable task name. Both, not just one.
- **Goal** — what this session produces. Single sentence. Active, not aspirational ("draft the system prompt v1.0," not "make progress on the prompt").
- **Done when** — measurable exit criteria. Should be checkable at session-close. Multiple criteria are fine but each should be testable independently.
- **Out of scope** — optional but useful when the work has tempting adjacent paths. Names what NOT to do.

The opener is a contract for the session. The close audit measures against it.

## The 5-part close summary (full template)

```
**Done this session:**
- [bullet against each opener exit criterion]
- [bullet for any loose-ends sweep findings — what was checked, what passed, what surfaced]

**Need from you:**
- [decisions awaited — naming choices, scope calls, approval gates]
- [producer-side actions — accounts, secrets, services, domain]
- [blockers — anything halting next session that user must clear]
- (or "Nothing — clean handoff")

**Insights logged this session:**
- [one-line proposed insight, action-oriented if behavioral — user approves before posting]
- [additional insights, one per line]
- (or "None")

**Backlog items added this session:**
- [proposed task title + 1-2 sentence description + suggested tag — user approves before posting]
- (or "None")

**Next session:**
[A] Drafted opener — copy-paste into a fresh chat:
    Working on: [next-task-id] — [name]
    Goal: [...]
    Done when: [...]
[B] Issues to resolve before next session:
    - [issue 1]
    - [issue 2]
    Recommend: [revise approach / change scope / different next task / pause for user input]
```

**A vs. B decision rule:**
- Use A when the session closed cleanly AND the next task is clear (in tracker, dependencies met, plan in place)
- Use B when something blocks the next session — user decision needed, scope ambiguity, broken state surfaced, deliverable not ready for handoff
- If unsure between A and B, default to B. Better to surface than skip.

## Loose-ends sweep — full checklist

The loose-ends sweep is the highest-value part of the close audit. It catches what the opener-criteria check misses. Run every check; surface anything broken.

### Code and repo state
- [ ] All work committed?
- [ ] All commits pushed to remote? (committed-but-not-pushed is a classic handoff trap)
- [ ] Branch state matches expectation? (still on the branch you should be on; not in detached HEAD; not on a feature branch when you meant main)
- [ ] No unexpected uncommitted changes? (stray edits in unrelated files often indicate scope creep)
- [ ] No orphaned branches created and forgotten about?

### Tracker state
- [ ] Tracker matches reality on disk/in repo? (if commit hash is referenced in closeout, the commit must exist and be pushed)
- [ ] All tasks touched this session reflect their actual state?
- [ ] Subtasks created mid-session have proper descriptions written?
- [ ] No "I'll fill that in later" placeholder text left in any task?
- [ ] Parent/subtask sync verified (defer to clickup-pm-workflow for the rule)

### Decisions and discoveries
- [ ] Any decisions made during the session captured somewhere? (in code comments, task descriptions, insights, or session summary)
- [ ] Anything you'd ask "did we do that?" later is captured?
- [ ] Any insights that surfaced — proposed for `Project Build Insights`?
- [ ] Any prospective work that surfaced — proposed for backlog?

### Scope integrity
- [ ] Anything attempted that fell out of opener scope? (note in close summary, decide whether to keep or revert)
- [ ] Anything skipped from opener scope? (note as deferred or as failed criterion)
- [ ] Half-done work — captured as a follow-up task or noted as in-progress?

### Outcome-evidence check (the closure-must-prove-it-works check)
- [ ] For each opener "Done when" criterion, ask: what behavior change does this produce, and have I **observed** that behavior?
- [ ] Distinguish input-evidence (artifact produced — edits made, fixtures pass, commit landed) from outcome-evidence (system behaves the intended way end-to-end when exercised).
- [ ] If outcome-evidence is deferred to a downstream task / eval run / live session, the close summary flags the deferral explicitly with the linked validation task — per `clickup-pm-workflow`'s outcome-evidence rule.
- [ ] Default is **not** "clean handoff" when any criterion has input-evidence only. Either upgrade evidence by running the verification before closing, or route the validation as its own next-session task and let the closeout stay conditional.

### Cross-surface handoffs
- [ ] If work was sent to another Claude surface (Code, Cowork, Excel, etc.), is the handoff brief written and complete?
- [ ] If receiving a handoff this session, is the receiving state aligned with what was sent?

If any check fails → surface in close summary, do NOT mark session "clean handoff."

## End-of-phase audit (full checklist)

Run this only when the closing session is also completing a phase/milestone.

### Phase completeness
- [ ] All tasks in the phase are `complete` (run tracker query, not from memory)
- [ ] Milestone task for the phase identified and ready to close
- [ ] No tasks in the phase still `to do` or `in progress`
- [ ] No subtasks under any phase task left open

### Phase deliverables
- [ ] Artifacts produced during the phase (outside the tracker) are committed and accessible
- [ ] Documentation (if any was a phase deliverable) updated
- [ ] Cross-storage check: phase artifacts in repo, tracker, drive, and other surfaces are aligned

### Phase capture
- [ ] No insights pending capture from earlier in the phase
- [ ] No backlog items pending capture from earlier in the phase
- [ ] Phase-level retrospective insight (if any) captured to `Project Build Insights`

### Phase summary proposal
After all checks pass, propose a phase summary for the user covering:
- What the phase produced (deliverables list)
- Key decisions made during the phase
- Insights logged during the phase (linked to `Project Build Insights` comments)
- What changed between phase start and phase end
- Recommended entry point for the next phase

User approves or revises; on approval, post phase-completion comment per `clickup-pm-workflow` and close the milestone task.

If any phase check fails → surface gaps. Do NOT declare phase complete.

## Stop-and-surface — what to write when halting

When a stop-and-surface trigger fires, format the halt clearly:

```
HALT — [type of issue]

What I see: [the broken state, factually]
What I expected: [what the protocol expected to find]
Why I'm stopping: [the specific risk if I proceed on this state]

Need from you: [the decision or action needed to resume]
```

Don't attempt to silently reconcile. Don't proceed with caveats. Halt fully, surface, wait.

## Recognizing handoff moments without explicit cue

Phrases that signal a session boundary without explicitly saying "close this session":

- "Let's send this to [Cowork / Code / a different surface] now"
- "I'll continue this in a fresh chat"
- "Moving on to a different task"
- "Hand this off to [Code / Cowork] to finish"
- "We're at a stopping point"
- "Let's switch gears"
- "Save what we have and pick up later"
- "I need to step away for a while"
- "This is taking too long, let me regroup"

When you infer a boundary, propose the audit rather than assume:

> *"Sounds like we're closing this session — want me to run the audit and prep the handoff?"*

User confirms or skips. If skipped, note in conversation that audit was offered and declined; if user later says "what was left undone," that's the answer.

## Bootstrap instruction (for global Claude preferences)

To make Claude proactively recognize session boundaries even without explicit cue, copy this into global Claude preferences:

```
Apply the dev-session-protocol skill at the start of any development session
and when wrapping one. Recognize handoff moments even without explicit cue —
when conversation signals a boundary (cross-surface handoff, task change,
"continue in a fresh chat"), propose the audit before context is lost.
```

This is opt-in. The skill works fine without it; the bootstrap just raises sensitivity to inferred boundaries (vs. relying only on explicit phrases like "wrap this session").

## Failure modes the audit prevents (full list)

The skill exists because sessions hand off poorly when:

- Work is "done" but the commit isn't pushed
- Opener said do X and Y; only X happened, Y is half-done and silent
- A subtask got created but no one wrote what it's supposed to produce
- Task marked `complete` in tracker but the deliverable lives in a different state on disk
- Insights and backlog items surface mid-session and never get logged
- Decisions made during the session aren't captured anywhere
- Branch state is unexpected (still on a feature branch, detached HEAD, stray uncommitted changes)
- Cross-surface handoff brief is incomplete or missing entirely
- Half-done work has no follow-up tracking item

The audit's loose-ends sweep targets each of these explicitly.
