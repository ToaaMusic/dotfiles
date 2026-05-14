# nvim 键位

## 原生

- <gx>: 跳转网址

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
- <Tab>: 接受 ai 补全

## conform.nvim

- <leader>f: 格式化
