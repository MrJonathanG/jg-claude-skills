# Skill Registry — index

Human-readable map of what's in this marketplace: which **domain plugins** exist
and which **skills** each contains. This is a readable index, not the routing
mechanism — `.claude-plugin/marketplace.json` and each `plugin.json` do the
actual routing. Projects enable plugins via `settings.json` (see
[`standards/plugin-enablement.md`](standards/plugin-enablement.md)).

The one-line description is the skill's *stable purpose* — not its trigger (the
trigger lives in each `SKILL.md` `description` frontmatter) and not a restatement
of its steps.

## Plugins

### `app-dev` — `plugins/app-dev/`
Cross-project build & workflow toolkit. Enable on projects that build software,
run structured dev sessions, or track work in ClickUp.

| Skill | Location | Stable description |
|---|---|---|
| `app-build-orchestrator` | `plugins/app-dev/skills/app-build-orchestrator/` | Orchestrates end-to-end builds across Anthropic's product surfaces (Chat, Code, Cowork, Chrome, Office, artifacts, MCP). |
| `clickup-pm-workflow` | `plugins/app-dev/skills/clickup-pm-workflow/` | ClickUp project-tracking conventions — status vocabulary, hierarchy, milestone naming, closeout/outcome-evidence rules. |
| `dev-session-protocol` | `plugins/app-dev/skills/dev-session-protocol/` | Session boundary discipline — opener, close audit, and a close summary that doubles as the next-session handoff. |

## Planned domains (not yet in the repo)

Your own plugins that already exist as installed plugins and are the natural next
domains to bring into this marketplace. Add each as `plugins/<domain>/` with its
own `plugin.json` (omit `version`) and a `marketplace.json` entry. Confirm each
one's current source of truth before importing, so this becomes their home rather
than a second drifting copy.

| Domain plugin | Source today | Notes |
|---|---|---|
| `ai-project-framework` | Installed plugin (author: Jonathan / JG & Co.), currently pins `version` 0.1.0 | Contains `project-context-sync`. Drop the pinned version on import. |
| `strongwatch-vciso` | Installed plugin (author: JG & Co. LLC), currently pins `version` 0.5.0 | StrongWatch vCISO engagement toolkit (Notion wiki, Vanta, roadmap). Drop the pinned version on import. |
