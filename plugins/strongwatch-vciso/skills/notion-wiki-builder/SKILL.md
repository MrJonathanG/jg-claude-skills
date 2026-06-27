---
name: notion-wiki-builder
description: Build and format Notion pages as StrongWatch vCISO engagement wiki pages to the workspace standard. Use when creating or editing a Notion wiki page — especially Project Setup category pages and their subpages — or when the user says "build a wiki page", "document X as a wiki page", "set up a Notion page for", "add a Project Setup page", or asks for pages that follow the StrongWatch page conventions. A build protocol that reads the live "00. Wiki & Page Conventions" standard (page-type selection, templates, maturity levels, source-of-truth rules) and applies it, with a dated offline fallback when Notion is unreachable. Carries the Notion API build mechanics (table-of-contents blocks, code-span filenames, sub-page card behavior, relation sub-items).
---

# Notion Wiki Builder

Build StrongWatch vCISO engagement wiki pages by **reading the live standard and applying it** — not by carrying the structure in this skill. The canonical standard (templates, page-type selection, maturity levels, source-of-truth rules) lives at **Project Setup ▸ 00. Wiki & Page Conventions** and evolves there. This skill is the **build protocol**: how to read 00, how to fall back if it's unreachable, and the Notion build mechanics that don't change.

## When to use

Apply when creating or editing any engagement wiki page — chiefly the Project Setup category pages and their subpages. Also when the user asks to document how a system/tool is set up, or to fix a page that "doesn't read like a wiki."

## Know which surface you're writing

- **Project Setup** = the wiki: how the engagement infrastructure is configured and built, recreatable. Durable, explanatory voice.
- **Strongwatch CMMC Advisory** = the operational work itself (live advisory, reporting, prompts in use). Working voice.

If it documents *how something is set up*, it's Project Setup. If it's *the work itself*, it's Advisory.

Three-layer model, always: **Notion** = state/status/structure (pane of glass) · **Obsidian** = notes & knowledge (data lake) · **OneDrive / SharePoint** = finished files. Notion holds the index and structure, not bulk content. Link to Obsidian/OneDrive by path; never paste note bodies or duplicate files into Notion.

## Read the live standard before you build (every time)

This skill does **not** define page structure. Structure lives in `00. Wiki & Page Conventions` and changes over time — so read it live, every build. Do not reconstruct page structure from memory or from this skill.

1. **Confirm the surface** (Project Setup vs Advisory, above).
2. **Pick the template.** Open `00. Wiki & Page Conventions` → **Page Type Selection Guide**. Choose the smallest template that makes the page understandable, rebuildable, and connected to the right source of truth.
3. **Open the template page** (Wiki Page Templates & Authoring Guide). That is your structure — mirror it.
4. **Open a worked example.** The Page Type Selection Guide's "current mapping" table lists which existing Project Setup pages use each template. Open one and mirror its shape.
5. **Honor 00's rules** — repository-vs-mechanism (parents route, children detail; tool/repo pages link to automations/runbooks, don't embed mechanics) and source-of-truth (one canonical place per fact; link, don't copy).
6. Apply the **build mechanics** below and run the **checklist**.

**If 00 is unreachable** (Notion MCP not connected, or the page won't fetch): use the dated, essentials-only fallback in `references/00-snapshot.md`, and **state in your output that you built against the offline snapshot, not live 00**, so the result can be reconciled later. Live 00 always wins over the snapshot.

## Every page carries a banner

Two lines in the top callout:

```
> **Maturity:** Stub / Draft / Structured / Operational / Verified
> **Last updated:** YYYY-MM-DD by [Actor]
```

Maturity: **Stub** (rough notes) · **Draft** (content, wrong/no template) · **Structured** (right template + source links) · **Operational** (supports rebuild/handoff) · **Verified** (checked against live setup). Actor: `Claude (<workflow-id>)` for an automation run, `Claude (chat session)` for ad-hoc Claude edits, or a human name for a manual UI edit. Set both honestly; a known placeholder section keeps the page at Draft/Structured, not Operational. Automation `prompt.md` files that update pages MUST write the Last-updated line.

## Formatting conventions

- **Components are headings.** Anything that should appear in navigation must be a heading. Notion has three heading levels (H1→H2→H3) — map component depth onto them.
- **Native table-of-contents block** (`<table_of_contents/>`) for the in-page map; files/items stay non-heading so they stay out of the TOC.
- **"In this wiki" nav = inline links**, one line each: `**[Page](url)** — one-line description`.
- **Per-section detail:** **What it is** · **Description** · **Intent & use**. **Per-file detail:** **Description** · **How it's populated** · **Prompt / automation** (link).
- **Tables** for at-a-glance facts. **Plain, explanatory, sentence-case voice** — write for a newcomer or an AI with no prior context.

## Minimize redundancy (important)

- **One source of truth** — a fact, prompt, or definition lives in exactly one place.
- **Link, don't copy** — reference the canonical page instead of duplicating it.
- **Forward-link + back-link** — when page A points to page B, page B links back to A.

## Notion build mechanics

The conventions above have Notion-API quirks. Read `references/notion-mechanics.md` before creating or restructuring pages. Key points:

- Nested sub-pages render as **card blocks** — they can't be inline links while nested. Lead with the inline "In this wiki" list; let the cards sit below.
- **In-page anchor links aren't reliably buildable** (block IDs aren't exposed). Use the native `<table_of_contents/>` block or page-level links — never hand-built `#anchor` links.
- **`.md` and bare URLs auto-link** in plain text. Wrap filenames/paths in `code spans`.
- Use `replace_content` to restructure, but **include a `<page url="...">` tag for every existing child page** in the new content or the call fails (it protects children from deletion).
- **Tasks-DB sub-items** are set via the `Parent item` relation, not the page parent. Select = plain string; multi-select = JSON array string; dates use the expanded `date:<Field>:start` key.

## New-page checklist

- [ ] Right surface? (Project Setup = setup/config; Advisory = operational)
- [ ] Template chosen via the live `00` Page Type Selection Guide (or the dated fallback, flagged) — smallest fitting template
- [ ] Worked example opened and mirrored
- [ ] Top callout has a `Maturity` value + `Last updated: YYYY-MM-DD by [Actor]`
- [ ] Repository-vs-mechanism split honored; nothing duplicated, everything linked (with back-links)
- [ ] Parent links to the page; page links back to its parent/register
- [ ] Components that need navigation are headings (TOC picks them up)
- [ ] Filenames / paths wrapped in code spans
- [ ] If built offline, the output flags that it used the fallback snapshot
- [ ] Last-pulled / source frontmatter set if the page is data-backed (Obsidian files)

## References

- **Canonical: Notion** — `00. Wiki & Page Conventions` (Page Type Selection Guide + Wiki Page Templates & Authoring Guide). Always read live.
- `references/00-snapshot.md` — dated, essentials-only offline fallback of the 00 standard. Secondary to live 00; refresh when 00 changes materially.
- `references/notion-mechanics.md` — Notion-API build details (page creation, TOC blocks, sub-page cards, relation sub-items, property formats, back-link pattern).
