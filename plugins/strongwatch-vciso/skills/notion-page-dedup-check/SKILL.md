---
name: notion-page-dedup-check
description: "Mandatory validate-before-create discipline for Notion pages in the StrongWatch engagement workspace. Apply before creating ANY new Notion page, subpage, tracker, log, or database — whenever about to call notion-create-pages, or when the user says add a page, make a subpage, create a tracker, set up a log, start a new doc in Notion, or names a page that may already exist. Forces a search of the target parent and the workspace for an existing page that already serves the purpose, then routes to append-to-existing over create-new. Prevents duplicate pages and fragmented logs. Composes with notion-pm-workflow and notion-wiki-builder. Does not apply to database rows, comments, or non-Notion surfaces."
---

# Notion Page Dedup Check

Before creating any new Notion page, verify nothing already exists that serves the purpose. The workspace is a single source of truth with a hub-and-spoke structure; a duplicate page fragments state and breaks the "one canonical surface per purpose" rule. The cost of a search is trivial; the cost of a duplicate is silent drift that someone has to find and reconcile later.

This skill encodes the discipline that the create-step must be preceded by a search-step. It is not optional and not a judgment call.

## When to apply

Apply before EVERY Notion page creation:

- Direct: "add a page", "make a subpage", "create a tracker", "set up a log", "start a new doc", "spin up a page for X"
- Implicit: any point where the next action would be `notion-create-pages`
- Named-target: the user names a page/section that plausibly already exists ("log this under the Vanta page", "add to our vendor tracker")

Does NOT apply to:

- Adding a row to an existing database (that is the correct append action, not a page creation)
- Posting a comment, or editing existing page content
- Non-Notion surfaces (files, OneDrive, SharePoint, ClickUp)
- Creating a page the user has already explicitly confirmed is new after a search this session

## The discipline (required sequence)

1. **Identify the purpose and the likely parent.** What is this page for, and where would it live? Resolve the parent page first (fetch it) — this is where a duplicate is most likely to already sit.

2. **Search before creating.** Run at least two checks:
   - Fetch the target parent page and read its subpage list and "Related pages" section for anything serving the same purpose.
   - Run `notion-search` on the purpose keywords (e.g. "support feature requests", "vendor tracker", "scope log") to catch a page that lives elsewhere.

3. **Decide: append vs. create.**
   - An existing page serves the purpose → **append to it** in its existing structure (match its schema/columns; do not impose a new one). Stop here — do not create.
   - A close-but-not-exact page exists → surface it to the user and ask whether to extend it or create a sibling. Do not silently create.
   - Nothing exists → proceed to create, and place it under the correct parent per the workspace directory routing.

4. **State the finding before acting.** One line: "Found existing page X — appending" or "No existing page for this — creating under Y." Never create silently.

## If a duplicate was already created

If a duplicate page already exists (created earlier this session or found during the check):

1. Migrate the intended content into the canonical page, matching its existing schema.
2. Neutralize the duplicate: replace its content with a "duplicate — safe to delete" banner pointing to the canonical page URL. The Notion MCP has no delete/archive command, so flag it for the user to trash in the UI.
3. Surface both actions to the user, including the one manual step (move to Trash) they must take.

## Matching existing structure

When appending to an existing log or tracker, adopt its column schema verbatim. Do not introduce a different column set (e.g. the existing log uses Date · Type · Request/issue · Status · Notes — match that, not a freshly invented Topic · Request Date · Description). A consistent table is worth more than a "better" one that splits the record across two shapes.

## Stop-and-surface triggers

- About to call `notion-create-pages` without having fetched the parent and run a search this turn → stop, search first.
- Search surfaces a page that plausibly serves the purpose → stop, surface it, ask before creating a sibling.
- The "right" parent is ambiguous (could live in two places) → ask, citing the engagement directory routing, rather than guessing.

## Composition

- **notion-pm-workflow** — owns tracker/database conventions and discovered-work routing. This skill runs first (is there already a page?), then defers to it for how to structure the content once the create-vs-append decision is made.
- **notion-wiki-builder** — owns wiki page formatting/standards. This skill is the pre-check; the builder is the constructor. Run this skill's search before invoking the builder to create a new page.
- Independent of non-Notion surfaces.
