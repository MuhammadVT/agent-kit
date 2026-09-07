#!/usr/bin/env bash
# Installs agent-kit skills, rules, and hooks into ~/.cursor
# Does not write to ~/.cursor/skills-cursor

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

link_path() {
  local link="$1"
  local target="$2"
  mkdir -p "$(dirname "$link")"
  if [[ -L "$link" ]]; then
    rm -f "$link"
  elif [[ -e "$link" ]]; then
    echo "Skip (exists, not a link): $link"
    return
  fi
  ln -s "$target" "$link"
  echo "Linked $link -> $target"
}

mkdir -p "$CURSOR_HOME" "$SKILLS_DST"

linked=0
if [[ -d "$SKILLS_SRC" ]]; then
  for dir in "$SKILLS_SRC"/*/; do
    [[ -d "$dir" ]] || continue
    if [[ -f "${dir}SKILL.md" ]]; then
      name="$(basename "$dir")"
      link_path "${SKILLS_DST}/${name}" "$(cd "$dir" && pwd)"
      linked=$((linked + 1))
    fi
  done
fi
if [[ "$linked" -eq 0 ]]; then
  echo "No skills with SKILL.md found under skills/"
fi

mkdir -p "$RULES_DST"
if [[ -d "$RULES_SRC" ]]; then
  shopt -s nullglob
  for file in "$RULES_SRC"/*.mdc; do
    link_path "${RULES_DST}/$(basename "$file")" "$file"
  done
  shopt -u nullglob
fi

hooks_json="${HOOKS_SRC}/hooks.json"
if [[ -f "$hooks_json" ]]; then
  if grep -Eq '"hooks"[[:space:]]*:[[:space:]]*\{[[:space:]]*\}' "$hooks_json"; then
    hook_count=0
  else
    hook_count=1
  fi
  if [[ "${hook_count}" -gt 0 ]]; then
    link_path "$HOOKS_JSON_DST" "$hooks_json"
    mkdir -p "$HOOKS_DIR_DST"
    shopt -s nullglob
    for file in "$HOOKS_SRC"/*; do
      base="$(basename "$file")"
      [[ -f "$file" ]] || continue
      [[ "$base" == "hooks.json" || "$base" == "README.md" ]] && continue
      link_path "${HOOKS_DIR_DST}/${base}" "$file"
    done
    shopt -u nullglob
  else
    echo "hooks/hooks.json has no events; skipping hook install"
  fi
fi

echo "Done."
