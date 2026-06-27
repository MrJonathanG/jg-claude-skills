# Notion build mechanics

How to actually build the pages via the Notion MCP, and the quirks that bite. Read before creating or restructuring pages.

## Creating pages

- Create with the Notion create-pages tool. Parent is a `page_id` (for a sub-page) or a `data_source_id` (for a database row). Don't put the title in the body — set it in `properties.title`.
- Content is Notion-flavored markdown. Headings `#`/`##`/`###`, bullets, tables (`<table header-row="true">…`), blockquote callout `>`.
- To restructure an existing page, prefer `replace_content` (deterministic) over fragile search/replace — **but** include a `<page url="...">` tag for every existing child page in the new content, or the call fails to protect them from deletion.
- Small edits: `update_content` with exact `old_str`/`new_str` snippets. `insert_content` to append.

## Table of contents (the navigable map)

- Insert `<table_of_contents/>` where the map goes. It auto-links every heading on the page and self-updates.
- Because it lists **headings**, make every component you want navigable a heading (H1→H2→H3) and keep files/items as bold text or `code spans` so they don't clutter the TOC.
- Notion has only three heading levels. For a tree deeper than three, flatten the deepest folders to H3.

## Anchor links — don't

In-page links to a specific heading need that heading's block ID, which the API doesn't expose. Hand-built `#anchor` links are unreliable and silently break. Use the native `<table_of_contents/>` for in-page nav, and page-level links (`[Title](page-url)`) for cross-page nav.

## Sub-page cards vs inline links

- A nested sub-page always renders as a **card block** on its parent — it can't be shown as a one-line inline link while nested.
- For a clean nav: write the inline "In this wiki" TOC (`**[Page](url)** — description`) at the top, and let the child cards sit below it. Don't try to delete the cards to make a pure list — that trashes the child page.
- Order: when you `replace_content`, place the `<page>` card tags in the order you want; cards render where their tag sits.

## Filenames and URLs auto-link

Plain text like `Control Master Reference.md` auto-links the `.md`, producing a stray broken link. Wrap filenames and paths in `code spans` (backticks) so they render as plain monospace.

## Tasks database — sub-items and properties

For the **Project Setup Tasks** database (data source `collection://60c3665c-ea7a-47cb-8d63-dd6cb5d723c9`):

- **Sub-item** = set the `Parent item` relation to the parent task's URL (as a JSON array string, e.g. `["https://www.notion.so/<id>"]`). Do not use the page-parent for this.
- **Select** (Status, Category, Effort) = plain string matching an existing option exactly, e.g. `Status: "Done"`, `Category: "07. Obsidian Setup"`.
- **Multi-select** (Claude Tool) = JSON array string, e.g. `["Cowork"]`.
- **Date** (Date Completed) = expanded key `date:Date Completed:start` = `"YYYY-MM-DD"`.
- Status vocabulary: `Not Started · In Progress · Done · Deferred · Blocked · N/A`.

When you complete build work, add each deliverable as a sub-item of the relevant category's parent task, `Status: Done`, with `Date Completed` and a one-line `Description`.

## Back-link pattern

When a Structure & Contents file entry links to its build prompt, the build prompt page links back to that file entry ("Linked from …"). Keep both directions so the cross-reference holds and nothing is duplicated.

## Key references in this workspace

- Conventions page: `Project Setup ▸ 00. Wiki & Page Conventions`
- Reference implementation: `Project Setup ▸ 07. Obsidian Setup` (Capability Hub) and `Project Setup ▸ 05. Vanta Configuration` (Tool / Platform Configuration, with a `Configuration` detail sub-page)
- Tasks DB: `Project Setup ▸ Project Setup Tasks`
- Reference layer: `Strongwatch Vault/Compliance Tracking/Master Reference/L1/` (active — CMMC L1) and `…/L2/` (shells, pending L2 in Vanta). The lists carry an **Override** column (✓ = a human changed the LLM's Owner/Effort/Priority): a Vanta data refresh never touches the judgment columns, and a *revised LLM analysis* re-evaluates only blank-Override rows.

Note: the AI Prompts & Workflows hub was consolidated into Project Setup on 2026-05-29 — session prompts → `09. Reusable Session Prompts`; automation/workflow specs → `11. Automation & Recurring Workflows`.
