# Standard: skill format

What a well-formed skill in this marketplace looks like. New skills should match
this shape.

## Directory layout

A skill lives inside its domain plugin:

```
plugins/<domain>/skills/<skill-name>/
├── SKILL.md          required
├── README.md         recommended (human docs)
├── references/       optional (detail loaded on demand)
└── evals.json        optional (eval cases)
```

`<skill-name>` is kebab-case and **must match** the `name` in `SKILL.md`
frontmatter and the row in [`../SKILL_REGISTRY.md`](../SKILL_REGISTRY.md).

## `SKILL.md`

YAML frontmatter then the body:

```markdown
---
name: skill-name
description: <what it is> + <precisely when it fires>. The description IS the
  trigger — list the explicit phrases and inferred situations that should
  activate the skill. This is the single home of the trigger.
---

# Skill Name

Body: the operating instructions Claude reads. Keep the always-loaded body
lean; push exhaustive checklists, tables, and templates into `references/`
and load them on demand.
```

Rules:

- **`name`** — kebab-case, matches the directory and the registry row.
- **`description`** — does double duty: states what the skill is for *and* is
  the authoritative trigger. Be specific about activation (explicit phrases +
  inferred situations). Because this is the one true trigger, **projects must
  not restate it** — they enable the plugin instead (see
  [`plugin-enablement.md`](plugin-enablement.md)).
- Body references to `references/<file>` must resolve.

## `references/`

On-demand detail (full checklists, lookup tables, templates). The body names the
file and says when to load it. Keeps the always-on context small.

## `evals.json`

Optional. When present, an array of eval cases exercising the skill's trigger and
behavior. Omitting it is acceptable for skills whose primary output is
natural-language judgment that's heavyweight to fixture — record *why* it's
omitted in the skill's README so the decision has context.

## Self-check

- [ ] Lives under `plugins/<domain>/skills/<name>/`.
- [ ] Directory name == frontmatter `name` == registry row.
- [ ] `description` states purpose AND the precise trigger.
- [ ] No restated trigger anywhere outside this `SKILL.md`.
- [ ] Every `references/` path named in the body exists.
- [ ] README present (or absence is intentional and noted).
- [ ] Listed in `SKILL_REGISTRY.md` and the plugin's README.
