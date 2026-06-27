# Field Conventions

Per-field detail for the Vanta control update sequence. The SKILL.md body has the rules; this file has the worked detail.

## Implementation details — per-objective worked example

A control is split into determination statements (`.a`, `.b`, `.c` …). Write one block per statement, each scoped to *only* that statement. Standing configuration only — no dates, counts, or anything that goes stale.

Worked set for session lock (Vanta `03.01.10` / `AC.L2-3.1.10`):

**`.a` — the period of inactivity is defined**
> A 900-second (15-minute) period of inactivity is defined for session lock on StrongWatch domain workstations. The value is configured via the CMMC Workstation Security Policy Group Policy Object (Interactive logon: Machine inactivity limit) and verified as applied at the endpoint through the registry (InactivityTimeoutSecs = 900).

**`.b` — session lock prevents access/viewing after the period**
> After the defined period of inactivity, StrongWatch domain workstations initiate a session lock that prevents access to the system and viewing of data until the user re-authenticates. The lock is enforced via the CMMC Workstation Security Policy GPO using a secure, password-protected screensaver, and verified at the endpoint through the registry (ScreenSaverIsSecure = 1, ScreenSaveTimeOut = 900).

**`.c` — pattern-hiding display conceals previously visible info**
> On session lock, StrongWatch domain workstations conceal previously visible information using a pattern-hiding display. The screensaver (scrnsave.scr) is enforced via the CMMC Workstation Security Policy GPO and verified at the endpoint through the registry (ScreenSaveActive = 1, SCRNSAVE.EXE = scrnsave.scr).

Note how `.a` only *defines*, `.b` only *locks/prevents*, `.c` only *conceals* — no bleed. Each could stand alone in front of an assessor.

### What goes where (the separation that prevents rot)

| Lives in… | Content | Updates when |
|---|---|---|
| Implementation details (this field) | Standing config: tool, setting name, verification key | Implementation actually changes |
| Evidence artifact (.docx/PDF) | Dated screenshots/exports, capture dates, machine names | Re-captured on cadence |
| Tests / Documents (Mapped elements) | Auto-collected or attached proof, pass/fail | Vanta's own cadence |

If a fact has a date or a count on it, it does **not** belong in implementation details.

## Implementation status — quick reference

| State | Set when | Notes |
|---|---|---|
| Not Started | Control never touched | Starting state |
| In Progress | Some objectives/tests satisfiable, not all | |
| Implemented | All tests satisfied | Never roll back on a later test failure (stale evidence ≠ regression) |

## Owner — vocabulary and join

- Owner vocabulary (only these): `IT Admin, HR, Facilities, vCISO, MSS/SOC, Compliance, COO`.
- Join key is **Vanta ID** (`IAC-601`), never the `03.xx` control number — the number is not unique across the framework join the way the ID is.
- Override `✓` = human-validated (authoritative); blank = LLM first-pass (suggestion, apply vCISO-artifact check).

### vCISO-artifact check (for blank-Override rows)

The L2 master's first-pass owners are domain-level defaults and are often wrong where a control touches a vCISO deliverable. Flag a likely correction when the objective is about:

- **SSP authoring / documentation** (e.g. `03.12.04` IAO-130–137; `03.11.4e` GOV-3033–3035) — default may say Compliance/RA, but SSP is a vCISO deliverable in this engagement.
- **Risk assessment methodology / cadence definition** (`03.11.x` "frequency is defined" objectives).
- **Scan-cadence / flaw-remediation timeframe definition** (`03.14.01` "time to … is specified").

Surface the probable owner; let the human confirm and set Override `✓`.

## Control type — examples by category

- **System Specific** — session lock (GPO/registry), AV config, password policy enforced via Entra, boundary config. Default.
- **Common** — security awareness practice, governance/review cadence satisfied org-wide.
- **CSP** — an M365/Azure inherited control where the provider satisfies the requirement.
- **Hybrid** — MFA where StrongWatch configures Conditional Access on top of a provider capability.
- **Not Applicable** — a requirement with no applicable assets in scope; always pair with a Note.

## Placeholders — to be written

These elements appear in Mapped elements and relate to a control update, but their method is not yet defined. Stubs only:

### Policies (placeholder)
A control's mapped Policies pass when the policy is approved (and, for some, employee-accepted). Method for confirming/linking policy mappings during a control update: **TBD.** Reference list: `Master Reference/<level>/CMMC <level> Policy Reference.md`.

### Procedures (placeholder)
Procedure documents map alongside policies for many controls. Method: **TBD.**

### SSP (placeholder)
The SSP is the authoritative implementation narrative and is itself a set of L2 controls (`03.12.04`). How an SSP section relates to / is referenced from a control update: **TBD.** SSP is a vCISO deliverable.

### Per-test / per-document assignment (placeholder — explicitly deferred)
Assigning individual tests/documents to owners inside Mapped elements is a separate motion (different actions, possibly similar lookup against the Test/Document reference lists). **Deferred to a later skill section.** This skill sets the control-level Owner only.
