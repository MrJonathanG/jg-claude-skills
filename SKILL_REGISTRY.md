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

### `ai-project-framework` — `plugins/ai-project-framework/`
Portable, cross-session, cross-AI project context. Durable per-project context
files (Dropbox-first) that survive across Claude surfaces and other AIs.

| Skill | Location | Stable description |
|---|---|---|
| `project-context-sync` | `plugins/ai-project-framework/skills/project-context-sync/` | Keeps a project's living context in sync across sessions and surfaces — propose-then-approve load/close, append-only changelog, clobber guard. |

### `strongwatch-vciso` — `plugins/strongwatch-vciso/`
JG & Co. StrongWatch vCISO engagement toolkit. Also ships the
`new-wiki-page` command (`plugins/strongwatch-vciso/commands/`).

| Skill | Location | Stable description |
|---|---|---|
| `notion-wiki-builder` | `plugins/strongwatch-vciso/skills/notion-wiki-builder/` | Builds/formats Notion pages to the StrongWatch vCISO engagement wiki standard. |
| `notion-page-dedup-check` | `plugins/strongwatch-vciso/skills/notion-page-dedup-check/` | Validate-before-create discipline for Notion pages — search for an existing page first, route to append-over-create. |
| `roadmap-capture` | `plugins/strongwatch-vciso/skills/roadmap-capture/` | Captures engagement workstream items into the StrongWatch Engagement Roadmap database; answers roadmap read queries. |
| `vanta-control-updater` | `plugins/strongwatch-vciso/skills/vanta-control-updater/` | Updates/maintains StrongWatch CMMC controls in Vanta to one consistent standard. |

---

These three plugins were previously scattered across per-session build folders and
the app's plugin cache with no published source. This marketplace is now their
single home; the pinned `version` fields were dropped so each tracks the current
commit (see [`standards/change-control.md`](standards/change-control.md)).
