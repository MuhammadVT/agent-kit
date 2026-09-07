# Personal skills

Each skill is a directory containing `SKILL.md`:

```text
skills/my-skill/
  SKILL.md
  reference.md    # optional
  examples.md     # optional
  scripts/        # optional
```

`SKILL.md` needs YAML frontmatter:

```markdown
---
name: my-skill
description: Does X. Use when the user asks to Y.
---
```

Write the description in third person, and include both **what** it does and **when** to apply it.

After adding a skill, re-run the installer from the repo root. Skills install to `~/.cursor/skills/<name>/`.

Do not put skills in `~/.cursor/skills-cursor/` — that path is reserved for Cursor's built-in skills.
