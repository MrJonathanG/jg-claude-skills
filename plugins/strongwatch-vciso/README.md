# strongwatch-vciso

Engagement toolkit for the JG & Co. StrongWatch vCISO / CMMC work. A growing set of skills and commands that keep the engagement's Notion workspace and reference layer consistent and AI-readable.

## What's inside (v0.5.0)

| Component | Name | Purpose |
|---|---|---|
| Skill | `notion-page-dedup-check` | Mandatory validate-before-create discipline for Notion pages: before any page creation, search the target parent and workspace for an existing page that already serves the purpose, and route to append-to-existing over create-new. Prevents duplicate pages and fragmented logs. Composes with `notion-wiki-builder` (pre-check before the builder constructs). |
| Skill | `notion-wiki-builder` | Build protocol for engagement Notion wiki pages: reads the live `00. Wiki & Page Conventions` standard (page-type selection, templates, maturity, source-of-truth rules) and applies it, with a dated offline fallback when Notion is unreachable. Carries the Notion API build mechanics. |
| Skill | `vanta-control-updater` | How to update and maintain CMMC controls in Vanta to one standard — the field-by-field update sequence, forward-only status rule, per-objective implementation details, owner sourcing from the L1/L2 masters, the Rev. 3 ↔ Rev. 2 crosswalk, and the evidence-record build pattern. The in-Vanta counterpart to `notion-wiki-builder`. |
| Skill | `roadmap-capture` | Capture new engagement workstream items into the Engagement Roadmap database via a guided interview (verbatim seed, Objective + Mission, auto-classify, confirm before write), and answer roadmap read queries. Director model: reads the live database schema with a dated offline fallback. |
| Command | `/new-wiki-page` | Scaffolds a new wiki page for a system by reading the live `00` standard, picking the right template, and building to it. |

## Background

The conventions this plugin encodes are documented in Notion at **Project Setup ▸ 00. Wiki & Page Conventions** — the canonical source the `notion-wiki-builder` skill reads live. The **07. Obsidian Setup** (Capability Hub) and **05. Vanta Configuration** (Tool / Platform Configuration) sections are reference implementations. The `roadmap-capture` skill reads the live **Engagement Roadmap** database (data source `de6dbd05-8a63-4dde-82ec-8dd45c0dce45`).

## Changelog

- **v0.5.0** — added `notion-page-dedup-check` (search-before-create discipline for Notion pages; routes to append-to-existing over create-new to prevent duplicates and fragmented logs).
- **v0.4.1** — Engagement Roadmap schema sync: `roadmap-capture` updated to drop the removed Owner field and add the optional Page link capture; snapshot refreshed.
- **v0.4** — added `roadmap-capture` (Engagement Roadmap database capture + read skill; director model with offline schema snapshot).
- **v0.3** — `notion-wiki-builder` reframed from a fixed 3-part page pattern to a director protocol that reads the live `00` template system, with a dated offline fallback; added the skill's `README.md` + `evals/`; `/new-wiki-page` aligned to the same model.
- **v0.2** — added `vanta-control-updater`.

## Author

JG & Co. LLC
