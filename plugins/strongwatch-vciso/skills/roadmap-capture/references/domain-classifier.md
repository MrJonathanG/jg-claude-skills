# Domain classifier — keyword heuristics

Map the seed text to a `Domain` select option. If two domains fit equally, or none clearly fits, **ask** rather than guess. When work spans several categories, use **Cross-cutting**.

## Keyword → Domain

| Signal in the seed | Domain |
|---|---|
| roles, people, org structure, facilities, locations, governance cadence, vendors, tech inventory, who-does-what | Operating Model |
| accounts, MFA, Duo, Entra, SSO, identity, access, connectors, credentials | Cat 01 Identity & Access |
| Notion workspace, page structure, databases-in-Notion, workspace architecture | Cat 02 Notion Workspace |
| OneDrive, folder structure, file organization | Cat 03 OneDrive Structure |
| Microsoft 365, SharePoint, Teams, Exchange, M365 | Cat 04 Microsoft 365 & SharePoint |
| Vanta config, framework setup, control mapping in Vanta | Cat 05 Vanta Configuration |
| Granola, meeting capture config | Cat 06 Granola Configuration |
| Obsidian, vault, notes structure, data lake | Cat 07 Obsidian Setup |
| OpenAI, ChatGPT, GPT project, config mirroring | Cat 08 OpenAI Integration |
| reusable prompts, session prompt library | Cat 09 Reusable Session Prompts |
| Claude setup, plugins, skills, Cowork/Code config (the ecosystem itself) | Cat 10 Claude Ecosystem Setup |
| automation, scheduled workflow, HUD, SW.A*, SW.PUB, SW.CI, snapshot, extractor, monitor, drift check | Cat 11 Automation |
| template (Word/PPTX/Excel/page), reusable document scaffold | Cat 12 Templates |
| CMMC doc currency, reference material, knowledge base, assessment guides | Cat 13 Knowledge & References |
| reporting cadence, monthly review rhythm, status-report scheduling | Cat 14 Reporting & Cadence |
| business ops, housekeeping, contracts, SOW, engagement admin | Cat 15 Business & Housekeeping |
| control implementation, evidence, policies, the CMMC advisory work itself | Compliance Program |
| governance meeting content, board/leadership meeting artifacts | Governance Meetings |
| System Security Plan, system boundary, data flows, CUI scoping | SSP |
| a report/deck/briefing deliverable to leadership (the output, not its cadence) | Reporting |
| spans multiple categories / no single fit | Cross-cutting |

## Disambiguation notes

- **Automation vs Reporting** — a scheduled workflow that *produces* something is Cat 11 Automation; a leadership-facing *deliverable* (PPTX/Excel/briefing) is Reporting. If it's both (an automation that emits a report), prefer the user's emphasis and confirm.
- **Cat 10 vs Cat 11** — building the Claude ecosystem (plugins/skills config) is Cat 10; a specific scheduled workflow is Cat 11. A new *skill* item often classifies as Type = Skill or Plugin with Domain = Cat 10 or Cross-cutting.
- **Operating Model vs Compliance Program** — who/what/where/when of operations is Operating Model; the controls and evidence are Compliance Program.
- When in doubt between a specific Cat and Cross-cutting, ask: does this clearly belong to one category's page? If yes, use the Cat; if it informs many, use Cross-cutting.
