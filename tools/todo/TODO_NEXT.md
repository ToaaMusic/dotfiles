# Todo Project Handover & Next Steps

## 🚩 当前进度 (2026-04-03)
1. **Lua 核心已实现**: 支持 `add`, `ls`, `done`, `archive` 命令。
2. **交互式同步**: 实现了跨天检测昨日任务并询问归档的功能。
3. **包装脚本**: 提供了 `/home/ToaaM/repos/linux/dotfiles/tools/todo/todo` 绝对路径包装脚本。
4. **数据结构**: 数据存放在 `data/` 下，采用 Markdown 格式和 Lua 状态文件。

## 📝 待办任务 (Next Session)
- [ ] **全局 README 更新**: 将本工具的说明合并到父目录的 `dotfiles/README.md` 中。
- [ ] **Alias 优化**: 在 `.zshrc` 或 `.bashrc` 中添加 `alias todo='/home/ToaaM/repos/linux/dotfiles/tools/todo/todo'`。
- [ ] **功能扩展**: 
    - 增加 `todo clean` 清理空的归档。
    - 增加 `--yes` 或 `-y` 标记以支持非交互式调用。
- [ ] **补全脚本**: 为 Zsh/Bash 编写简单的 Tab 补全支持。

## 💡 技术提示
- Lua 核心路径: `/home/ToaaM/repos/linux/dotfiles/tools/todo/todo.lua`
- 数据路径: `/home/ToaaM/repos/linux/dotfiles/tools/todo/data/`
