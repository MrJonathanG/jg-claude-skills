# Evidence Artifact Build Pattern

The control update and the evidence artifact are separate concerns: the implementation-details field *describes*, the artifact *proves*. This file is the build pattern for the artifact.

## Format default

- **Default: editable `.docx`.** Evidence gets re-captured — screenshots swapped, exports refreshed. A Word file lets the owner replace the figures and re-export without a rebuild. PDF is the option, not the default.
- One control = one evidence record. Both/all supporting artifacts for that control go in the single record.

## Structure

1. **Title** — `CMMC Evidence Record` + the client-facing control cite (`AC.L2-3.1.10`).
2. **Metadata block** — Control (with full text), Organization (Freedom Surveillance, LLC dba StrongWatch), System/asset, Implementation (one-line standing description), Evidence captured (dates — these live *here*, not in Vanta's details field), Prepared by, CMMC scope (L1 / L2 staging).
3. **Assessment-objective coverage table** — one row per determination statement (`[a]`, `[b]`, `[c]`), each with its determination text and the evidence coverage note. Pull statements from NIST SP 800-171A.
4. **Figures** — each screenshot/export with a caption stating source + capture date.
5. **Scope note** — what the artifact does *not* cover (e.g. "supports AC.L2-3.1.10 only; does not satisfy AC.L2-3.1.11 session termination").

## Coverage table shape

| Determination statement | Evidence coverage |
|---|---|
| [a] the period of inactivity … is defined | Met — 900s defined in GPO; confirmed in registry (Fig. 1, Fig. 2) |
| [b] access/viewing is prevented by session lock … | Met — secure screensaver requires re-auth (Fig. 1, Fig. 2) |
| [c] previously visible info concealed via pattern-hiding display | Met — scrnsave.scr; ScreenSaverIsSecure=1 (Fig. 1, Fig. 2) |

## Repository discipline (v2.13)

- The loose Vanta upload is the **working copy**. It is not assessment-eligible on its own.
- Promote the final record to **SharePoint** (production layer); link Vanta to the SharePoint copy as the system of record.
- Per v2.13, only final-form documents from SharePoint are eligible as evidence; drafts are explicitly ineligible.

## Build mechanics

Use the `docx` skill to produce the file. The artifact is a JG & Co. deliverable; keep it clean and dated-as-captured. Place the output in the outputs directory and present it for download/upload.

## Scope reminder

Building the artifact is *recommended and supported* by this skill, but it is downstream of the field update. Do the in-Vanta field update first; build/attach the artifact second.
