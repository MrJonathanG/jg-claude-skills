# Numbering Crosswalk — Rev. 3 (Vanta) ↔ Rev. 2 / Assessment Guide

Vanta's CMMC 2.0 framework is loaded as **NIST SP 800-171 Rev. 3** and numbers controls `03.xx.xx.x`. CMMC is officially on **Rev. 2** (ADR-010), and client-facing text uses the **CMMC Assessment Guide** form `XX.Ln-b.1.x` (L1) or the `XX.Ln-3.x.x[obj]` short form people use in practice. This file holds the translation so the numbering is never fumbled.

## The citation rule

- **In Vanta** (internal): the control shows as `03.01.10.a`. Fine to use when talking *about the Vanta panel*.
- **To the client / in evidence / in the SSP**: cite `AC.L2-3.1.10[a]`. Never put `03.01.10.a` in client-facing text.

## How to translate (rule, not a full table)

The `03.xx.xx` maps to the legacy `3.x.x` by dropping the leading `03.0` and reading the domain:

- `03.01.xx` → **AC** (Access Control) → `3.1.xx`
- `03.02.xx` → **AT** (Awareness & Training) → `3.2.xx`
- `03.03.xx` → **AU** (Audit & Accountability) → `3.3.xx`
- `03.04.xx` → **CM** (Configuration Management) → `3.4.xx`
- `03.05.xx` → **IA** (Identification & Authentication) → `3.5.xx`
- `03.06.xx` → **IR** (Incident Response) → `3.6.xx`
- `03.07.xx` → **MA** (Maintenance) → `3.7.xx`
- `03.08.xx` → **MP** (Media Protection) → `3.8.xx`
- `03.09.xx` → **PS** (Personnel Security) → `3.9.xx`
- `03.10.xx` → **PE** (Physical Protection) → `3.10.xx`
- `03.11.xx` → **RA** (Risk Assessment) → `3.11.xx`
- `03.12.xx` → **CA** (Security Assessment) → `3.12.xx`
- `03.13.xx` → **SC** (System & Communications Protection) → `3.13.xx`
- `03.14.xx` → **SI** (System & Information Integrity) → `3.14.xx`

Then append the objective letter in brackets, and prefix the level. Level comes from the Vanta **Control set** chip (LV1 → `L1`, LV2 → `L2`).

### Worked examples

| Vanta (Rev. 3) | Domain | Level | Client-facing cite |
|---|---|---|---|
| `03.01.10.a` | AC | LV2 | `AC.L2-3.1.10[a]` |
| `03.04.01.e` | CM | LV2 | `CM.L2-3.4.1[e]` |
| `03.05.03.b` | IA | LV2 | `IA.L2-3.5.3[b]` |

### `e`-suffix enhanced requirements

Rev. 3 introduces enhanced requirements with an `e` in the control segment (e.g. `03.01.2e`, `03.11.1e`). These are Rev. 3-specific NFO/enhanced items without a clean Rev. 2 equivalent. When one appears, flag it: it may not map to a CMMC L2 assessment objective at all, and should be confirmed against the authoritative assessment guide before citing to the client.

## Important caveat

CMMC L1 is authoritatively cited from **CMMC Assessment Guide Level 1 v2.13** in `AC.L1-b.1.i` form — *not* the `3.1.1` short form. For L1 controls, use the v2.13 `XX.L1-b.1.x` identifiers, not a mechanically translated `3.x.x`. The translation rule above is for locating/relating the control; the authoritative L1 citation is the v2.13 string.
