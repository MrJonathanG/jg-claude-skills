# jg-claude-skills — Plugin Marketplace

A **private Claude Code plugin marketplace**. It is the one place Jonathan's
skills live, grouped into **domain plugins**, so every environment (local CLI,
desktop, web, Cowork, scheduled routines) installs the *same* set and stays
current. Projects enable the domains they need; an improvement pushed here
propagates everywhere automatically.

This repo replaced an earlier "central registry + daily sync routine" design.
That model couldn't reach skills that only existed on one machine and relied on a
sync routine to stay honest. A marketplace dissolves both problems: distribution
*is* the mechanism, and there's no drift to reconcile because every environment
re-installs from here.

---

## Architecture decisions (settled)

1. **One marketplace, multiple domain plugins.** Skills are grouped by domain
   (e.g. `app-dev`). Each plugin is enabled/disabled as a unit, per project.

2. **GitHub is the distribution hub.** For a skill to work in *every* Claude
   environment it must be distributed from here. A personal `~/.claude/skills/`
   skill is local-only — invisible to web sessions and routines ("dark matter").
   New skills are born here as plugin content, never stranded locally.

3. **Versions are omitted → every commit is the current version.** No plugin
   pins a `version`. Because the marketplace is git-hosted, each commit is treated
   as a new version and installed environments pick it up. Improve once,
   propagate everywhere. Pinning is a rare, explicit exception
   (see [`standards/change-control.md`](standards/change-control.md)).

4. **Private by design.** This marketplace is private. Authorized tools and
   sessions reach it through configured GitHub access; there is no public read.

5. **Authoring vs. distribution.** Author/edit a skill wherever you like, but it
   only becomes real (visible everywhere) once pushed here. Any local copy is a
   working copy that installs *from* this hub, not an independent home.

---

## Structure

```
jg-claude-skills/
├── .claude-plugin/
│   └── marketplace.json        ← the catalog: lists every domain plugin
├── plugins/
│   └── app-dev/                ← a domain plugin
│       ├── .claude-plugin/plugin.json   ← plugin manifest (no version)
│       ├── README.md           ← what the plugin is + how to enable it
│       └── skills/             ← the skill bodies
│           ├── app-build-orchestrator/
│           ├── clickup-pm-workflow/
│           └── dev-session-protocol/
├── .claude/
│   └── settings.json           ← canonical enablement example (this repo dogfoods it)
├── SKILL_REGISTRY.md           ← human-readable index: plugins → skills
├── standards/                  ← the rules
│   ├── skill-format.md         ← what a well-formed skill looks like
│   ├── plugin-enablement.md    ← how a project enables plugins (settings.json)
│   └── change-control.md       ← floating vs. pinned; propose-then-approve
└── templates/                  ← copy-paste starting points
    ├── project-instructions-template.md
    └── bootloader-template.md
```

---

## Use a plugin in a project

Add to the project's `.claude/settings.json` (full detail in
[`standards/plugin-enablement.md`](standards/plugin-enablement.md)):

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

Toggle each domain `true`/`false` per project. No skill bodies are copied; no
triggers are restated.

## Add a skill

1. Put it under the right domain: `plugins/<domain>/skills/<skill-name>/`,
   following [`standards/skill-format.md`](standards/skill-format.md).
2. Add a row to [`SKILL_REGISTRY.md`](SKILL_REGISTRY.md) and the plugin's README.
3. Commit and push. Installed environments pick it up as the new current version.

To start a **new domain plugin**, add `plugins/<domain>/.claude-plugin/plugin.json`
(omit `version`) and a new entry in `.claude-plugin/marketplace.json`.

## Updates & auto-update

- **Web / cloud sessions & routines** re-fetch from this repo each run, so they
  are always current after a push.
- **Local machines** auto-update plugins at startup (or on `/plugin update`).
- Because this repo is **private**, background auto-update needs a GitHub token in
  the environment so it can fetch without prompting:

  ```bash
  export GITHUB_TOKEN=<a token with read access to this repo>
  ```

  Without it, the local machine can't refresh the private marketplace in the
  background. (Web/cloud sessions use their own configured GitHub access.)

## Versioning

Plugins omit `version` on purpose. Do **not** add a `version` field unless you
intend to pin — once set, pushing new commits without bumping it does nothing for
installed environments. See [`standards/change-control.md`](standards/change-control.md).

---

> History: [`HANDOFF.md`](HANDOFF.md) records the session that designed this
> pivot. This README is the current source of truth; where the two differ, this
> wins.
