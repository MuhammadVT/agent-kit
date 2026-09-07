# Global hooks

Cursor user hooks live at `~/.cursor/hooks.json` and `~/.cursor/hooks/*`.

Add hook scripts in this folder and list them in `hooks.json`. The installer copies `hooks.json` and scripts into `~/.cursor/` when `hooks.json` defines any events.

Prefer project hooks (`.cursor/hooks.json` in a product repo) when the behavior should be shared with that repository. Use this folder for hooks that should follow you across every project.

See Cursor's hook docs for event names (`beforeShellExecution`, `afterFileEdit`, and so on).
