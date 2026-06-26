# Handoff — Skill Registry → Marketplace migration

**Date:** 2026-06-26
**Repo:** `mrjonathang/jg-claude-skills`
**Branch:** `claude/skill-registry-daily-sync-e717bx` · **Draft PR:** #1 · **Tracking issue:** #2
**Next environment:** Claude Cowork or the local app/chat session (must have access to `~/.claude/skills/`)

---

## TL;DR

We set out to build a central skill registry + a daily cloud "sync routine." Mid-session
the architecture pivoted to something simpler and correct:

> **Make this GitHub repo a Claude Code *plugin marketplace*. Every environment installs
> skills from it. That eliminates "local-only" skills and makes the daily sync routine
> unnecessary.**

The scaffolding (README, standards, templates, registry index) is built and on the PR.
The remaining work — **convert the repo to a marketplace, move all local skills into it,
and update the skill-creation skill to publish-as-plugin** — needs an environment that can
read your local `~/.claude/skills/`. A cloud session (like the one that did this work)
cannot. Hence this handoff.

---

## 1. What exists right now (on the PR)

| File | Purpose | Status under the new plan |
|---|---|---|
| `README.md` | Architecture decisions + how the registry works | ✅ Updated to the distribution-hub model |
| `SKILL_REGISTRY.md` | Index: name → path → stable one-liner (3 skills) + a *Pending* row | ⚠️ Overlaps with `marketplace.json`; decide keep-as-human-index or fold in |
| `standards/skill-format.md` | What a well-formed skill looks like | ✅ Still valid |
| `standards/pointer-rule.md` | name+location+stable-desc; no version; no trigger | ⚠️ Concept holds, but the *mechanism* becomes `settings.json` `enabledPlugins`; needs revision |
| `standards/change-control.md` | Floating vs pinned; propose-then-approve | ✅ Still valid (maps to version strategy) |
| `templates/project-instructions-template.md` | How a project references skills | ⚠️ Becomes a `settings.json` snippet; needs revision |
| `templates/bootloader-template.md` | Project preamble orienting to the registry | ✅ Mostly valid |
| `scripts/reconcile-registry.sh` | Registry-vs-reality lint (runs clean) | ◻️ Repurpose as a PR check, not a scheduled job |
| `.github/workflows/registry-sync.yml` | Daily scheduled reconciliation → opens issue | ❌ **Obsolete** — convert to PR-only lint or delete |
| `routines/daily-sync.md` | claude.ai/code routine spec | ❌ **Obsolete** — the marketplace removes the need |
| `skills/` (3 dirs) | `app-build-orchestrator`, `clickup-pm-workflow`, `dev-session-protocol` | ✅ Stay exactly where they are |

Issue **#2** tracks mirroring `project-context-sync` (currently local-only).

---

## 2. Findings & the architecture pivot (the important part)

**Starting assumption (from the brief):** GitHub = source of truth; a daily *cloud routine*
reconciles it and proposes changes. We built that.

**What we found, in order:**

1. **The in-session scheduler (`CronCreate`) is session-scoped** — it dies when a session
   ends. It cannot be a between-sessions cloud heartbeat. A real claude.ai/code routine is a
   web-UI action a container can't create itself.

2. **A cloud session cannot see your local `~/.claude/skills/`.** Different machine. It only
   knows `project-context-sync` exists because the brief *typed it in*. **A remote session
   cannot discover local-only skills at all.** This is "dark matter": real, used on one
   machine, invisible to everything else.

3. **Personal skills (`~/.claude/skills/`) are local-only by type** — docs confirm web
   sessions and routines can't read them. So they can never be the distribution mechanism for
   skills that must work everywhere.

4. **The fix is a plugin *marketplace*, not a sync routine.** A marketplace is a thin
   metadata layer (two small JSON files) laid on top of the *same* `.md` skill files. It tells
   every Claude environment "install skills from this repo." Skills stay where they are; the
   JSON just points at them.
   - **Claude** reads the repo *as a marketplace* → auto-installs and runs the skills.
   - **Other AIs** ignore the JSON and just read the `.md` files as plain text (the "mirror
     for reference" role). Both consume the *same* files.

5. **"Source of truth" splits into two roles.** You can keep *authoring* skills inside your
   local Claude — but *distribution* must run through GitHub, because that's the only place
   every environment can reach. Author wherever; publish to the hub; every environment
   (including your laptop) installs from the hub.

6. **This makes the daily sync routine unnecessary.** Web sessions and routines re-clone the
   repo and re-install from the marketplace *every run* — no cache, always current. There is no
   local-vs-remote drift to reconcile, because nothing keeps a stale authoritative copy.

---

## 3. How updates work (reference — confirmed against docs)

- **Ephemeral environments (web sessions, routines): always current.** They re-fetch from the
  repo each run. **Push to GitHub → current next session.** Nothing to manage.
- **Your local machine caches.** It updates on `/plugin update`, or automatically if the
  marketplace has `"autoUpdate": true`.
- **"Latest" is set by the version strategy in `plugin.json`:**
  - **Omit `version`** → tracks *every commit* (recommended for a personal registry).
  - **Set `version`** → pins; you must bump it to release (for stable public distribution).
- **Recommended for you:** omit `version` + `autoUpdate: true` → mental model becomes
  **"push to the repo = updated everywhere, automatically."**

Docs: [plugins-reference](https://code.claude.com/docs/en/plugins-reference.md) ·
[plugin-marketplaces](https://code.claude.com/docs/en/plugin-marketplaces.md) ·
[discover-plugins](https://code.claude.com/docs/en/discover-plugins.md) ·
[routines](https://code.claude.com/docs/en/routines.md) ·
[claude-code-on-the-web](https://code.claude.com/docs/en/claude-code-on-the-web.md)

---

## 4. Constraints / open blockers

- **`project-context-sync`** lives only in `~/.claude/skills/` on one machine. A cloud session
  can't mirror it. The next (Cowork/local) session must copy it into `skills/` and verify it
  matches the running install. (Issue #2.)
- **The skill-creation skill** ("skill and plugin skill") almost certainly also lives only in
  `~/.claude/skills/`. Same problem — the next session needs to read it to update it. If it's
  absent, draft fresh in this repo.
- **Audit for other dark matter:** there may be *more* local-only skills nobody has noticed.
  The next session should `ls ~/.claude/skills/` and diff against `skills/` here.

---

## 5. Goal (end state)

A single GitHub repo that is a Claude Code **plugin marketplace**, where:

- **All** skills live (no local-only dark matter).
- Every environment — local CLI, desktop, claude.ai/code web, routines, Cowork — **auto-installs
  the same skills** via a committed `.claude/settings.json`, and stays current automatically.
- **New skills are born here as plugin content** (enforced by the updated skill-creation skill),
  never stranded in `~/.claude/skills/`.
- Other AIs can **reference** the skills as plain Markdown (subject to repo visibility).

---

## 6. Next steps (ordered — for the Cowork / local-app session)

1. **Convert the repo to a single-plugin marketplace** (skills stay put):
   - Add `.claude-plugin/marketplace.json` (declares the marketplace + the one plugin).
   - Add `.claude-plugin/plugin.json` (the plugin = this repo's `skills/`). **Omit `version`**
     to track commits.
   - Add `.claude/settings.json` with `extraKnownMarketplaces` + `enabledPlugins` +
     `"autoUpdate": true`.
   - *Validate the exact JSON schema against the plugins-reference docs before committing.*
2. **Move ALL local skills into the repo.** `ls ~/.claude/skills/`, and for each one not
   already in `skills/`, copy it in, verify it matches, add to the index. Start with
   `project-context-sync` (#2) and the skill-creation skill.
3. **Update the skill-creation skill to publish-as-plugin.** New workflow: scaffold under
   `skills/<name>/` per `standards/skill-format.md` → (auto-covered by the single plugin) →
   update index → commit → push → open PR. Never write to `~/.claude/skills/` as the home.
   Commit the updated skill into this repo (so it stops being dark matter itself).
4. **Revise the now-affected docs:** `pointer-rule.md` and
   `templates/project-instructions-template.md` to reference skills via `settings.json`
   `enabledPlugins` instead of prose pointers; decide `SKILL_REGISTRY.md`'s fate (human index
   vs fold into `marketplace.json`).
5. **Remove the obsolete automation:** delete `routines/daily-sync.md`; either delete
   `.github/workflows/registry-sync.yml` or downgrade it to a PR-only lint that runs
   `scripts/reconcile-registry.sh`.
6. **Verify end-to-end:** open a fresh web session / routine on a project whose `settings.json`
   enables the marketplace, and confirm the skills load. Then confirm the local machine
   auto-updates after a push.

---

## 7. Concrete specs to start from (DRAFT — validate against docs)

`.claude-plugin/marketplace.json`
```json
{
  "name": "jg-claude-skills",
  "owner": { "name": "Jonathan G" },
  "plugins": [
    {
      "name": "jg-skills",
      "source": "./",
      "description": "Personal cross-project Claude skills"
    }
  ]
}
```

`.claude-plugin/plugin.json`  (omit `version` → commit-tracked)
```json
{
  "name": "jg-skills",
  "description": "Personal cross-project Claude skills",
  "author": { "name": "Jonathan G" }
}
```

`.claude/settings.json`  (the auto-install declaration; confirm `enabledPlugins` key form)
```json
{
  "extraKnownMarketplaces": {
    "jg-claude-skills": {
      "source": { "source": "github", "repo": "mrjonathang/jg-claude-skills" },
      "autoUpdate": true
    }
  },
  "enabledPlugins": {
    "jg-skills@jg-claude-skills": {}
  }
}
```

---

## 8. Open decisions for the user

- **Bundling:** single plugin for all skills (recommended) vs per-skill plugins.
- **`SKILL_REGISTRY.md`:** keep as a human-readable index, or drop in favor of `marketplace.json`.
- **Obsolete automation:** delete the routine + Action, or keep the script as a PR lint.
- **Repo visibility:** public (any AI can reference the `.md`) vs private (only authorized tools).

---

## 9. Kickoff prompt for the next session (copy-paste)

> Working in the `mrjonathang/jg-claude-skills` repo on branch
> `claude/skill-registry-daily-sync-e717bx` (draft PR #1). Read `HANDOFF.md` first.
> You have local filesystem access. Goals this session:
> 1) Convert the repo to a single-plugin Claude Code marketplace (omit version, autoUpdate on),
>    validating schema against the plugins-reference docs.
> 2) Audit `~/.claude/skills/` and move EVERY local-only skill into `skills/` here, verifying each
>    matches the running install — starting with `project-context-sync` (issue #2) and the
>    skill-creation skill.
> 3) Update the skill-creation skill so new skills are published here as plugin content, never left
>    in `~/.claude/skills/`. Commit the updated skill into this repo.
> 4) Revise `pointer-rule.md` / project-instructions template to use `settings.json` enabledPlugins;
>    remove the obsolete `routines/` + scheduled Action.
> 5) Verify a fresh web session loads the skills via a project `settings.json`.
