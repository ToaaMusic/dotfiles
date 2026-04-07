-- ~/.config/nvim/lua/floatterm.lua

local M = {}

M.term_buf = nil
M.term_win = nil
M.term_chan = nil

local float_width = 0.85
local float_height = 0.85

local function get_project_root()
    local root_markers = { ".git", "package.json", "Makefile", "pyproject.toml", "Cargo.toml" }
    local root = vim.fs.find(root_markers, { upward = true, path = vim.fn.expand("%:p:h") })[1]
    if root then
        return vim.fn.fnamemodify(root, ":h")
    end
    local current_file_dir = vim.fn.expand("%:p:h")
    return (current_file_dir ~= "" and current_file_dir) or vim.fn.getcwd()
end

function M.open()
    local root_path = get_project_root()

    -- has buffer
    if M.term_buf and vim.api.nvim_buf_is_valid(M.term_buf) then
        if not (M.term_win and vim.api.nvim_win_is_valid(M.term_win)) then
            local width = math.floor(vim.o.columns * float_width)
            local height = math.floor(vim.o.lines * float_height)
            M.term_win = vim.api.nvim_open_win(M.term_buf, true, {
                style = "minimal",
                relative = "editor",
                width = width,
                height = height,
                row = math.floor((vim.o.lines - height) / 2),
                col = math.floor((vim.o.columns - width) / 2),
                border = "rounded",
            })
        else
            vim.api.nvim_set_current_win(M.term_win)
        end

        vim.fn.chansend(M.term_chan, "cd " .. root_path .. " && clear\n")
        vim.cmd("startinsert")
        return M.term_chan
    end

    -- new buffer
    M.term_buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * float_width)
    local height = math.floor(vim.o.lines * float_height)

    M.term_win = vim.api.nvim_open_win(M.term_buf, true, {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        border = "rounded",
    })

    M.term_chan = vim.fn.termopen({ "zsh", "-i" }, {
        detach = 0,
        cwd = root_path
    })

    vim.cmd("startinsert")
    return M.term_chan
end

function M.toggle()
    if M.term_win and vim.api.nvim_win_is_valid(M.term_win) then
        vim.api.nvim_win_close(M.term_win, true)
        M.term_win = nil
    else
        M.open()
    end
end

function M.open_kitty()
    local root_path = get_project_root()
    vim.fn.jobstart({ "kitty", "--directory", root_path }, { detach = true })
end

vim.keymap.set("n", "t", M.toggle, { silent = true })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n><cmd>lua require('floatterm').toggle()<cr>]], { silent = true })
vim.keymap.set("n", "<C-t>", M.open_kitty, { silent = true })

return M
