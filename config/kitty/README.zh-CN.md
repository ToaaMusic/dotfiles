# Kitty 配置指南

这份文档把原来 `kitty.conf` 里那些有价值的官方模板说明整理成中文，并结合这个仓库当前保留的配置做一个概览。

## 当前结构

现在的 live config 已经去掉了注释，但保留了旧文件中真正生效的配置项，主要分为这些部分：

- 主题与配色
  - `include default-colors.conf`
  - `include colors.g.conf`
- 字体设置
  - `font_family`
  - `bold_font`
  - `italic_font`
  - `bold_italic_font`
  - `font_size`
- 字形回退
  - `symbol_map`，用于 CJK 和 Nerd Font 图标
- 滚动与交互
  - `scrollback_lines`
  - `wheel_scroll_multiplier`
  - `touch_scroll_multiplier`
  - URL、选择、点击相关选项
- 窗口布局
  - `remember_window_size`
  - `initial_window_width`
  - `initial_window_height`
  - `window_border_width`
  - `draw_minimal_borders`
  - `window_padding_width`
- 标签栏
  - `tab_bar_margin_width`
  - `tab_bar_margin_height`
  - `tab_bar_style`
  - `tab_bar_min_tabs`
  - `tab_separator`
  - `tab_title_template`
  - `active_tab_title_template`
- 集成与会话
  - `allow_remote_control`
  - `listen_on`
  - `startup_session`
  - `shell`
  - `clipboard_control`
  - `shell_integration`
- 快捷键
  - 剪贴板
  - 滚动
  - 窗口管理
  - 标签管理
  - 布局切换
  - 字体大小调整

## 配置项分类

### 1. 主题与颜色

常见配置项：

- `include`：把颜色方案拆到单独文件
- `foreground`、`background`：终端默认前景色和背景色
- `selection_foreground`、`selection_background`：选中文本颜色
- `cursor`、`cursor_text_color`：光标颜色
- `active_tab_*`、`inactive_tab_*`、`tab_bar_background`：标签页颜色
- `color0` 到 `color15`：ANSI 终端色板
- `active_border_color`、`inactive_border_color`、`bell_border_color`：窗口边框颜色

这个仓库里，颜色主要由下面两个文件提供：

- [default-colors.conf](/home/ToaaM/repos/linux/dotfiles/config/kitty/default-colors.conf)
- [colors.g.conf](/home/ToaaM/repos/linux/dotfiles/config/kitty/colors.g.conf)

其中 `colors.g.conf` 是会动态生成的。

### 2. 字体与字形

常见配置项：

- `font_family`、`bold_font`、`italic_font`、`bold_italic_font`：四种基础字体
- `font_size`：字体大小
- `adjust_line_height`、`adjust_column_width`：调行高和列宽
- `symbol_map`：把某些 Unicode 范围映射到指定字体
- `narrow_symbols`：强制某些字符按固定宽度显示
- `font_features`：控制 OpenType 特性
- `modify_font`：调基线、下划线厚度、字符单元尺寸等

你当前的字体组合是：

- JuliaMono：代码主字体
- LXGW WenKai：中文
- Symbols Nerd Font Mono：图标符号

### 3. 光标

常见配置项：

- `cursor_shape`：`block`、`beam`、`underline`
- `cursor_blink_interval`
- `cursor_stop_blinking_after`
- `cursor_beam_thickness`
- `cursor_underline_thickness`
- `cursor_trail`

你当前启用了：

- `cursor_shape block`
- `cursor_blink_interval 0.5`
- `cursor_stop_blinking_after 15.0`
- `cursor_trail 3`

### 4. 回滚历史

常见配置项：

- `scrollback_lines`：内存中的历史行数
- `scrollback_pager`：用外部 pager 查看 scrollback
- `scrollback_pager_history_size`：只给 pager 使用的额外历史缓冲

你当前保留了：

- `scrollback_lines 2000`
- `scrollback_pager_history_size 0`

### 5. 鼠标、URL 与选择行为

常见配置项：

- `wheel_scroll_multiplier`
- `touch_scroll_multiplier`
- `open_url_with`
- `detect_urls`
- `url_style`
- `copy_on_select`
- `select_by_word_characters`
- `click_interval`

这些会影响鼠标滚动速度、URL 高亮与打开方式、双击选词边界等。

### 6. 性能与渲染

常见配置项：

- `repaint_delay`
- `sync_to_monitor`
- `background_opacity`
- `resize_debounce_time`
- `resize_draw_strategy`
- `inactive_text_alpha`

这些配置影响重绘节奏、显示器同步、透明度和非活跃窗口显示效果。

### 7. 铃声与通知

常见配置项：

- `enable_audio_bell`
- `visual_bell_duration`
- `window_alert_on_bell`
- `bell_on_tab`
- `command_on_bell`
- `bell_path`

你当前保留了：

- 音频 bell 开启
- 视觉 bell 时长为 `0.0`
- 标签页 bell 提示符号为 `"🔔 "`

### 8. 窗口布局与外观

常见配置项：

- `remember_window_size`
- `initial_window_width`
- `initial_window_height`
- `enabled_layouts`
- `window_resize_step_cells`
- `window_resize_step_lines`
- `window_border_width`
- `draw_minimal_borders`
- `window_margin_width`
- `single_window_margin_width`
- `window_padding_width`
- `hide_window_decorations`

你现在保留的是一套比较明确的布局偏好：

- 记住窗口尺寸
- 初始窗口大小为 `640 x 400`
- 所有 layout 可用
- 边框宽度为 `1`
- 开启 minimal borders
- padding 为 `10 10`

### 9. 标签栏

常见配置项：

- `tab_bar_style`
- `tab_bar_edge`
- `tab_bar_min_tabs`
- `tab_separator`
- `tab_title_template`
- `active_tab_title_template`
- `tab_bar_margin_width`
- `tab_bar_margin_height`
- `tab_bar_background`

你当前最有个性的部分就是 tab 样式模板，它定义了标签标题的外观。

### 10. 远程控制与会话

常见配置项：

- `allow_remote_control`
- `listen_on`
- `remote_control_password`
- `startup_session`
- `watcher`
- `env`
- `exe_search_path`
- `shell`

你当前使用了：

- `allow_remote_control yes`
- `listen_on unix:/tmp/kitty`
- `startup_session none`
- `shell zsh`

注意：

- `allow_remote_control yes` 是最宽松的模式
- 如果只需要 socket 控制，更安全的做法通常是 `socket-only`

### 11. 剪贴板与 Shell 集成

常见配置项：

- `clipboard_control`
- `clipboard_max_size`
- `allow_hyperlinks`
- `shell_integration`

你当前的剪贴板策略是：

- 允许写入 clipboard / primary
- 读取 clipboard / primary 时询问确认

这个设置比较合理，兼顾方便和安全。

### 12. 快捷键

可以从两层来理解：

- Kitty 内建默认快捷键
- 你在 `kitty.conf` 里显式定义的快捷键

常见配置项：

- `kitty_mod`：默认快捷键的修饰键别名
- `clear_all_shortcuts`：清除前面定义的快捷键
- `map`：绑定按键动作
- `action_alias`：给复杂动作起别名

你当前文件里保留了旧配置中的 active 快捷键，例如：

- 复制粘贴
- 从 selection 粘贴
- 滚动 scrollback
- 新建窗口 / 新建 OS 窗口
- 切换窗口
- 切换 tab
- 切换 layout
- 调整字体大小

## 原文件删除了什么

旧文件混合了几类内容：

- 你的实际配置
- 官方 sample config 的默认值
- 大段教程说明
- 注释掉的字体候选
- 注释掉的功能示例

现在 [kitty.conf](/home/ToaaM/repos/linux/dotfiles/config/kitty/kitty.conf) 已经把这些说明性内容移除了，只保留运行时真正需要的配置。

## 额外说明

在重新审查旧文件时，发现旧配置里还有两行看起来像配置、但其实并不会被 Kitty 识别：

- `TERM xterm-kitty`
- `COLORTERM truecolor`

用 Kitty 自己的解析器检查时，它会把这两行视为未知键并忽略，所以中文文档里也不把它们算作有效配置项。

## 推荐学习顺序

如果你想比较高效地学 Kitty 配置，建议按这个顺序看：

1. 字体
   `font_family`、`font_size`、`symbol_map`
2. 主题
   `include`、`foreground`、`background`、`color0..15`
3. 布局
   `window_padding_width`、`window_border_width`、`remember_window_size`
4. 标签
   `tab_bar_style`、`tab_title_template`
5. 工作流
   `shell_integration`、`clipboard_control`、`map`
6. 高级功能
   `allow_remote_control`、`watcher`、`startup_session`、`action_alias`

## 建议一起阅读的文件

- 当前配置: [kitty.conf](/home/ToaaM/repos/linux/dotfiles/config/kitty/kitty.conf)
- 基础颜色: [default-colors.conf](/home/ToaaM/repos/linux/dotfiles/config/kitty/default-colors.conf)
- 动态颜色: [colors.g.conf](/home/ToaaM/repos/linux/dotfiles/config/kitty/colors.g.conf)
