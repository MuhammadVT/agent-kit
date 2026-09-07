# agent-kit

Personal toolkit for agent instructions: skills, user rules, hooks, prompts, and project templates.

This repo is the **source**. Tools read from install locations (`~/.cursor/skills`, a project's `AGENTS.md`, and so on). Clone this kit, run the installer, and copy templates into new projects.

## Layout

```text
agent-kit/
  skills/          personal skills (installed globally)
  rules/           user-level Cursor rules
  hooks/           global hooks
  prompts/         reusable prompts, opened on demand
  templates/       copy into a project; do not symlink globally
  bin/             helpers used by the install scripts
```

| Path | Install as | Applies to |
|---|---|---|
| `skills/`, `rules/`, `hooks/` | Symlink into `~/.cursor/...` | You, every project |
| `templates/` | Copy into a new repo | That product only |
| `prompts/` | Open or `@`-mention when needed | On demand |

Do **not** put a live product `AGENTS.md` here. Keep product rules in that product's repo. Use `templates/` only as a starter.

## Install

From this directory:

Windows (PowerShell):

```powershell
.\install.ps1
```

macOS / Linux:

```bash
chmod +x install.sh uninstall.sh
./install.sh
```

The installer links skills that contain a `SKILL.md`, user rules (`*.mdc`), and hooks when `hooks/hooks.json` defines any. It never writes into `~/.cursor/skills-cursor/` (Cursor's built-in skills).

Uninstall:

```powershell
.\uninstall.ps1
```

```bash
./uninstall.sh
```

## Add to the kit

- **Skill** — `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`). Re-run the installer.
- **User rule** — `rules/<name>.mdc`. Re-run the installer.
- **Prompt** — drop a markdown file under `prompts/<topic>/`. No install step.
- **Project starter** — edit files under `templates/`, then copy them into a new repo.

See `AGENTS.md` in this repo for how to maintain the kit itself.

## New project

Copy what you need from `templates/`:

```powershell
Copy-Item templates\AGENTS.md <project>\AGENTS.md
Copy-Item templates\CLAUDE.md <project>\CLAUDE.md
```

Then fill in product-specific rules. Do not symlink templates globally.
