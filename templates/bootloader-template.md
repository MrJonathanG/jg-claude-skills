# Bootloader (template)

A short preamble a project puts at the top of its instructions (or a pinned
message) to orient Claude to the central registry before any work starts. It
tells Claude *where skills live* and *how to treat them* — it does not copy
skills in.

---

```
## Skill registry

This project uses skills from the central registry: jg-claude-skills
(https://github.com/mrjonathang/jg-claude-skills). Rules:

- Skill BODIES live in the registry under skills/<name>/. Never copy a body
  into this project; reference it by pointer.
- Pointers are name + location + a stable one-line description. They FLOAT
  (track the current skill) — no version pins except via a frozen location.
- A skill's activation trigger lives in its own SKILL.md `description`. Do not
  restate triggers here.
- Skills used by this project are listed in the "Skills this project uses"
  section below (see templates/project-instructions-template.md).

When a skill seems out of date or its pointer description no longer matches the
registry body, surface it — do not edit the registry body from this project.
Shared-skill changes are propose-then-approve in the registry repo.
```

---

Fill in the "Skills this project uses" list from
[`project-instructions-template.md`](project-instructions-template.md). Keep
this bootloader stable; it should rarely change because it encodes the
*architecture*, not the *contents*.
