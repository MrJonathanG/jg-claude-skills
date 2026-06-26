# jg-claude-skills — Central Skill Registry

The single source of truth for the Claude skills used across projects. Skill
**bodies live here, once.** Projects never copy a skill in; they **reference** it
by pointer. An improvement made here propagates to every project that points at it.

This repo is also the working surface for the daily **sync routine** that keeps
the registry's stated state honest against what's actually on disk (see
[`routines/`](routines/) once configured).

---

## Architecture decisions

These are settled. The repo is built to enforce them; don't re-litigate them.

1. **Bodies live once, centrally.** Every skill's executable body (`SKILL.md`,
   `references/`, `evals.json`) lives in this repo under `skills/<name>/`. It is
   **never copied into a project.** One canonical copy, version-controlled here.

2. **Projects reference by pointer, not by copy.** A project that uses a skill
   records a *pointer*: **name + location + a short, stable description.**
   - **No version pin.** (See #3.)
   - **No restated trigger.** The precise activation trigger lives inside the
     skill body's `description` frontmatter — restating it in the project just
     creates a second copy that drifts. The pointer's description is a stable
     one-liner of *what the skill is for*, not *when it fires*.
   See [`standards/pointer-rule.md`](standards/pointer-rule.md).

3. **Versioning is floating by default.** Projects track the *current* skill.
   When a skill improves here, every project gets the improvement automatically —
   that's the whole point of pointers. **Pinning is a rare, explicit exception**,
   done by pointing at a *frozen location* (e.g. a tagged path), never via a
   "version" field on the pointer. See [`standards/change-control.md`](standards/change-control.md).

4. **GitHub is the executable source of truth.** Not a mirror, not a backup —
   the canonical copy. Local synced installs (`~/.claude/skills/`) are
   *downstream* of this repo. When the two diverge, this repo wins and the
   divergence is surfaced for reconciliation, never silently overwritten.

5. **Shared-skill changes are propose-then-approve.** Because one edit here
   reaches every project, no automation may silently rewrite a skill body. The
   sync routine *proposes* (issue/PR); a human approves. See
   [`standards/change-control.md`](standards/change-control.md).

---

## How the registry works

```
jg-claude-skills/
├── README.md                 ← this file (architecture + how it works)
├── SKILL_REGISTRY.md         ← the index: name → path → stable one-liner
├── skills/                   ← skill bodies (the source of truth)
│   └── <skill-name>/
│       ├── SKILL.md          ← frontmatter (name, description=trigger) + body
│       ├── README.md         ← human docs (optional but recommended)
│       ├── references/       ← on-demand detail loaded by the skill
│       └── evals.json        ← eval cases (optional)
├── standards/                ← the rules the registry enforces
│   ├── skill-format.md       ← what a well-formed skill looks like
│   ├── pointer-rule.md       ← name + location + stable-desc; no version; no trigger
│   └── change-control.md     ← floating vs. pinned; propose-then-approve
├── templates/                ← copy-paste starting points
│   ├── project-instructions-template.md
│   └── bootloader-template.md
├── scripts/
│   └── reconcile-registry.sh ← registry-vs-reality reconciliation (the routine's job)
└── routines/                 ← the daily sync routine definition
```

- **Add a skill:** create `skills/<name>/` per [`standards/skill-format.md`](standards/skill-format.md),
  then add one row to [`SKILL_REGISTRY.md`](SKILL_REGISTRY.md).
- **Use a skill in a project:** copy a pointer from
  [`templates/project-instructions-template.md`](templates/project-instructions-template.md).
  Pointer = name + location + stable one-liner. Nothing else.
- **Change a skill:** edit the body here, on a branch, via PR. The change reaches
  every pointing project once merged (floating). To *not* propagate, pin (rare).

## Install (downstream)

These skills auto-install at `~/.claude/skills/` via the Claude Code
personal-skills mechanism. That install is **downstream** of this repo — edits
land here first, version control happens here, then the install flow propagates.
Do not edit `~/.claude/skills/` directly; that path is managed by Claude Code and
the sync routine treats this repo as authoritative when the two diverge.

## The sync routine

A daily scheduled routine reconciles the registry's *stated* state against
reality and **proposes** (never silently applies) changes:

- Verifies `SKILL_REGISTRY.md` matches the actual `skills/` contents.
- Checks each skill's stated trigger/description for staleness signals (e.g.
  references to renamed paths) and opens an issue/PR — it does **not** rewrite
  skill bodies.
- Surfaces divergence between a local synced install and this repo — but only
  from a *local* session that can see both sides; the cloud routine reconciles
  repo-internal state only (it can't see any machine's `~/.claude/skills/`).

Output is a PR or issue against this repo for human review. See
[`routines/`](routines/) for the definition and creation path.
