# Project instructions — skills section (template)

How a project uses skills from the `jg-skills` marketplace. Skills are
distributed as **plugins**; the project enables the domains it needs in its
`.claude/settings.json`. No skill bodies are copied in; no triggers are restated.

---

## 1. Enable the plugins (`.claude/settings.json`)

```json
{
  "extraKnownMarketplaces": {
    "jg-skills": { "source": { "source": "github", "repo": "mrjonathang/jg-claude-skills" } }
  },
  "enabledPlugins": {
    "app-dev@jg-skills": true,
    "ai-project-framework@jg-skills": false,
    "ibm@jg-skills": false
  }
}
```

Set each domain plugin `true` (this project uses it) or `false` (it doesn't).
Plugins omit versions, so the project always tracks the current skill — registry
improvements arrive automatically.

## 2. (Optional) Note which domains this project uses, for humans

A short prose note in the project's instructions helps teammates:

> This project uses the **app-dev** plugin (build orchestration, dev-session
> discipline, ClickUp workflow). Each skill's activation trigger lives in its own
> `SKILL.md`; they fire automatically when relevant.

<!--
DO NOT, in project instructions:
  - paste any skill body            → bodies live once, in the marketplace
  - restate a skill's trigger        → the trigger lives in the skill's SKILL.md
  - add a version pin                → plugins float; pin only via change-control.md
See jg-claude-skills/standards/plugin-enablement.md.
-->

## Pinning (rare)

If this project must freeze a plugin at a specific state, pin it deliberately
(version field or a frozen source ref) and record why and until when here. See
[`../standards/change-control.md`](../standards/change-control.md).
