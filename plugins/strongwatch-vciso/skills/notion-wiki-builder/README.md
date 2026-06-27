# Notion Wiki Builder

A StrongWatch vCISO plugin skill for building and formatting Notion wiki pages to the workspace standard.

## What it does

Acts as a **build protocol**, not a copy of the page structure. Before building or editing a wiki page it reads the live `00. Wiki & Page Conventions` standard in Notion — the Page Type Selection Guide, the chosen template, and a worked example — then applies it. If Notion is unreachable it falls back to a dated, essentials-only offline snapshot and flags that it did so. Carries the durable pieces that don't change: the Project-Setup-vs-Advisory surface rule, the three-layer model, the redundancy and repository-vs-mechanism rules, the Maturity + Last-updated banner rule, and the Notion API build mechanics.

## When it activates

When creating or editing any engagement Notion wiki page — chiefly Project Setup category pages and their subpages — or when the user says "build a wiki page", "document X as a wiki page", "set up a Notion page for", "add a Project Setup page", or asks for a page that follows the StrongWatch conventions. Also when fixing a page that "doesn't read like a wiki."

Does NOT activate for in-Vanta control updates (that's `vanta-control-updater`) or for non-wiki Notion content.

## What you need to provide

- Which surface the page belongs on (Project Setup vs Strongwatch CMMC Advisory) — or accept the skill's surface test.
- Notion MCP access for the live-standard reads. Without it, the skill builds from the offline snapshot and flags the fallback.
- The subject matter for the page (the system/tool/workflow being documented).

## What it produces

- A Notion page built to the correct `00` template for its page type, with a Maturity + Last-updated banner, correct cross-links (forward + back), and code-spanned filenames/paths.
- A clear flag in the output when the page was built from the offline snapshot rather than live `00`.

## Composition

- **`00. Wiki & Page Conventions`** (Notion, canonical) — the source of truth this skill reads. The skill never replaces it.
- **`vanta-control-updater`** (same plugin) — its in-Vanta counterpart. No overlap: Notion = state/structure, Vanta = evidence/control panel.
- **`audit-verification`** (user) — use when confirming a page is accurate against the live setup before marking it Verified.

## Usage patterns

- "Document Vanta as a wiki page" → read `00` Selection Guide → Tool / Platform Configuration template → mirror an existing tool/platform page → build, with banner + links.
- "Add a Project Setup page for X" → pick the smallest fitting template via the live Selection Guide; route detail to a child page if the parent should stay high-level.
- Notion is down → build from `references/00-snapshot.md`, state in the output that the offline fallback was used, and reconcile against live `00` later.

## Common mistakes

- **Building page structure from memory or from this skill.** Structure lives in live `00` and evolves — read it every time.
- **Forcing every page into one shape.** Pick the smallest fitting template; the old Overview/Structure/Build-Plan shape is just the Capability Hub template, not the default.
- **Duplicating mechanics into a tool/repo page.** Link to the automation/runbook instead (repository-vs-mechanism rule).
- **Silently using the offline snapshot.** Always flag fallback use so the page can be reconciled against live `00`.
- **Omitting the Maturity / Last-updated banner**, or marking a page Operational when it still has placeholder sections.

## Files in this skill

- `SKILL.md` — the build protocol: read-live-first flow, fallback rule, banner rule, build mechanics, checklist.
- `references/00-snapshot.md` — dated, essentials-only offline fallback of the `00` standard (secondary to live `00`).
- `references/notion-mechanics.md` — Notion-API build details (page creation, TOC blocks, sub-page cards, relation sub-items, property formats, back-link pattern).
- `references/templates.md` — deprecated redirect (templates moved to live `00` + the snapshot); retained only as a pointer.
- `evals/evals.json` — test cases covering triggers, read-live-first, the offline-fallback flag, repo-vs-mechanism, the composition boundary, and a negative case.
