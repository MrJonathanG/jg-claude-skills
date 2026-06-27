# app-dev (plugin)

The cross-project build and workflow toolkit. Enable it on any project that
involves building software, running structured dev sessions, or tracking work in
ClickUp.

## Skills in this plugin

| Skill | What it's for |
|---|---|
| `app-build-orchestrator` | Orchestrates end-to-end builds across Anthropic's product surfaces (Chat, Code, Cowork, Chrome, Office, artifacts, MCP). |
| `dev-session-protocol` | Session boundary discipline — opener, close audit, and a close summary that doubles as the next-session handoff. |
| `clickup-pm-workflow` | ClickUp project-tracking conventions — status vocabulary, hierarchy, milestone naming, closeout/outcome-evidence rules. |

## Enable it on a project

Add to the project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "jg-skills": { "source": { "source": "github", "repo": "mrjonathang/jg-claude-skills" } }
  },
  "enabledPlugins": { "app-dev@jg-skills": true }
}
```

Each skill's activation trigger lives in its own `SKILL.md` `description` — it
fires automatically when relevant. No version is pinned, so every push to the
repo is picked up as the current version (see the repo README for how updates
propagate).
