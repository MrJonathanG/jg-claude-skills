# Standard: plugin enablement (how a project uses skills)

This replaces the old "pointer" rule. Skills are no longer referenced by a
hand-written pointer string. They are distributed as **plugins** from the
`jg-skills` marketplace, and a project turns them on declaratively in its
`.claude/settings.json`.

## How a project enables skills

A project's `.claude/settings.json` does two things:

```json
{
  "extraKnownMarketplaces": {
    "jg-skills": { "source": { "source": "github", "repo": "mrjonathang/jg-claude-skills" } }
  },
  "enabledPlugins": {
    "app-dev@jg-skills": true
  }
}
```

1. **`extraKnownMarketplaces`** registers this marketplace by name → source, so
   the environment knows where to fetch plugins from.
2. **`enabledPlugins`** turns specific plugins on (`true`) or off (`false`),
   keyed by `plugin-name@marketplace-name`.

That's it. No copied skill bodies, no restated triggers, no version fields.

## Per-project domain toggling

Enablement is per project, so each project runs only the domains it needs:

```json
"enabledPlugins": {
  "app-dev@jg-skills": true,
  "ibm@jg-skills": false,
  "ai-project-framework@jg-skills": true
}
```

A plugin with no entry falls back to its own default. Toggling a whole plugin
on/off is the unit of control — that's why skills are grouped into domain
plugins rather than shipped loose.

## What a project must NOT do

- **No copied skill bodies.** Bodies live once, in this repo, inside their
  plugin. The project installs from the marketplace; it never vendors a copy.
- **No restated triggers.** A skill's activation trigger lives once, in its
  `SKILL.md` `description`. Restating it in project instructions creates a second
  copy that drifts.
- **No version pins (normally).** Plugins omit `version`, so every commit to this
  repo is the current version and improvements propagate automatically. Pinning
  is a rare, explicit exception — see [`change-control.md`](change-control.md).

## Where the trigger lives

The precise "when does this fire" is the `description` frontmatter inside each
skill's `SKILL.md`. The marketplace entry and plugin README carry only a stable
one-line *purpose*, never the trigger.
