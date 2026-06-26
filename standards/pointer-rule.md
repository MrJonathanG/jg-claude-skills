# Standard: the pointer rule

How a project refers to a registry skill. This is the load-bearing convention
that lets bodies live once and improvements propagate everywhere.

## A pointer has exactly three parts

| Part | Example | Why |
|---|---|---|
| **name** | `project-context-sync` | Identifies the skill; matches the registry row and the skill's `SKILL.md` `name`. |
| **location** | `jg-claude-skills/skills/project-context-sync/` | Where the body lives. The single canonical copy. |
| **stable description** | "Keeps a project's living context in sync across sessions." | One line of *what it's for*, written to stay true across edits. |

That's it. Three parts.

## What a pointer must NOT contain

- **No version pin.** Pointers float — they track the current skill so an
  improvement made once reaches every project. Pinning is a rare exception and
  is done by changing the *location* to a frozen path, never by adding a version
  field here. See [`change-control.md`](change-control.md).
- **No restated trigger.** The precise "when does this fire" lives once, inside
  the skill body's `description` frontmatter. Copying it into the pointer creates
  a second copy that silently drifts from the real trigger. The pointer's
  description says *what the skill is for*, not *when it activates*.

## Why "stable description," specifically

The description is the one free-text field, so it's the one that tempts drift.
Write it to describe the skill's *enduring purpose*, not its current mechanics:

- ✅ "Keeps a project's living context in sync across sessions."
- ❌ "Runs the close ceremony with skill-trigger validation and the
  create-project-instructions entry path." ← restates current internals; will
  be wrong after the next edit, and quietly contradicts the real trigger.

If a pointer's description starts describing *steps* or *triggers*, it has
drifted out of spec. The routine flags descriptions that look like restated
triggers (imperative step lists, phrase-match lists) as staleness signals.

## Canonical pointer form

```
- **project-context-sync** — `jg-claude-skills/skills/project-context-sync/`
  Keeps a project's living context in sync across sessions.
```

See [`../templates/project-instructions-template.md`](../templates/project-instructions-template.md)
for the full block a project drops in.
