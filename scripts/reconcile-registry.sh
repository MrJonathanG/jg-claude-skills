#!/usr/bin/env bash
#
# reconcile-registry.sh — registry-vs-reality reconciliation (the sync routine's job).
#
# Mechanical checks only. This script NEVER edits skill bodies — it reports.
# The daily sync routine runs it, then a human (or Claude, with approval) acts
# on the findings by opening an issue/PR. See standards/change-control.md.
#
# Checks:
#   1. Every skills/<name>/ directory has a row in SKILL_REGISTRY.md.
#   2. Every SKILL_REGISTRY.md row has a skills/<name>/ directory.
#   3. Each skill dir has a SKILL.md whose frontmatter `name` == dir name.
#   4. references/<file> paths mentioned in SKILL.md actually resolve (staleness).
#
# Exit code: 0 = clean, 1 = findings (for CI / routine gating).
#
# Usage: scripts/reconcile-registry.sh [repo-root]
set -euo pipefail

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SKILLS_DIR="$ROOT/skills"
REGISTRY="$ROOT/SKILL_REGISTRY.md"

findings=0
note() { printf 'FINDING: %s\n' "$1"; findings=$((findings + 1)); }

[ -d "$SKILLS_DIR" ] || { echo "ERROR: no skills/ dir at $SKILLS_DIR" >&2; exit 2; }
[ -f "$REGISTRY" ]   || { echo "ERROR: no SKILL_REGISTRY.md at $REGISTRY" >&2; exit 2; }

echo "== Reconciling registry vs reality =="
echo "root: $ROOT"
echo

# Skill directories on disk (exclude frozen/private dirs starting with _).
disk_skills=()
while IFS= read -r d; do
  base="$(basename "$d")"
  case "$base" in _*) continue ;; esac
  disk_skills+=("$base")
done < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d | sort)

# Skill names referenced by the registry: skills/<name>/ paths in the canonical
# table only. Everything from the "## Pending" heading onward is explicitly
# not-yet-real and is excluded from reconciliation. Lines naming an absolute
# install path (~/.claude/...) are also ignored — those aren't registry rows.
registry_skills=()
while IFS= read -r name; do
  [ -n "$name" ] && registry_skills+=("$name")
done < <(sed '/^## Pending/q' "$REGISTRY" \
         | grep -v '\.claude' \
         | grep -oE '(^|[^.A-Za-z])skills/[a-z0-9][a-z0-9-]*/' 2>/dev/null \
         | sed -E 's#.*skills/([^/]+)/#\1#' | sort -u)

contains() { local n="$1"; shift; for x in "$@"; do [ "$x" = "$n" ] && return 0; done; return 1; }

# Check 1: on disk but not in registry.
for s in "${disk_skills[@]:-}"; do
  [ -z "$s" ] && continue
  if ! contains "$s" "${registry_skills[@]:-}"; then
    note "skill '$s' exists in skills/ but has no row in SKILL_REGISTRY.md"
  fi
done

# Check 2: in registry but not on disk.
for s in "${registry_skills[@]:-}"; do
  [ -z "$s" ] && continue
  if ! contains "$s" "${disk_skills[@]:-}"; then
    note "SKILL_REGISTRY.md references '$s' but skills/$s/ does not exist"
  fi
done

# Checks 3 & 4: per-skill body sanity.
for s in "${disk_skills[@]:-}"; do
  [ -z "$s" ] && continue
  skill_md="$SKILLS_DIR/$s/SKILL.md"
  if [ ! -f "$skill_md" ]; then
    note "skills/$s/ has no SKILL.md"
    continue
  fi
  # Frontmatter name matches directory.
  fm_name="$(awk -F': *' '/^name:/ {print $2; exit}' "$skill_md" | tr -d '[:space:]')"
  if [ -n "$fm_name" ] && [ "$fm_name" != "$s" ]; then
    note "skills/$s/SKILL.md frontmatter name='$fm_name' != directory '$s'"
  fi
  # references/<file> mentions resolve.
  while IFS= read -r ref; do
    [ -z "$ref" ] && continue
    # Strip trailing sentence punctuation (md prose ends refs with . , ; etc.).
    ref="$(printf '%s' "$ref" | sed -E 's/[.,;:)]+$//')"
    [ -z "$ref" ] && continue
    if [ ! -e "$SKILLS_DIR/$s/$ref" ]; then
      note "skills/$s/SKILL.md references '$ref' which does not resolve (renamed/moved path?)"
    fi
  done < <(grep -oE 'references/[A-Za-z0-9._/-]+' "$skill_md" 2>/dev/null | sort -u)
done

echo
if [ "$findings" -eq 0 ]; then
  echo "OK: registry and reality are consistent (${#disk_skills[@]} skills checked)."
  exit 0
else
  echo "$findings finding(s). Propose fixes via issue/PR — do NOT rewrite bodies automatically."
  exit 1
fi
