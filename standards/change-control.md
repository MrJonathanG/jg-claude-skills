# Standard: change control

How skills change, who approves, and how floating vs. pinned works. Because one
edit here can reach every project that points at the skill, change control is
deliberately conservative.

## Floating by default

Projects track the **current** skill. A pointer names a location, not a version,
so when the body at that location improves, every pointing project gets the
improvement on its next run. This is the intended behavior — make a fix once,
everyone benefits.

Implication: **a change to a shared skill is a change to every consumer.** Treat
edits accordingly.

## Propose-then-approve (no silent body rewrites)

No automation may silently rewrite a skill body. That specifically includes the
daily sync routine.

- The routine may **read** the registry, **compare** it to reality, and
  **propose** changes as an **issue or PR**.
- A **human approves and merges.** Until then, the body is unchanged.
- This applies to staleness fixes (renamed-path references, drifted
  descriptions) just as much as to feature edits — the routine flags them, a
  person decides.

Rationale: the blast radius of a shared-skill edit is every project. The cost of
a wrong automated rewrite is paid everywhere at once; the cost of a human review
is paid once.

## Editing a skill (the normal path)

1. Branch.
2. Edit the body under `skills/<name>/`.
3. If the change alters *what the skill is for*, update the one-line description
   in `SKILL_REGISTRY.md` too. Do **not** chase trigger wording into project
   pointers — they reference by stable description, not trigger.
4. PR → review → merge. Floating means it propagates on merge.

## Pinning (the rare exception)

Sometimes a project must *not* receive a change (e.g. it depends on exact current
behavior during a freeze). Pin by pointing at a **frozen location**, not by
adding a version field to the pointer:

- Tag or branch this repo at the desired state, and point the project at the
  path as of that ref, **or**
- Copy the body into a clearly-named frozen path within the registry (e.g.
  `skills/_frozen/<name>@<reason-or-date>/`) and point there.

Pinning is opt-out from propagation and should be:

- **Explicit** — obvious from the location that it's frozen.
- **Documented** — why and until when, in the project's instructions.
- **Temporary** — pins are debt; the default is to float.

## What the routine enforces here

- Flags `SKILL_REGISTRY.md` rows with no matching `skills/` directory and
  vice-versa (registry-vs-reality drift).
- Flags staleness signals in skill descriptions/triggers (renamed-path
  references, descriptions that read like restated triggers).
- Opens an issue/PR with findings. **Never** edits a body on its own.
