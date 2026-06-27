---
name: vanta-control-updater
description: Update and maintain StrongWatch CMMC controls in Vanta to one consistent standard. Use when completing, updating, or maintaining a control in Vanta — or when the user says "update this control", "complete this control in Vanta", "write the implementation details", "mark this implemented", "set the owner", "what control type is this", or works the Vanta control detail panel (Implementation status, Implementation details, Owner, Control type, Note, Mapped elements). Covers the field-by-field update sequence, the forward-only status rule, per-objective implementation-detail writing, owner sourcing from the Obsidian master reference lists (L1/L2), the master-vs-Vanta divergence rule, control-type selection, the Rev. 3 ↔ Rev. 2 numbering crosswalk, and building the editable evidence-record artifact. Does NOT cover per-test/per-document assignment (separate motion, deferred).
---

# Vanta Control Updater

Bring a StrongWatch CMMC control in Vanta from incomplete to properly maintained, touching every field that needs to be set so nothing is left half-done — written to one standard so any update reads the same and an assessor (or a future session) can trust it.

This skill is the in-Vanta counterpart to `notion-wiki-builder`: same plugin, same "here's how we do X to the workspace standard" intent, applied to the Vanta control detail panel instead of Notion pages.

## When to use

Apply when updating, completing, or maintaining any control in Vanta's CMMC 2.0 framework — working the control detail panel (the pane with ID, Domain, Owner, Control set, Note, Control type, Implementation status, Implementation details, and the Mapped elements tabs). Also apply when writing implementation-detail text, setting a control owner, or building an evidence record to attach.

Do **not** use this for per-test or per-document *assignment* inside Mapped elements — that is a separate motion with its own method, deferred to a later skill section. This skill sets the control-level fields and the control Owner only.

## Know what Vanta status is — and is not (read first)

Vanta's CMMC 2.0 framework is loaded as **NIST 800-171 Rev. 3** (`03.xx.xx.x` numbering), but CMMC is officially on **Rev. 2** (ADR-010). Two consequences that govern everything below:

- **Vanta is the evidence repository and dashboard, not the authoritative L1 compliance tracker.** The authoritative L1 control state lives in **Notion L1 Control Status**. Updating a control in Vanta is not the same as moving the L1 tracker — a control can read **Implemented** in Vanta while its assessment-facing state is tracked separately in Notion.
- **Cite controls to the client in `AC.L2-3.1.10[a]` form**, never Vanta's raw `03.01.10.a`. The crosswalk is in `references/crosswalk.md`. Vanta's number is an internal join handle; the assessment guide number is what goes in client-facing text.

## The update sequence (walk every field)

Update in this fixed order so no field is skipped. Detail for each step is in `references/field-conventions.md`.

1. **Determine level** — read the **Control set** chip (LV 1 / LV 2). This selects which master reference list governs the owner (step 4).
2. **Implementation status** — set per the state machine below.
3. **Implementation details** — write per-objective, standing-config only (no stale-prone data). See the rules below.
4. **Owner** — look up in the matching Obsidian master list; never assign from memory. See "Owner sourcing."
5. **Control type** — set per the selection rule below.
6. **Note** — set only if a standard-qualifying exception applies.
7. **Mapped elements** — confirm tests/documents/policies are mapped; assignment of individual tests is out of scope.

## Implementation status — forward-only state machine

Three states, and status **only ever moves forward**:

- **Not Started** — the control has never been touched.
- **In Progress** — some determination statements / tests can be satisfied, but not all.
- **Implemented** — all tests for the control are satisfied.

**Forward-only rule:** never roll status back. A *failing* test does not demote Implemented → In Progress. A failure usually means evidence went **stale**, not that the implementation regressed — the maturity of the implementation hasn't changed, only the freshness of its proof. Status reflects implementation maturity; test pass/fail reflects evidence freshness. They are different axes. (This is why Vanta status ≠ compliance state — see above.)

## Implementation details — the writing standard

- **Standing configuration only.** Describe how the control is implemented as a durable state. **No timestamps, evidence dates, vuln counts, or anything that goes stale** — those live on the evidence artifacts and tests, which update on their own cadence. Duplicating them into this field guarantees rot.
- **Generic but specific.** The reliable shape: *tool + setting/policy name + verification key*. Example: "...configured via the CMMC Workstation Security Policy GPO (Interactive logon: Machine inactivity limit) and verified at the endpoint through the registry (InactivityTimeoutSecs = 900)."
- **One block per determination statement.** Vanta splits a control into `.a / .b / .c …` objectives. Write a **distinct** block for each — do not blob one description across all of them, and do not let `.b`'s language (e.g. *locking*) bleed into `.a` (*defining* the period). Pull the statements from NIST SP 800-171A; worked examples in `references/field-conventions.md`.

## Owner sourcing — master reference lists (L1 / L2)

Owner is **JG judgment captured in the Obsidian master**, never guessed in the moment. The lists live at:

- `Compliance Tracking/Master Reference/L1/CMMC L1 Control Master Reference.md`
- `Compliance Tracking/Master Reference/L2/CMMC L2 Control Master Reference.md`

Sourcing steps:

1. By **Control set** (LV1/LV2), open the matching list.
2. Match the row on **Vanta ID** (the stable join key — `IAC-601`, `AST-158` — *not* the `03.xx` number).
3. Read **Owner**. Constrain to the owner vocabulary: `IT Admin, HR, Facilities, vCISO, MSS/SOC, Compliance, COO`.
4. Check the **Override** column:
   - **`✓`** — a human has validated/changed this row's Owner/Effort/Priority. Treat the Owner as **authoritative**.
   - **blank** — the row is still a first-pass LLM suggestion. Treat the Owner as a **suggestion**, and apply the vCISO-artifact check: if the control touches a known vCISO deliverable (SSP authoring, risk methodology, scan-cadence definition), the domain-default owner is likely wrong — surface the probable correction rather than trusting it.

### Divergence rule (surface, don't auto-resolve)

When Vanta and the master disagree, or the control is missing from the master, **do not silently pick one.** Make the human decide which is right and route the outcome:

- **Vanta owner ≠ master owner** → surface both; the human either *corrects Vanta* (Vanta drifted) or *recommends a master change* (master was outdated). On a master change, set **Override = `✓`**.
- **Vanta ID not in the master** → flag it; recommend adding the row with a proposed owner (common for L2 until the L2 list is fully curated). Don't block the update — proceed with the recommended owner, flagged as unconfirmed.

## Control type — selection rule

Vanta options: **Common, CSP, Hybrid, Not Applicable, System Specific.** Default reasoning for StrongWatch:

- **System Specific** — enforced on StrongWatch's own systems (GPO, registry, endpoint config). Most L1/L2 technical controls land here. **Default unless a reason to deviate.**
- **Common** — satisfied org-wide by policy/process rather than a system (e.g. an awareness or governance practice).
- **CSP** — inherited from a cloud provider (M365 / Azure inherited controls).
- **Hybrid** — shared between StrongWatch config and an inherited provider control.
- **Not Applicable** — out of scope for the environment; pair with a Note explaining why.

## Note — standard when used

Optional, but when set it follows one standard: the Note is for **exceptions, scoping caveats, or deviations** — *why this control is unusual* — not a restatement of the implementation. Implementation details = how it's done; Note = why it's atypical (e.g. "Inherited from M365 — see CSP control X"; "N/A: no remote access permitted in scope"). Leave blank if nothing qualifies.

## Evidence artifact (recommend, and build)

The control update and the evidence artifact are **separate concerns**. The implementation-details field *describes*; the evidence artifact *proves*. Recommend an artifact whenever a control's proof is a screenshot/export rather than an auto-collected test.

When building one, default to an **editable `.docx`** (evidence gets re-captured — screenshots swapped, re-exported), with PDF as the option. Build pattern, structure, and the determination-statement coverage table are in `references/evidence-artifact.md`. Per v2.13, only final-form documents promoted to SharePoint are assessment-eligible — the loose Vanta upload is the working copy; link Vanta to the SharePoint copy as the system of record.

## Out of scope (deferred)

- **Per-test / per-document assignment** inside Mapped elements — related but distinct method; later skill section.
- **Policies / Procedures / SSP mapping** — placeholders in `references/field-conventions.md`; method to be written.

## Update checklist

- [ ] Level read from **Control set** (LV1/LV2)
- [ ] Status set per the forward-only state machine (never rolled back on a failed test)
- [ ] Implementation details: per-objective, standing-config only, no stale data
- [ ] Owner matched on **Vanta ID** in the correct master list; Override respected; divergence surfaced not auto-resolved
- [ ] Control type set (System Specific unless a reason to deviate)
- [ ] Note set only if a qualifying exception applies
- [ ] Client-facing references use `AC.L2-3.1.10[a]` form, not `03.01.10.a`
- [ ] Evidence artifact recommended/built as `.docx`; SharePoint copy is the eligible system of record
- [ ] Remembered: Vanta status ≠ Notion L1 compliance state

## References

- `references/field-conventions.md` — per-field detail, per-objective implementation-detail worked examples, Policies/Procedures/SSP placeholders.
- `references/crosswalk.md` — the Rev. 3 (`03.xx.xx.x`) ↔ Rev. 2 / assessment-guide (`AC.L2-3.x.x[x]`) numbering crosswalk and citation rule.
- `references/evidence-artifact.md` — the `.docx`/PDF evidence-record build pattern, structure, and determination-statement coverage table.
