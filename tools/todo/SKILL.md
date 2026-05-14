---
name: todo-manager
description: Use when the user wants to manage personal tasks with the repository's Lua todo tool, including adding tasks, listing tasks, marking tasks done, or archiving completed tasks.
---

# Todo Manager

Use this skill when the user wants to interact with the todo tool instead of editing task files manually.

## Tool Location

- Entrypoint: `todo.lua`
- Data directory: `~/.local/share/toaam-dotfiles/todo`

## Commands

```bash
lua todo.lua add "Buy groceries"  # add a new task
lua todo.lua ls                   # list today's tasks
lua todo.lua ls done              # list completed tasks (today + archive)
lua todo.lua done 1               # mark task 1 done (100% completion)
lua todo.lua done 1 50            # mark task 1 done with 50% completion
lua todo.lua rm 1                 # delete task 1
lua todo.lua arch                 # move completed tasks to monthly archive
```

## Workflow

1. Run `ls` when the user wants to inspect current tasks.
2. Run `add <description>` when the user creates a new task.
3. Run `done <id>` when the user marks a numbered task complete. Optionally append a percentage (0-100) for partial completion.
4. Run `rm <id>` when the user wants to delete a task (regardless of completion status).
5. Run `ls done` when the user wants to see all completed tasks across today and the archive.
6. Run `arch` when the user wants completed tasks moved into the monthly archive.
7. Do not edit the task data files manually unless the user explicitly asks for repair or migration work.

## Notes

- The tool runs its daily sync logic on each invocation and may prompt to archive completed tasks from a previous day.
- Task data is stored outside the repository (`~/.local/share/toaam-dotfiles/todo/`) so the working tree stays clean.
- If `lua` is unavailable, report that dependency instead of rewriting the tool.
