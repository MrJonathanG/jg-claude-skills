# Skill Registry — index

The authoritative index of skills in this registry. One row per skill:
**name → path → stable one-line description.** The description is the *stable
purpose* of the skill — not its trigger (the trigger lives in each skill's
`SKILL.md` `description` frontmatter) and not a restatement of its steps.

Projects reference these by pointer (name + location + this description). See
[`standards/pointer-rule.md`](standards/pointer-rule.md). The daily sync routine
checks that this table matches the actual `skills/` contents.

| Skill | Location | Stable description |
|---|---|---|
| `app-build-orchestrator` | `skills/app-build-orchestrator/` | Orchestrates end-to-end builds across Anthropic's product surfaces (Chat, Code, Cowork, Chrome, Office, artifacts, MCP). |
| `clickup-pm-workflow` | `skills/clickup-pm-workflow/` | ClickUp project-tracking conventions — status vocabulary, hierarchy, milestone naming, closeout/outcome-evidence rules. |
| `dev-session-protocol` | `skills/dev-session-protocol/` | Session boundary discipline — opener, close audit, and a close summary that doubles as the next-session handoff. |

## Pending / not yet mirrored

Skills known to exist on a synced install but **not yet mirrored into this repo**.
They are intentionally kept out of the table above (and off the `skills/<name>/`
path pattern) so reconciliation stays green for what's actually present. Move a
row up into the table once its body is committed and verified to match the
running install.

| Skill | Source | Status |
|---|---|---|
| `project-context-sync` | local synced Claude install (`~/.claude/skills/project-context-sync/`) | **Not in repo.** Recently edited on one machine (folder-organization guidance, a create-project-instructions entry path, skill-trigger validation in the close ceremony). This cloud session cannot reach that local install to mirror it — see the open decision in the PR / session notes. |
