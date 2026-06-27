---
name: roadmap-capture
description: Capture new engagement workstream items into the StrongWatch Engagement Roadmap database via a guided interview, and answer roadmap read queries. Use when the user says "I have a new idea for [domain]", "Add to the roadmap", "We need to build X", "We should also do Y", "Capture this as a future item", "Add to backlog", "Add to engagement roadmap", or asks "what's on the roadmap for [domain]", "what's near-term", "what's in progress", "show me the parking lot". Preserves the originating message verbatim, interviews for Objective and Mission as narrative fields, auto-classifies obvious fields, always confirms classification before writing, then commits the row. Director model — reads the live database schema at runtime with a dated offline fallback.
---

# Roadmap Capture

Capture engagement workstream items into the **Engagement Roadmap** database the moment intent is fresh, so nothing gets lost. This skill exists because terse forms invite one-sentence descriptions; capture works better as a short interview that preserves *why* an item matters (Objective + Mission), not just *what* it is.

This is a **director-model** skill: it reads the live database schema at runtime and applies it. It does not hard-code the schema. A dated offline snapshot in `references/00-snapshot.md` is the fallback when Notion is unreachable.

## When to use

Two modes, both triggered conversationally:

- **Capture** — the user is articulating a new piece of work, idea, or future item. Triggers: "I have a new idea for [domain]", "Add to the roadmap", "We need to build X", "We should also do Y", "Capture this as a future item", "Add to backlog", "Add to engagement roadmap".
- **Read** — the user wants to see what's tracked. Triggers: "What's on the roadmap for [domain]?", "What's near-term?", "What's in progress?", "Show me the parking lot."

Does NOT activate for live control/evidence work (that's `vanta-control-updater`) or for building wiki pages (that's `notion-wiki-builder`).

## The database

- **Database:** Engagement Roadmap — `https://app.notion.com/p/1bcc932c73b4427fb6ecc366b6fabfb5`
- **Data source (collection) ID:** `de6dbd05-8a63-4dde-82ec-8dd45c0dce45` — use this as the `data_source_id` for `notion-create-pages` and as the fetch target for the live schema read.
- Lives as its own top-level page under **Strongwatch — vCISO Engagement ▸ Engagement Roadmap**.
- **No Owner field.** Jonathan is always the owner; the column was removed in the v0.4.1 schema. Do not ask for or set an owner.

## Read the live schema before you write (every time)

1. **Fetch the data source** (`notion-fetch` on `collection://de6dbd05-8a63-4dde-82ec-8dd45c0dce45`) to get the current property list and select options. Schemas evolve — never assume options from this skill.
2. **If the live read fails** (Notion MCP not connected, or the fetch errors): use `references/00-snapshot.md` for the schema + classification rules, and **state in your output that you used the offline snapshot, not live schema**, so it can be reconciled. Live schema always wins.

## Capture flow

1. **Capture the seed verbatim.** Quote the user's triggering message exactly into `Originating context`, with the date and session reference, e.g. `"<their words>" (captured 2026-06-04 in <session>)`. Never paraphrase the seed — it is the evidence of intent.
2. **Auto-classify what's obvious** from the seed:
   - **Domain** — apply `references/domain-classifier.md` heuristics (keywords → Domain). If genuinely ambiguous, ask; don't guess.
   - **Type** — from the verbs/nouns ("build an automation" → Automation; "a page/database" → Notion Page; "a skill/plugin" → Skill or Plugin; "a report/deck/spreadsheet" → Deliverable or Automation; "a process/cadence" → Process; "documentation/ADR" → Documentation; "data cleanup/curation" → Data Quality).
   - **Priority** — from urgency cues ("next priority", "urgent", "soon" → Near-term; "eventually", "someday", "parked" → Long-term/Parked; otherwise propose Mid-term).
   - **Status** — default **Sketched** for a fresh idea unless the user says it's already underway or built.
3. **Interview the gaps — one question per turn.** Only ask what wasn't already implied:
   - Always elicit **Objective** (what success looks like — concrete outcome) and **Mission** (why this matters strategically) as narrative fields. These are the loss-prevention payload; do not accept a one-liner where a short paragraph is warranted.
   - Always elicit **Acceptance criteria** (conditions for marking Done).
   - Ask **Dependencies** and **Promotion criteria** if not implied.
   - Ask, optionally: *"Does this item have an existing Notion page? If so, paste the link."* — write it to **Page link** if provided; leave blank otherwise. Never fabricate a URL.
   - Don't ask what's obvious (don't ask "Type" if they said "we need to build an automation").
4. **Confirm classification before writing.** State it back: "Filing under Domain: X · Priority: Y · Type: Z · Status: Sketched. Sound right?" Wait for yes / no / edit. **This confirmation step is the mechanism — never skip it.** If the user says no, ask which field to revise (one question), correct, and re-confirm.
5. **Write the row** with `notion-create-pages` against `data_source_id de6dbd05-8a63-4dde-82ec-8dd45c0dce45`, mapping interviewed content to the properties (including `Page link` if one was given). Set `Originating session` to the current session/date.
6. **Return the row link** to the user.

## Read flow

Map the request to a filter, query the data source, and format the result as a short table (Name · Status · Priority · Objective):

- "What's on the roadmap for [domain]?" → filter `Domain = <domain>`.
- "What's near-term?" → `Priority = Near-term AND Status != Live AND Status != Retired`.
- "What's in progress?" → `Status = In Progress`.
- "Show me the parking lot" → `Status = Parked OR Priority = Parked`.

The database already has matching saved views (Near-term, In progress, Parking lot, By Domain); point the user at them when useful.

## Rules

- **Verbatim seed.** Never improve or summarize `Originating context`.
- **Always confirm before writing.** No silent writes.
- **One interview question per turn.**
- **No Owner.** The field was removed; don't ask for or set an owner.
- **Page link only when a real page exists.** Capture it if the user supplies one; never fabricate.
- **Never delete rows** — items are retired (Status = Retired), not removed.
- **Flag offline fallback** whenever you built from the snapshot rather than live schema.

## References

- `references/00-snapshot.md` — dated offline fallback: database IDs, schema, select options, classification rules. Secondary to the live schema read.
- `references/domain-classifier.md` — keyword → Domain heuristics for auto-classification.
