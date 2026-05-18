# nvim 键位

部分见 [keymaps.lua](./lua/keymaps.lua)

- <leader>: Space

## 频率最高

- 

## 自定义

- jk: INSERT 模式下对应 <Esc>

## 原生

- u/ctrl-r: undo/redo

- ctrl-e/ctrl-y: 上下滚动一行
- ctrl-d/ctrl-u: 上下滚动半页
- ctrl-f/ctrl-b: 上下滚动一页
- zz/zt/zb: 将当前行置中/置顶/置底

- ctrl-a/ctrl-x: 数字加减

- ctrl-w: 窗口管理
  - ctrl-w h/j/k/l: 切换窗口
  - ctrl-w v: 垂直分屏
  - ctrl-w s: 水平分屏
  - ctrl-w q: 关闭窗口
  - ctrl-w o: 只保留当前窗口（其他全关）

- gi: 跳转到上次编辑地方并进入插入模式
- gf: 跳转到文件
- gx: 跳转网址

### lsp

- K: 悬停文档
- gd: 跳转定义 (:noh 取消高亮)
- grr: 查看所有引用
- grn: 重命名

- za:折叠/展开代码块

## blink.cmp (default)

- <C-space>：显示补全菜单（show）
- <C-e>：隐藏补全菜单（hide）
- <C-y>：接受当前选中的补全项（select_and_accept）
- <CR>（回车）：不接受补全，直接换行（fallback 到 Neovim 原生行为）
- <Tab>：如果在 snippet 里就前进，否则尝试接受补全 + snippet_forward
- <S-Tab>：snippet 后退
- <C-n> / <Down>：选择下一个补全项
- <C-p> / <Up>：选择上一个补全项
- <C-b> / <C-f>：上下滚动文档窗口
- <C-k>：切换 signature help（函数签名提示）

## minuet-ai.nvim

- <C-l>: next 或者触发 ai 补全
- <C-h>: prev
- <C-Tab>: 接受 ai 补全

## comment

- gcc: 注释一行
- gc: 注释选中

## gitsigns.nvim

- <leader>gp: preview hunk
- ]g: 下一条改动
- [g: 上一条改动


## conform

- <leader>f: 格式化

