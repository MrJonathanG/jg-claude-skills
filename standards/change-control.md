# Standard: change control

How skills change and how floating vs. pinned works. Because one push here can
reach every environment that installs the plugin, change control is deliberately
conservative.

## Floating by default

Plugins omit `version`. Because the marketplace is git-hosted, **every commit is
the current version**, and installed environments pick it up (web/cloud on next
run; local machines at startup or on `/plugin update`). Make a fix once,
everyone benefits.

Implication: **a change to a shared skill is a change to every consumer.** Treat
edits accordingly.

## Editing a skill (the normal path)

1. Branch.
2. Edit the body under `plugins/<domain>/skills/<name>/`.
3. If the change alters *what the skill is for*, update its one-line description
   in [`../SKILL_REGISTRY.md`](../SKILL_REGISTRY.md) and the plugin's README too.
   Don't chase trigger wording into project settings — projects enable plugins,
   they don't restate triggers.
4. PR → review → merge → push. Floating means it propagates once it's on the
   branch that environments install from.

## Propose-then-approve (no silent body rewrites)

The blast radius of a shared-skill edit is every project, so changes go through a
human: branch, PR, review, merge. No automated process rewrites a skill body on
its own.

## Pinning (the rare exception)

Sometimes a project must *not* receive a change (e.g. it depends on exact current
behavior during a freeze). Two supported ways to pin:

- **Pin the version.** Set a `version` in the plugin's `plugin.json` (or its
  marketplace entry) and bump it deliberately per release. Once set, pushing new
  commits without bumping the field does nothing for installed environments — so
  use this only when you *want* that freeze.
- **Pin the source ref.** Point a consumer at a tagged/frozen ref of the repo.

Pinning is opt-out from propagation and should be **explicit**, **documented**
(why and until when), and **temporary** — pins are debt; the default is to float.
