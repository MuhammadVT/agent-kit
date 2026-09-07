#!/usr/bin/env bash
# Removes agent-kit links from ~/.cursor. Leaves unrelated files in place.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
CURSOR_HOME="${HOME}/.cursor"
SKILLS_SRC="${REPO_ROOT}/skills"
RULES_SRC="${REPO_ROOT}/rules"
HOOKS_SRC="${REPO_ROOT}/hooks"

SKILLS_DST="${CURSOR_HOME}/skills"
RULES_DST="${CURSOR_HOME}/rules"
HOOKS_JSON_DST="${CURSOR_HOME}/hooks.json"
HOOKS_DIR_DST="${CURSOR_HOME}/hooks"

remove_link() {
  local path="$1"
  if [[ -L "$path" ]]; then
    rm -f "$path"
    echo "Removed $path"
  fi
}

if [[ -d "$SKILLS_SRC" ]]; then
  for dir in "$SKILLS_SRC"/*/; do
    [[ -d "$dir" ]] || continue
    remove_link "${SKILLS_DST}/$(basename "$dir")"
  done
fi

if [[ -d "$RULES_SRC" ]]; then
  shopt -s nullglob
  for file in "$RULES_SRC"/*.mdc; do
    remove_link "${RULES_DST}/$(basename "$file")"
  done
  shopt -u nullglob
fi

remove_link "$HOOKS_JSON_DST"

if [[ -d "$HOOKS_SRC" ]]; then
  shopt -s nullglob
  for file in "$HOOKS_SRC"/*; do
    base="$(basename "$file")"
    [[ -f "$file" ]] || continue
    [[ "$base" == "hooks.json" || "$base" == "README.md" ]] && continue
    remove_link "${HOOKS_DIR_DST}/${base}"
  done
  shopt -u nullglob
fi

echo "Done."
