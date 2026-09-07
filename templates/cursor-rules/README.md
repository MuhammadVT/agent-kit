# Project Cursor rules

Copy `.mdc` files from here into a product repo's `.cursor/rules/` directory.

```markdown
---
description: What this rule covers
globs: "**/*.ts"
alwaysApply: false
---

# Title

One concern. Concrete examples.
```

Use `globs` when the rule applies only to matching files. Use `alwaysApply: true` only for repo-wide standards.
