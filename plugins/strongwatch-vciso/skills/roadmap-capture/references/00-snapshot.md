# Engagement Roadmap — schema snapshot (fallback only)

> **Secondary to the live schema read.** If you can reach Notion, fetch the data source and use the live schema — it wins. Use this only when Notion is unreachable, and say so in your output.
> **Snapshot date:** 2026-06-04 · refresh when the schema changes materially.

## Identifiers

- **Database URL:** `https://app.notion.com/p/1bcc932c73b4427fb6ecc366b6fabfb5`
- **Data source (collection) ID:** `de6dbd05-8a63-4dde-82ec-8dd45c0dce45` — pass as `data_source_id` to `notion-create-pages`; pass as `collection://de6dbd05-8a63-4dde-82ec-8dd45c0dce45` to `notion-fetch` for the live read.

## Properties

| Property | Type | Notes |
|---|---|---|
| Name | title | Short, specific item name |
| Originating context | rich_text | **Verbatim** triggering message + capture date + session |
| Objective | rich_text | What success looks like — concrete outcome |
| Mission | rich_text | Why this matters — strategic context |
| Description | rich_text | Neutral elaboration of the "what" |
| Acceptance criteria | rich_text | Conditions for marking Done |
| Domain | select | see options below |
| Status | select | Sketched / Planned / In Progress / Built / Live / Parked / Retired |
| Priority | select | Near-term / Mid-term / Long-term / Parked |
| Type | select | Automation / Notion Page / Skill or Plugin / Process / Documentation / Data Quality / Deliverable |
| Page link | url | Canonical Notion page for the item, if one exists; otherwise blank |
| Dependencies | rich_text | What blocks this from progressing |
| Promotion criteria | rich_text | What must be true before this moves to Live |
| Originating session | rich_text | Which session or date this surfaced |
| Created | created_time | system |
| Last edited | last_edited_time | system |

> **No Owner field.** Removed in v0.4.1 — Jonathan is always the owner, so the column was redundant.

### Domain options

Operating Model · Cat 01 Identity & Access · Cat 02 Notion Workspace · Cat 03 OneDrive Structure · Cat 04 Microsoft 365 & SharePoint · Cat 05 Vanta Configuration · Cat 06 Granola Configuration · Cat 07 Obsidian Setup · Cat 08 OpenAI Integration · Cat 09 Reusable Session Prompts · Cat 10 Claude Ecosystem Setup · Cat 11 Automation · Cat 12 Templates · Cat 13 Knowledge & References · Cat 14 Reporting & Cadence · Cat 15 Business & Housekeeping · Compliance Program · Governance Meetings · SSP · Reporting · Cross-cutting

## Default classification rules

- New idea with no explicit status → **Status = Sketched**.
- No urgency signal → propose **Priority = Mid-term** (confirm).
- Spans multiple domains / no single category fits → **Domain = Cross-cutting**.
- **Page link** only when the user supplies a real canonical page; otherwise leave blank.
- See `domain-classifier.md` for keyword → Domain mapping.

## Saved views (for read queries)

Full table · By Domain · By Status · Near-term · In progress · Parking lot · Submit new item (form).

## Note

Essentials only. The live data source is canonical; reconcile against it once Notion is reachable.
