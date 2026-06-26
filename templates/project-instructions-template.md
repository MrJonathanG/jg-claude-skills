# Project instructions — skills section (template)

Drop this block into a project's instructions to reference registry skills.
Copy the registry's canonical pointer form — **name + location + stable
one-liner**. No version, no restated trigger.

---

## Skills this project uses

Skills are referenced by pointer. Bodies live in the central registry
(`jg-claude-skills`); this project never copies them in. Pointers **float** —
they track the current skill, so registry improvements arrive automatically.
The precise activation trigger for each skill lives in its body, not here.

<!-- One bullet per skill. name — `location/` then a stable one-line purpose. -->

- **<skill-name>** — `jg-claude-skills/skills/<skill-name>/`
  <stable one-line description of what the skill is for>

- **dev-session-protocol** — `jg-claude-skills/skills/dev-session-protocol/`
  Session boundary discipline — opener, close audit, and next-session handoff.

- **clickup-pm-workflow** — `jg-claude-skills/skills/clickup-pm-workflow/`
  ClickUp tracking conventions — status vocabulary, hierarchy, closeout rules.

<!--
DO NOT, in this block:
  - add a version/pin field      → pointers float; pin via a frozen location only
  - restate the trigger          → the trigger lives in the skill's SKILL.md
  - paste any skill body          → bodies live once, in the registry
See jg-claude-skills/standards/pointer-rule.md.
-->

### Pinning (rare)

If this project must freeze a skill at a specific state, point at a **frozen
location** instead of the live path, and record why and until when here:

- **<skill-name>** — `jg-claude-skills/skills/_frozen/<skill-name>@<ref>/`
  Pinned because <reason>; revisit by <date>. (See standards/change-control.md.)
