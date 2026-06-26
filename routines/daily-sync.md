# Daily sync routine — definition & creation path

The daily heartbeat that reconciles the registry's *stated* state against
reality and **proposes** (never silently applies) skill-body changes. This file
is the canonical definition; create the live routine from it.

Two delivery mechanisms exist, on purpose:

1. **GitHub Action** — [`.github/workflows/registry-sync.yml`](../.github/workflows/registry-sync.yml).
   Already committed. Runs the mechanical reconciliation daily (and on push),
   opens/refreshes a tracking issue on findings. No local machine, scoped to this
   repo. This is the always-on safety net.
2. **claude.ai/code routine** (defined below). Adds *Claude judgment* on top of
   the mechanical checks — description/trigger staleness, local-install
   divergence — which the bash script can only heuristically approximate. Create
   this in the web UI when you want the judgment pass.

They are complementary: the Action guarantees a daily mechanical gate even if the
routine is paused; the routine adds reasoning the Action can't.

---

## Routine specification (for claude.ai/code)

| Field | Value |
|---|---|
| **Name** | `skill-registry-daily-sync` |
| **Trigger** | Scheduled, **daily**. Suggested ~08:17 local (off the :00 mark). Daily is well within the plan's routine cap and the 1-hour-minimum interval. |
| **Repository** | `mrjonathang/jg-claude-skills` (this repo only). |
| **Connectors / scope** | GitHub, limited to this single repo. No Dropbox/Synology, no other repos — the Dropbox in-place editing automation is explicitly separate and out of scope here. |
| **Output** | A PR or issue against this repo for human review. **Never** a silent push to a skill body. |

### Prompt for the routine

```
You are the daily skill-registry sync for mrjonathang/jg-claude-skills.
Your job is to reconcile the registry's STATED state against reality and
PROPOSE changes for human review. You must NOT silently rewrite skill bodies —
shared-skill changes are propose-then-approve (see standards/change-control.md).

Do the following, working only in this repo:

1. Run scripts/reconcile-registry.sh and capture its findings (registry rows
   without a skills/ dir and vice-versa; SKILL.md name/dir mismatches; broken
   references/ paths).

2. Beyond the mechanical script, read each skill's SKILL.md `description` and
   the SKILL_REGISTRY.md one-liner and judge for STALENESS signals:
   - references to renamed/moved paths or files,
   - a registry description that has drifted from the skill's actual purpose,
   - a pointer-style description that has crept into restating the trigger
     (the trigger belongs only in the skill body — see standards/pointer-rule.md).
   Flag these; do not fix the bodies yourself.

3. If a local synced install is reachable in this environment
   (~/.claude/skills/), diff it against skills/ here and surface any divergence.
   The repo is authoritative; report the diff, do not overwrite either side.

4. Consolidate findings into ONE artifact:
   - If there are body/description changes to propose, open a PR with the
     proposed edits clearly marked as proposals for review.
   - If findings are purely informational (drift to reconcile, items to mirror),
     open or refresh a single tracking ISSUE.
   - If everything reconciles, post nothing (or a brief no-op note) — do not
     open empty issues.

Always end by stating what you proposed and that nothing was applied without
review.
```

### Creating it (verify against the live UI — this feature is preview)

The routines surface is in preview and the exact path shifts. As of this
writing, the options are:

1. **Web:** claude.ai/code → **Routines** (or **Automations/Schedule**) → *New* →
   set trigger = Scheduled/Daily, repository = this repo, paste the prompt above,
   limit connectors to GitHub. Some trigger types are web-only.
2. **CLI `/schedule`:** the in-app `/schedule` command creates scheduled
   routines; confirm it targets this repo and carries the prompt above.

Confirm the live labels before relying on either — don't assume the menu names.

### Optional second trigger — on skill-file change

In addition to the daily schedule, a GitHub event trigger (on change to
`skills/**` or `SKILL_REGISTRY.md`) catches drift at push time. The committed
GitHub Action **already includes this** (`push` paths filter), so you only need
to add it to the claude.ai routine if you want the *judgment* pass to run on
every skill edit too — otherwise the daily tick plus the Action's push trigger
is sufficient. Recommended default: leave the routine daily-only and let the
Action handle push-time mechanical checks.

## Caps & limits (confirmed)

- **Daily** fits within the plan's routine cap and the 1-hour-minimum interval
  (daily ≫ 1 hour).
- The **GitHub Action** uses least-privilege permissions (`contents: read`,
  `issues: write`) scoped to this repo only.
- Neither mechanism pushes silent changes to skill bodies.
