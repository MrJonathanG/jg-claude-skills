# 00 Wiki Standard — offline snapshot (fallback only)

> **Secondary to the live `00. Wiki & Page Conventions` in Notion.** If you can reach Notion, use the live pages — they win. Use this only when Notion is unreachable, and say so in your output.
> **Snapshot date:** 2026-06-01 · refresh when 00 changes materially.

## Surfaces
- **Project Setup** — internal rebuildable wiki (setup / config / tooling / standards / handoff).
- **Strongwatch CMMC Advisory** — live operating layer (status, HUDs, reporting).
- **Obsidian** — data lake. **OneDrive / SharePoint** — durable files.

## Page maturity
Stub → Draft → Structured → Operational → Verified. Every page shows `Maturity` + `Last updated`.

## Pick the smallest fitting template

| If the page needs to… | Template |
|---|---|
| general structured page, no special format | General Wiki Page |
| document a broad infrastructure domain | Infrastructure Domain |
| document how a tool/platform is configured | Tool / Platform Configuration |
| document accounts, MCPs, MFA, connectors, credentials | Identity & Access |
| a mature capability with multiple subpages | Capability Hub |
| track current state across many records | Index / Register |
| explain one component / workflow / integration | Detail Page |
| document one recurring / scheduled workflow | Automation Page |
| capture a future-state model (not live) | Design Guide |
| step-by-step build / run / recovery | Runbook / Build Spec |
| track future / parked / candidate work | Roadmap |
| define rules / conventions / required fields | Standards |

Parents route; children detail. A tool/platform or capability page may summarize and route to a child Detail page (e.g., `05. Vanta Configuration` → its `Configuration` sub-page).

## Source-of-truth & redundancy rules
- One canonical place per fact / prompt / definition / status.
- Parents summarize and route; child pages explain. Indexes track state; detail pages explain mechanics.
- Source files execute; Notion explains (unless Notion is the source of truth).
- Link generated outputs, don't copy them back. Mark design/future as not-live. Retired/consolidated workflows point to their replacement.

## Repository vs. mechanism
- **Repository / tool pages** — what a place/platform is for + how it's used; **link to** the automations/runbooks that populate it.
- **Automation / runbook pages** — what the workflow moves/transforms; **link back to** the repository/platform.
- Don't duplicate mechanics into repo pages, or repo purpose into automation pages.

## Note
Essentials only. Full template structures and the current page→template mapping live in Notion `00`. When building from this snapshot, keep it simple and reconcile against live 00 once Notion is reachable.
