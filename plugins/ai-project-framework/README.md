# AI Project Framework

A Claude Code plugin for portable, cross-session, cross-AI project management. It moves project context out of per-module instructions (which fragment across Chat, Code, Cowork, Design and don't travel to other AIs) and into durable files in cloud storage that every surface can read and write.

## What's in this plugin

### Skills
- **`project-context-sync`** — the core engine. Maintains a per-project context file in cloud storage (Dropbox-first; also Box, Google Drive, local). Two propose-then-approve ceremonies (session-start load, session-close reconcile) plus real-time updates. Edits current-state sections in place, appends to a never-overwritten changelog, and uses a clobber guard against concurrent edits across surfaces. Ships with a canonical schema and templates (per-project file, root directory + global rules, in-app instructions pointer).

## The model

Three layers:
1. **In-app project instructions** (Claude project settings) — the bootloader. Holds the project directory (name to folder path) and the Claude-only skills list. Points to the storage standard.
2. **Root directory + global rules** (cloud storage) — portable, AI-agnostic. The project directory plus global behavior rules (e.g. no em-dash, style preferences) any AI should honor.
3. **Per-project context file** (one per project) — the portable context. Current-state body edited in place + append-only changelog. No skill references (those are Claude-only and live in layer 1).

## Installation

Save the provided `ai-project-framework.plugin` file through the app: open it and choose **Save as plugin**, or install it from Settings > Capabilities. Once installed, the skill activates automatically.

For Claude Code, install directly from the plugin's local folder:

```
/plugin install ./ai-project-framework
/reload-plugins
```

Or load it for a single session without installing:

```
claude --plugin-dir <path-to>/ai-project-framework
```

Skills are namespaced as `ai-project-framework:project-context-sync`.

## Composition

- **`dev-session-protocol`** — independent but interoperable. That skill owns session-boundary timing for code work; `project-context-sync` runs its file load/close inside that boundary when it's active, and runs its own ceremonies when it's not.
- **Domain packs (e.g. a future IBM plugin)** — layer domain rules (deck themes, house style, compliance) on top of this universal pack.
- **`clickup-pm-workflow` / `notion-pm-workflow`** — track tasks in a PM tool; this tracks portable narrative context in a file. Use together.

## Roadmap

- **v0.2** — package the three templates as a `/project-context` command for one-step file creation.
- **IBM plugin (separate pack)** — folds in `ibm-deck-themes` and codifies IBM house rules; enabled when working in an IBM project, layered on top of this framework.
- Future skills: multi-file project context (split instructions / decisions / asset index) once one-file-per-project outgrows itself.

## Files in this plugin

```
ai-project-framework/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── project-context-sync/
│       ├── SKILL.md
│       ├── README.md
│       ├── references/templates.md
│       └── evals/evals.json
└── README.md
```
