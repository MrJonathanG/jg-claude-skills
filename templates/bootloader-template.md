# Bootloader (template)

A short preamble a project puts at the top of its instructions (or a pinned
message) to orient Claude to the marketplace before any work starts. It tells
Claude *where skills come from* and *how to treat them* — it does not copy skills
in. Keep it stable; it encodes the architecture, not the contents.

---

```
## Skills

This project's skills come from the private jg-skills marketplace
(github.com/MrJonathanG/jg-claude-skills), enabled in .claude/settings.json.
Rules:

- Skills are distributed as PLUGINS. This project enables the domains it needs
  via "enabledPlugins" (e.g. "app-dev@jg-skills": true). It never copies a skill
  body in.
- Plugins omit versions, so they FLOAT — the project tracks the current skill and
  gets improvements automatically. Pin only deliberately (see change-control.md).
- A skill's activation trigger lives in its own SKILL.md `description`. Do not
  restate triggers in project instructions.

When a skill seems out of date, surface it — don't edit the marketplace body from
this project. Changes to shared skills go through the marketplace repo
(branch → PR → merge).
```

---

Fill in which domains this project enables from
[`project-instructions-template.md`](project-instructions-template.md).
