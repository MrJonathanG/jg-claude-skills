# project-context-sync

Portable, cross-session, cross-AI project context management. Keeps a durable per-project context file in cloud storage so project state survives across Claude surfaces (Chat, Code, Cowork, Design) and across different AIs (GPT, Gemini, Grok, Perplexity). The cornerstone of the "AI Project Framework" — the layer that makes project context portable instead of trapped in one module's instructions.

## What it does

Claude's native project instructions have three limits: they are per-module (Chat, Code, Cowork, and Design each have their own or none), they are static (the AI can read but not write them), and they don't travel to other AIs. The result is fragmented context — you re-explain the same project in every surface, and you hand-patch instructions whenever something changes.

This skill inverts that. The source of truth becomes a file in cloud storage (Dropbox-first; also Box, Google Drive, or local) that every surface can read and write. The in-app instructions shrink to a thin pointer. The AI maintains the file through two propose-then-approve ceremonies — a session-start load and a session-close reconcile — plus real-time updates on cue. It never writes silently: it verifies, proposes a diff, gets your approval, then writes. Current-state sections are edited in place; a Changelog at the bottom is append-only; a clobber guard prevents one surface from silently overwriting another's edits.

## When it activates

Triggers on:

- Naming a project to work in: "we're working in Weaver", "load the TMA project", "switch to Strongwatch"
- Starting or closing a project work session
- "Update the project instructions / context / file"
- Creating or standardizing a project context file

Doesn't trigger on:

- One-off questions with no project continuity
- Editing a deliverable's content (that's the domain skill's job), unless a durable decision results
- Conceptual discussion about project management as a topic

## What you need to provide

| Required/Optional | What to specify | Example |
|---|---|---|
| Recommended | The project name at session start | "We're working in Weaver" |
| Optional | The storage folder path if the project is new or ambiguous | "/AI Projects/IBM/Weaver Frontier Scanning" |
| Optional | Which storage connector to use | Dropbox (default), Box, Google Drive, or local |
| Optional | Approval preference | Default is propose-then-approve on every write |

If the project can't be resolved from your cue, the skill asks rather than guessing.

## What it produces

- A session-start opener (status, current focus, top open items) after loading the file
- A real-time update proposal (what changes, where) on cue, written only after approval
- A session-close diff proposal (current-state edits + Changelog line + open-item changes), written only after approval
- A consistently structured context file following the canonical schema and style spec
- A per-project folder structure derived from what the project actually contains — proposed (never imposed) when a flat folder crosses the size/variety threshold, grouped by function rather than by file type, with the context file's "Assets & locations" map kept current on every move
- For a new project: a full three-layer setup (portable per-project context file, a root/global-rules file if the area lacks one, and an in-app bootloader output as text to paste), defaulting to the cross-functional portable structure and asking single-AI only on a genuine Claude-bound signal
- At session close: skill-trigger drift detection — flags skills whose stated trigger no longer matches how they fired (stale path, fired outside condition, or didn't fire) and proposes a routed skill-source update, never editing shared skills directly
- Graceful inline fallback when no storage connector is available

## Composition with other skills

- **`dev-session-protocol`** — independent but interoperable. That skill owns session-boundary timing for code work; when it is active, this skill runs its file load/close inside that boundary instead of launching a competing ceremony. When absent (non-code project), this skill runs its own start/close.
- **Domain packs (e.g. `ibm-deck-themes`)** — independent. Domain skills govern deliverables; this governs the portable context file. They co-fire cleanly.
- **`clickup-pm-workflow` / `notion-pm-workflow`** — independent. Those track tasks in a PM tool; this tracks portable narrative context in a file. Use both when a project has a tracker and a context file.

## Usage patterns

- **Start of session:** "We're working in Weaver." → skill loads the file and opens with where you left off.
- **Mid-session decision:** "Update the context — EMC is now 2.0 FTE." → skill proposes the edit + Changelog line, you approve, it writes.
- **End of session:** "Wrap this up." → skill audits the session, proposes a close-out diff, you approve, it writes and bumps last_updated.
- **New project:** "Set up project instructions for X at /AI Projects/.../X." → skill runs the creation flow: builds the portable context file, a root/global-rules file if the area needs one, and an in-app bootloader to paste — defaulting to the cross-functional portable structure.

## Common mistakes

- Putting skill references in the portable file — they are Claude-only and belong in the in-app instructions; the portable file stays AI-agnostic.
- Writing without approval — every write path is propose-then-approve.
- Rewriting the Changelog — it is append-only; current-state edits go in the body, history goes in the log.
- Skipping the clobber guard — always re-check last_updated before writing, or a concurrent edit gets lost.
- Letting the file narrate history in its body — current-state sections describe the present; the Changelog carries the timeline.
- Forcing a folder template onto a project, or naming folders by process ("Outputs", "Artifacts") or file type — structure is derived per project and grouped by function, and small projects stay flat.
- Reorganizing files silently or leaving the "Assets & locations" map stale after a move — folder changes are proposed, approved, and reflected in the map and Changelog in the same pass.

## Files in this skill

- `SKILL.md` — the skill definition and core rules
- `references/templates.md` — per-project schema, root directory + global-rules template, in-app pointer template, ceremony scripts, style spec, clobber guard, and an illustrative derived folder structure
- `evals/evals.json` — 14 test cases covering triggers, the propose-then-approve and append-only and clobber-guard rules, the no-skills-in-portable-file boundary, the no-storage fallback, dev-session-protocol composition, folder-organization behavior (proactive threshold proposal, group-by-function naming, no silent reorganization), new-project creation (cross-functional default, single-AI only on signal), and close-ceremony skill-trigger drift detection
