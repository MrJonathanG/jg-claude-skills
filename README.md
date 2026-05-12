# jg-claude-skills

Personal Claude skills used across projects.

Three skills:

- `app-build-orchestrator` — orchestrate end-to-end builds across Claude product surfaces (Chat, Code, Cowork, Chrome, Excel, PowerPoint, artifacts, MCP).
- `clickup-pm-workflow` — ClickUp project tracking conventions (status vocabulary, hierarchy decisions, milestone naming, MCP-specific limitations, **outcome-evidence rule** for closeout comments).
- `dev-session-protocol` — session boundary discipline for development work (4-line opener, 5-part close summary with outcome-evidence per criterion, end-of-phase audit, stop-and-surface triggers).

## Layout

```
jg-claude-skills/
├── README.md
├── .gitignore
└── skills/
    ├── app-build-orchestrator/
    │   └── SKILL.md
    ├── clickup-pm-workflow/
    │   ├── SKILL.md
    │   ├── README.md
    │   └── references/tables.md
    └── dev-session-protocol/
        ├── SKILL.md
        ├── README.md
        └── references/templates.md
```

## Install

These skills auto-install at `~/.claude/skills/` via the Claude Code personal-skills mechanism. This repo is the canonical authoring location — edits land here, version control happens here, then the plugin install flow propagates to `~/.claude/skills/`.

## Notes

- Do not edit `~/.claude/skills/` directly — that path is managed by Claude Code and may be read-only depending on the session sandbox.
- Push target (GitHub remote) is a follow-up; not configured at initial commit.
