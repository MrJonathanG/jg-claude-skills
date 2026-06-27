# Vanta Control Updater

A StrongWatch vCISO plugin skill for updating and maintaining CMMC controls in Vanta to one consistent standard.

## What it does

Walks a fixed field-by-field sequence for updating a control in Vanta's CMMC 2.0 control detail panel so nothing is left half-done and every update reads the same way. Encodes the forward-only implementation-status state machine, the per-objective implementation-detail writing standard (standing config only, no stale data), owner sourcing from the Obsidian L1/L2 master reference lists with the Override-column and divergence rules, control-type selection, the Note standard, the Rev. 3 ↔ Rev. 2 numbering crosswalk, and the editable-`.docx` evidence-record build pattern.

## When it activates

When updating, completing, or maintaining a control in Vanta — working the control detail panel, writing implementation details, setting an owner or control type, or building an evidence record to attach. Trigger phrases include "update this control", "complete this control in Vanta", "write the implementation details", "mark this implemented", "set the owner", "what control type is this."

Does NOT activate for per-test/per-document assignment inside Mapped elements (deferred), or for Notion page building (that's `notion-wiki-builder`).

## What you need to provide

- The Vanta control being updated (the control detail panel — at minimum its Vanta ID and Control set chip).
- Access to the Obsidian master reference lists (via M365/SharePoint) for owner lookup, or acceptance that the owner will be flagged unconfirmed.
- For evidence artifacts: the screenshots/exports that prove the control.

## What it produces

- A correctly and consistently updated Vanta control (status, implementation details, owner, control type, note).
- Per-objective implementation-detail text, ready to paste.
- Surfaced master-vs-Vanta divergences for human decision (not auto-resolved).
- Optionally, an editable `.docx` evidence record built to the standard structure.

## Composition

- **`notion-wiki-builder`** (same plugin) — parallel "to the workspace standard" skill for Notion pages. This skill is its in-Vanta counterpart. They don't overlap: Notion = state/structure, Vanta = evidence/control panel.
- **`docx`** (public) — used to build the evidence artifact.
- **`audit-verification`** (user) — the divergence "surface, don't auto-resolve" rule is consistent with its ground-truth ethic; use it when verifying a control is genuinely Met vs. cosmetically updated.

## Usage patterns

- "Complete the session-lock control in Vanta" → walk the sequence: read Control set (LV2) → set status → write `.a/.b/.c` details → look up owner in L2 master by Vanta ID → set control type System Specific → build `.docx` evidence record.
- "Write the implementation details for 03.04.01.e" → per-objective block, standing config only, cited client-facing as `CM.L2-3.4.1[e]`.
- "Who owns this control?" → match Vanta ID in the matching master list, respect Override, surface divergence if Vanta disagrees.

## Common mistakes

- **Putting dates/counts in implementation details.** They go stale; they belong on the evidence artifact, not the field.
- **Rolling status back when a test fails.** Status is forward-only; a failed test is usually stale evidence, not regression.
- **Reading "Implemented" in Vanta as "L1-compliant."** Vanta status ≠ Notion L1 compliance state (ADR-010).
- **Citing `03.01.10.a` to the client.** Use `AC.L2-3.1.10[a]`.
- **Auto-resolving a master-vs-Vanta owner disagreement.** Surface it; let the human decide and set Override `✓`.
- **Matching the master on the `03.xx` number.** Match on Vanta ID.

## Files in this skill

- `SKILL.md` — the skill body: update sequence, rules, checklist.
- `references/field-conventions.md` — per-field detail, per-objective worked examples, Policies/Procedures/SSP placeholders.
- `references/crosswalk.md` — Rev. 3 ↔ Rev. 2 / assessment-guide numbering crosswalk and citation rule.
- `references/evidence-artifact.md` — the `.docx`/PDF evidence-record build pattern.
- `evals/evals.json` — 7 test cases covering triggers, the forward-only rule, the stale-data rule, owner sourcing/divergence, the crosswalk, composition boundary, and a negative case.
