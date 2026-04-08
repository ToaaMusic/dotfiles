---
name: todo-manager
description: Use when the user wants to manage personal tasks with the repository's Lua todo tool, including adding tasks, listing tasks, marking tasks done, or archiving completed tasks.
---

# Todo Manager

Use this skill when the user wants to interact with the todo tool instead of editing task files manually.

## Tool Location

- Entrypoint: `todo.lua`
- Data directory: `$XDG_DATA_HOME/toaam-dotfiles/todo` or `~/.local/share/toaam-dotfiles/todo`

## Commands

```bash
lua tools/todo/todo.lua ls
lua tools/todo/todo.lua add "Buy groceries"
lua tools/todo/todo.lua done 1
lua tools/todo/todo.lua archive
```

## Workflow

1. Run `ls` when the user wants to inspect current tasks.
2. Run `add` with the full task text when the user creates a new task.
3. Run `done <id>` when the user marks a numbered task complete.
4. Run `archive` when the user wants completed tasks moved into the monthly archive.
5. Do not edit the task data files manually unless the user explicitly asks for repair or migration work.

## Notes

- The tool runs its daily sync logic on each invocation and may prompt to archive completed tasks from a previous day.
- Task data is stored outside the repository so the working tree stays clean.
- If `lua` is unavailable, report that dependency instead of rewriting the tool.
