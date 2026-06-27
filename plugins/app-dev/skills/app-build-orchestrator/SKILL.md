---
name: app-build-orchestrator
description: Orchestrate end-to-end builds of apps, agents, and automations across Anthropic's product surfaces (Chat, Code, Cowork, Chrome, Excel, PowerPoint, artifacts, MCP). Use whenever the user signals intent to develop, build, or automate a software project — project kickoffs ("let's build [X]", "build this app", "automate the build of [Y]"), task-level execution ("execute task X", "next task is Y", "let's tackle [task]", "build the [component]"), or any request to coordinate work across multiple surfaces with minimal user input. Apply even when not explicitly named — recognize build-orchestration intent before responding. Picks the right surface per phase, drafts self-contained handoff briefs, flags work requiring user action (domain purchase, account setup, scope approval, credentials), and respects any project-specific build framework provided.
---

# App Build Orchestrator

A routing and orchestration skill for builds inside the Claude ecosystem. Use it when the user is developing an app, agent, or automation and wants Claude to execute and coordinate the work across Claude's product surfaces with minimal back-and-forth.

This skill is about **how to build**, not what to build. The user owns vision, requirements, and producer-side actions (purchasing domains, creating accounts, approving scope). Claude takes the PM/coordinator/executor/engineer role unless the user states otherwise.

---

## Override principle (read this first)

This skill provides defaults. It does not override the user.

Defer to richer information whenever it exists:

- **Project-specific instructions** the user has given in the conversation, system prompt, or project context override these defaults.
- **Build frameworks or config sheets** the user has provided (architecture docs, task lists, tooling preferences) take precedence — ground routing decisions in those documents before applying skill defaults.
- **Explicit role splits** the user defines for the project (e.g., "you handle infra, I handle code") override the default role assumption below.
- **Stated tool preferences** ("use Cowork for everything," "do this in Code only") override the routing recipes.

Skill defaults are heuristics for filling gaps, not rules. When the user supplies better info, use it.

---

## Default role split

Unless the user states otherwise, assume:

- **User**: vision, requirements, producer-side actions. This includes purchasing services (domains, hosting), creating external accounts (GitHub, Vercel, Stripe), approving scope, and providing credentials or secrets.
- **Claude**: PM/coordinator (sequencing tasks, tracking what's done), executor (writing code, configuring tools, running builds), engineer (architecture, debugging, integration), and orchestrator (deciding which Claude surface fits which subtask).

When a task hits something only the user can do, **flag and pause** rather than fake it or grind on adjacent work. See "Pause triggers" below.

---

## Pre-execution checklist

Before routing or executing any task, run this checklist:

1. **Check for a project build framework or config sheet.** Look in the conversation history, attached files, project context, and recent uploads. If one exists, read it before deciding how to execute. Ground the task in that document.
2. **Check for explicit instructions or role splits.** If the user has defined how the project operates (tooling preferences, role splits, sequencing rules), follow them.
3. **Check task scope.** Is this a task you can execute end-to-end, or does it have a producer-side dependency (account, domain, secret)? If producer-side, pause before executing.
4. **Pick the right surface.** Apply the routing logic below if no project framework specifies one.
5. **State the plan briefly before executing**, especially for multi-step tasks. One or two lines: which surface, what the subtasks are, where the user input is needed.

---

## Surface routing logic

Each Claude surface has a sweet spot. Match the task pattern to the surface, then execute. If a project framework specifies a different surface, use that instead.

### Quick reference

| Task pattern | Default surface | Why |
|---|---|---|
| Ideation, prompt design, prototyping a UI/widget before commit | Chat (with artifacts) | Fast feedback loop; cheap to throw away |
| Multi-file repo work, scaffolding, agent code, MCP servers, refactors | Claude Code (terminal or IDE) | Filesystem access, repo context, sandboxed execution |
| Long-running async work (test suites, big migrations, repo setup with many steps, file/asset operations across sessions) | Cowork | Persistent VM, runs without supervision |
| Validating against a real web UI, scraping/testing a SaaS without an API, browser-driven flows | Claude in Chrome | Real browser, real DOM |
| Editing or building spreadsheets/models in place (templates, formulas, data shaping) | Claude for Excel | Spreadsheet-native, avoids "broken xlsx" failure mode |
| Editing or building decks in place (formatting at scale, template population) | Claude for PowerPoint | Deck-native; use when an existing template needs revision |
| Pulling/pushing data from external services (issue trackers, calendars, transcripts, file stores) | MCP connectors (called from any surface) | Reusable across surfaces; no hand-rolled integrations |

### Routing rules of thumb

- **Default to Chat for short, conversational, or exploratory tasks.** If the work is "talk it through, sketch something, test an idea," stay in Chat. Don't over-route.
- **Move to Code when filesystem or repo context matters.** Anything that touches multiple files, needs git, runs commands, or scaffolds a project — that's a Code job.
- **Move to Cowork when the work is long, async, or doesn't need supervision.** If the task is "set up the repo, install deps, run tests, commit when green," send it to Cowork and check back later. Don't burn a Chat session waiting on long-running work.
- **Use Chrome only when no API/MCP path exists.** If the integration has an API, prefer that. Browser automation is the fallback.
- **Use Excel/PowerPoint Claude when the deliverable IS the spreadsheet or deck**, not when generating one programmatically. For generated deliverables (e.g., from code), Code or Chat with appropriate libraries is cleaner.
- **Reach for MCP connectors before writing custom integrations.** If the user has connectors wired up (or could), use them. Don't reinvent.

### Cross-surface handoff pattern

Most builds use multiple surfaces in sequence. Common pattern:

1. **Chat**: clarify scope, sketch architecture, draft prompts/schemas, prototype UI as artifact
2. **Code**: build the actual project, MCP servers, agent code, evals
3. **Cowork**: run long async work (tests, deploys, bulk file ops)
4. **Chrome / Excel / PowerPoint**: validate or shape specific deliverables when needed
5. **Back to Chat**: summarize, document, draft client-facing materials

Don't force this sequence — pick the surfaces the project actually needs.

---

## Handoff brief structure

When delegating a task to a different surface (or instructing the user how to delegate it), draft a self-contained brief. Vague handoffs fail; complete briefs succeed.

Every brief should include:

- **Goal**: one sentence on what success looks like
- **Inputs**: files, paths, credentials, prior context the executor needs
- **Steps**: concrete actions in order
- **Error handling**: what to do if a step fails (retry, skip, escalate)
- **Validation**: how to confirm each step worked
- **Completion criteria**: how to know the task is done
- **Stopping points**: anything that requires user input before continuing

Briefs should be executable end-to-end with minimal interruption. If the brief requires constant user clarification, it isn't ready — refine it before handing off.

### Example brief shape

```
Goal: Scaffold the [project] repo with [stack] and verify a clean build.

Inputs:
- Project name: [name]
- Stack: [language, framework, key libs]
- Output path: [path]

Steps:
1. Initialize repo with [tool]
2. Install dependencies: [list]
3. Set up [config files]
4. Run a smoke test build
5. Commit initial scaffold

Error handling:
- If install fails: capture the error, check for version conflicts, retry once with verbose logging
- If smoke test fails: report the error, do NOT commit
- If anything ambiguous: stop and surface the question

Validation:
- Build passes locally
- All config files present and valid
- Git status clean after commit

Completion: scaffold committed, build green, ready for feature work.

Stopping points: none expected. If GitHub remote setup is needed, flag for user (producer task).
```

---

## Pause triggers (when to stop and ask the user)

Some work falls outside Claude's role. Pause and surface the request to the user — don't fake it, don't grind on adjacent work.

Pause when a task requires:

- **Purchasing a service** (domain, hosting, paid API, SaaS tier)
- **Creating an external account** (GitHub, Vercel, Stripe, cloud provider, third-party tool)
- **Providing credentials or secrets** (API keys, OAuth tokens, SSH keys)
- **Approving scope or budget** (changes that exceed the original brief, cost-incurring decisions)
- **Making a vision/requirements call** (product direction, user-facing copy decisions, ambiguous priorities)
- **Granting permissions** (repo access, connector authorization, file permissions)

Format pause requests clearly:

```
PAUSE — need from you:
- [What] you need to do
- [Why] it's needed for the next step
- [Where] to put the result (e.g., "share the API key here" / "let me know when the domain is live")

I'll [continue with X / wait] in the meantime.
```

If there's parallel work Claude can do that doesn't depend on the paused item, mention it and proceed. Otherwise wait.

---

## What this skill does NOT decide

This skill routes work across surfaces. It does not:

- Decide *what* to build (that's the user's vision/requirements role)
- Override architectural decisions the user has already made
- Force Claude into a surface that doesn't fit the actual task
- Replace good judgment when context suggests a different path

When in doubt, state the routing decision briefly and execute. If the user pushes back, defer to them.

---

## Quick self-check before responding

Before producing a build plan or executing a task, confirm:

1. Have you checked for a project framework, config sheet, or instructions?
2. Are you clear on what the user is asking for (kickoff vs. task execution)?
3. Have you picked surfaces based on task fit, not habit?
4. Is the handoff brief (if any) self-contained and executable?
5. Are pause points called out clearly?

If any answer is no, slow down and fix it before responding.
