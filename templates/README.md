# Project templates

Copy these into a **new product repo**. Do not symlink them globally.

Typical start:

- `AGENTS.md` — durable architecture and agent contract for that product
- `CLAUDE.md` — pointer at `AGENTS.md` for tools that look for that filename
- `cursor-rules/` — optional `.mdc` files to drop into `.cursor/rules/`

Fill in product-specific rules after copying. If a personal skill becomes useful to a team, copy it into that project's `.cursor/skills/` instead of keeping it only here.
