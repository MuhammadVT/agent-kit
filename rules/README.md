# User-level Cursor rules

Put `.mdc` files here. The installer links them into `~/.cursor/rules/`.

```markdown
---
description: Short summary shown in the rule picker
alwaysApply: false
---

# Rule title

Actionable instructions.
```

Use `alwaysApply: true` only for guidance that should load in every chat. Keep each rule to one concern and under ~50 lines.

These are **your** defaults. Project rules still belong in that project's `.cursor/rules/`.
