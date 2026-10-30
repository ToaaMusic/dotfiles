# nvim shortcuts

See custom part: [keymaps.lua](./lua/keymaps.lua)

leader: Space

## custom

- jk: exit insert mode
- <leader>rn: rename
- <leader>cl: toggle codelens
- <leader>cL: run codelens
- <leader>ca: code action
- <leader>hi: toggle inlay hint

## plugins

### blink.cmp

- CTRL-Space：show
- CTRL-e：reject or hide
- CTRL-y：accept

### minuet-ai.nvim

- CTRL-l: next or request ai completion
- CTRL-h: prev
- CTRL-y: accept

### comment

- gcc: toggle comment this line
- gc: toggle comment in visual mode

### gitsigns.nvim

- <leader>gp: preview hunk
- ]g: next hunk
- [g: prev hunk

### conform

- <leader>f: run format

## default I often use

### change mode

- CTRL-v: change to blockwise Visual mode
- v: visual mode
- i: insert
- I: insert at the beginning of the line N times
- a: append
- A: append at the end of the line N times
- o: new line below then insert
- O: new line above then insert

### scroll or move cursor (normal)

- CTRL-b: scroll Backwords N page
- CTRL-f: scroll Forward N page
- CTRL-d: scroll Down N line (default half page)
- CTRL-u: scroll Up N line (default half page)

- <CR>: next N line

- $: next N end of line (default current line)
- 0: move to the head of line
- ^: move to first char of the line

- %: move to next bracket on this line

- N%: go to N% in the file

- ): N sentences forward
- (: N sentences backward
- }: N paragraphs forward
- {: N paragraphs backward
- ]]: N sections forward, at start of section
- [[: N sections backward, at start of section
- [#: N times back to unclosed "#if" or "#else"
- ]#: N times forward to unclosed "#else" or "#endif"

- G: line N (default: the last one)
- gg: line N (default: 1)

- gm: middle of the screen line
- gM: middle of the line
- |: column N of the line (default 1)

- gd: local declaration of identifier
- gD: global declaration of identifier

- w: N words forward
- b: N words backward
- e: forward to the end of the Nth word
- ge: backward to the end of the Nth word

### edit (normal)

- .: repeat last motion

- CTRL-a: increment number
- CTRL-x: decrement number

- x: delete N char
- d: delete
- dd: delete N lines
- D: delete to the end of the line and N-1 more lines
- r: replace
- c: change
- C: change to the end of the line and N-1 more lines

- y: yank (into a register, cmd :reg to show)
- yy: yank N lines
- p: put

- u: undo
- CTRL-r: redo

### search

- /: (format: /{pattern}[/[offset]]<CR>) search forward for the Nth occurrence of {pattern}
- ?: (format: ?{pattern}[?[offset]]<CR>) search backward for the Nth occurrence of {pattern}
- n: repeat last search
- N: repeat last search, in opposite direction

### lsp

- K: doc
- gd: go to defination (:noh no highlight)
- grr: go to references
- grn: rename

### fold

- za: toggle
- zR: open all folds
- zM: close all folds

- zj: move to the next fold
- zk: move to the previous fold
