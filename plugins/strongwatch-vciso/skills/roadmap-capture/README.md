# Roadmap Capture

A StrongWatch vCISO plugin skill for capturing engagement workstream items into the Engagement Roadmap database — and answering roadmap read queries — via a guided interview.

## What it does

Turns a fresh idea into a well-formed database row at the moment intent is clearest. It captures the user's triggering message verbatim, interviews for Objective and Mission (the "why", not just the "what"), auto-classifies the obvious structured fields, **always confirms the classification before writing**, then commits the row to the Engagement Roadmap database and returns the link. It also answers read queries ("what's near-term", "what's on the roadmap for Cat 11"). Director model: it reads the live database schema at runtime and falls back to a dated offline snapshot only when Notion is unreachable.

## When it activates

- **Capture:** "I have a new idea for [domain]", "Add to the roadmap", "We need to build X", "We should also do Y", "Capture this as a future item", "Add to backlog", "Add to engagement roadmap".
- **Read:** "What's on the roadmap for [domain]?", "What's near-term?", "What's in progress?", "Show me the parking lot."

Does NOT activate for in-Vanta control updates (`vanta-control-updater`) or for building wiki pages (`notion-wiki-builder`).

## What you need to provide

- The idea or item itself (a sentence is enough to start — the skill interviews for the rest).
- Notion MCP access for the live schema read and the write. Without it, the skill builds from the offline snapshot and flags the fallback.
- Answers to the short interview: Objective, Mission, Acceptance criteria, any dependencies, and optionally a canonical Page link — one question at a time.

## What it produces

- A new row in the Engagement Roadmap database with the seed preserved verbatim, narrative Objective + Mission, classified Domain / Status / Priority / Type, and a Page link if one was supplied — written only after you confirm the classification.
- For read queries, a short formatted list filtered to the requested slice, with a pointer to the matching saved view.
- A clear flag when it built from the offline snapshot rather than the live schema.

## How it works (director model + fallback)

1. Reads the live data source schema (`collection://de6dbd05-8a63-4dde-82ec-8dd45c0dce45`) so it always uses current options.
2. If the live read fails, uses `references/00-snapshot.md` and says so.
3. Captures the seed verbatim → auto-classifies → interviews the gaps (one question per turn) → confirms → writes → returns the link.

## Auto-classification + confirmation rule

The skill proposes Domain (via `references/domain-classifier.md`), Type, Priority, and Status (default Sketched) from the seed. It then states the classification back and waits for yes / no / edit. **The confirmation step is the loss-prevention mechanism and is never skipped** — no silent writes, no writes on a rejected classification. There is no Owner field (removed in v0.4.1 — Jonathan is always the owner).

## Read query support

Maps natural-language requests to filters: by Domain, Near-term (Priority = Near-term, excluding Live/Retired), In progress (Status = In Progress), Parking lot (Status = Parked OR Priority = Parked). Returns a short table and points at the corresponding saved view.

## Limitations

- Relies on the Notion MCP being connected for live schema reads and writes; the offline fallback is a dated snapshot and may lag the live schema.
- Classification heuristics are best-effort; ambiguous cases are surfaced as a question, not guessed.
- Page link is only captured when the user supplies a real page; the skill never fabricates one.
- Writes are append-only; the skill never deletes rows (items are retired, not removed).

## Maintenance

- Refresh `references/00-snapshot.md` whenever the database schema changes materially (new Domain options, new Status values, renamed/removed properties).
- Keep `references/domain-classifier.md` in sync with new Domain options.
- The database data source ID is embedded in SKILL.md and the snapshot; update both if the database is rebuilt.

## Files in this skill

- `SKILL.md` — the capture/read protocol: live-schema-first flow, verbatim-seed rule, interview pattern, confirm-before-write rule, fallback rule.
- `references/00-snapshot.md` — dated offline fallback: database IDs, schema, select options, default classification rules.
- `references/domain-classifier.md` — keyword → Domain heuristics and disambiguation notes.
- `evals/evals.json` — test cases covering explicit/implicit triggers, disambiguation, confirmation rejection, read queries, and the live-vs-offline schema behavior.
