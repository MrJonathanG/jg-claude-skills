# notion-page-dedup-check

A guardrail skill that forces a "search before you create" step before any new Notion page is made in the StrongWatch engagement workspace. It exists to prevent duplicate pages and fragmented logs — the failure mode where a new tracker gets created next to an existing one that already does the same job, splitting state across two surfaces that then have to be found and reconciled by hand.

## What it does

Before Claude creates any Notion page, this skill makes it stop and check whether a page already serving that purpose exists. The workspace is built as a single source of truth with a hub-and-spoke layout, so every purpose is supposed to have exactly one canonical home. A duplicate quietly breaks that.

The mental model: page creation is a two-step action, not one. Step one is *search* (fetch the likely parent, search the workspace by purpose keywords). Step two is *create* — and only if step one came up empty. If an existing page is found, the correct action flips from "create a new page" to "append to the existing one," matching that page's existing structure rather than imposing a new one.

This is different from just asking Claude to make a page, because left to default behavior Claude will often create what was literally asked for without first checking that it already exists. The skill removes that as a judgment call and makes the search mandatory.

It also covers recovery: if a duplicate already got made, the skill drives migrating the content into the canonical page and neutralizing the duplicate with a "safe to delete" banner (since the Notion MCP can't delete pages itself).

## When it activates

Triggers on:

- Direct page-creation requests: "add a page", "make a subpage", "create a tracker", "set up a log", "start a new doc in Notion"
- Any point where Claude's next action would be `notion-create-pages`
- Named-target requests where the page might already exist: "log this under the Vanta page", "add to our vendor tracker"

Doesn't trigger on:

- Adding a row to an existing database (that's the correct append, not a creation)
- Commenting on or editing existing page content
- Non-Notion surfaces (OneDrive, SharePoint, ClickUp, local files)

## What you need to provide

The skill works from the engagement workspace structure; it needs enough context to identify the purpose of the intended page and its likely parent.

| Required/Optional | What to specify | Example |
|---|---|---|
| Required | What the page is for | "a log of vendor support requests" |
| Recommended | Where it should live (parent) | "under the Vanta Configuration page" |
| Optional | Any known existing page to check first | "I think there's already a Support page" |

## What it produces

A stated finding before any write happens — one line such as "Found existing page *Support & Feature Requests* — appending to it" or "No existing page for this — creating under *05. Vanta Configuration*." When appending, the new content matches the existing page's column schema. When a duplicate is being cleaned up, you get the migrated entry on the canonical page plus a flagged duplicate and a one-line note of the manual Trash step you need to take.

## Composition with other skills

Defers to **notion-pm-workflow** for tracker/database conventions and discovered-work routing — this skill runs first (does a page already exist?), then hands off to those conventions for structuring the content. Defers to **notion-wiki-builder** for wiki page formatting; this skill is the pre-check, the builder is the constructor. Independent of all non-Notion surfaces.

## Common usage patterns

**Existing page found — append:**
> User: "Create a vendor support tracker under the Vanta page and log this request."
>
> Claude (with skill): Fetches the Vanta page, sees an existing *Support & Feature Requests* subpage, states "Found existing log — appending in its schema," adds the row there. No new page created.

**Genuinely new — create after check:**
> User: "Add a page for the OneDrive folder map."
>
> Claude (with skill): Fetches the likely parent, searches "OneDrive directory map," finds nothing, states "No existing page — creating under Project Setup," then creates it.

**Ambiguous match — surface and ask:**
> User: "Make a page for tracking Huntress tickets."
>
> Claude (with skill): Search surfaces the general *Support & Feature Requests* log. States "There's an existing support log that covers vendor tickets — extend it with a Huntress section, or create a separate Huntress page?" and waits.

## Common mistakes

- **Creating first, checking never.** The default failure this skill prevents — building the page the user named without confirming it doesn't already exist.
- **Imposing a new schema on an existing log.** When appending, the new row must match the existing columns; introducing a different shape fragments the record even within one page.
- **Silent creation.** Always state the finding before writing. A create with no stated search leaves the user unable to catch a missed duplicate.
- **Treating a found duplicate as a delete decision.** Don't assume; neutralize with a banner and hand the Trash action to the user, since the MCP can't delete.

## Files in this skill

- `SKILL.md` — the skill itself (Claude reads this)
- `README.md` — this file; human-readable documentation
- `evals/evals.json` — test cases covering trigger, boundary, negative, and rule-coverage scenarios
