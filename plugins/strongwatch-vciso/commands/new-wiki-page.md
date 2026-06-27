---
description: Scaffold a new StrongWatch wiki page for a system, following the workspace conventions in 00. Wiki & Page Conventions.
argument-hint: [system or tool name, e.g. "Vanta Configuration"]
---

Scaffold a new Project Setup wiki entry for the system named in `$ARGUMENTS` (ask for it if empty), following the StrongWatch page conventions. Load the `notion-wiki-builder` skill and apply it.

Steps:

1. **Confirm scope & surface** — which Project Setup category/parent page this lives under. Confirm the surface is Project Setup (setup/config), not Advisory (operational).
2. **Read the live standard** — open `00. Wiki & Page Conventions` → Page Type Selection Guide and pick the smallest fitting template for this system (e.g. Tool / Platform Configuration for a platform, Capability Hub for a mature multi-subpage area). Open the chosen template page and a worked example. If Notion is unreachable, use the skill's `references/00-snapshot.md` and flag the fallback.
3. **Gather the substance first** — what the system is, what it accomplishes, why it's used, its components/structure, and how each is populated. Pull from the actual system (the vault, Vanta, the workspace) rather than inventing.
4. **Build to the chosen template** — mirror the template's structure; add the `Maturity` + `Last updated` banner; route detail to a child page if the parent should stay high-level (parents route, children detail). Wrap filenames in code spans.
5. **Honor source-of-truth & repository-vs-mechanism rules** — link to automations/runbooks rather than embedding their mechanics; keep one canonical place per fact.
6. **Wire navigation and back-links** — link new subpages from the parent; ensure referenced prompts/automations link back.
7. **Log the build** — add each page created as a sub-item of the category's parent task in the Project Setup Tasks DB, `Status: Done`, with `Date Completed`.
8. **Verify** — fetch the pages back; confirm the map/TOC shows every component, links resolve, banners present, and no content was duplicated.

Respect the Notion build mechanics in the skill's `references/notion-mechanics.md` (TOC blocks, sub-page cards, no anchor links, relation sub-items, `replace_content` child-page preservation). Pause for confirmation before archiving or replacing any existing page.
