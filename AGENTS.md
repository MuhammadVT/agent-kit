# Agent instructions for agent-kit

This repository is a **personal agent toolkit**, not an application. Changes here should stay portable across machines and projects.

## What belongs here

Keep:

- Personal skills (`skills/<name>/SKILL.md`)
- User-level Cursor rules (`rules/*.mdc`)
- Global hooks (`hooks/`)
- Prompt library (`prompts/`)
- Project **templates** (`templates/`)

Leave out:

- Product-specific `AGENTS.md` files (those live in the product repo)
- Secrets, API keys, `.env` files
- Copies of Cursor's built-in skills (`~/.cursor/skills-cursor/`)

## Skills

Each skill is a directory with a `SKILL.md`:

```text
skills/example-skill/
  SKILL.md
```

Frontmatter:

- `name`: lowercase letters, numbers, hyphens; max 64 characters
- `description`: third person; what it does **and** when to use it

Keep `SKILL.md` under 500 lines. Put long reference material in sibling files one level deep (`reference.md`, `examples.md`).

Personal skills install to `~/.cursor/skills/`. Never write to `~/.cursor/skills-cursor/`.

## Rules vs templates

- `rules/` — how *you* work (commits, writing tone). Installed globally.
- `templates/` — starter files copied into a **project**. Edit the copy, not a symlink.

## Install after edits

After adding or renaming a skill, rule, or hook, re-run `install.ps1` (Windows) or `install.sh` (macOS/Linux).
