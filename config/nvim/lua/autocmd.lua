-- lua/autocmd.lua
vim.opt.sessionoptions = "buffers,curdir,folds,tabpages,winsize,cursor"

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local general = augroup("GeneralSettings", { clear = true })

-- auto save and load view state
autocmd({ "BufWinLeave", "BufLeave", "BufWritePost", "BufHidden", "QuitPre" }, {
	group = general,
	pattern = "?*",
	nested = true,
	callback = function()
		pcall(vim.api.nvim_command, "mkview!")
	end,
})

autocmd("BufWinEnter", {
	group = general,
	pattern = "?*",
	callback = function()
		pcall(vim.api.nvim_command, "loadview")
	end,
})

-- -- session
--
-- local function get_session_file()
--     local cwd = vim.fn.getcwd()
--     local safe = cwd:gsub("[^%w%-%.]", "_")
--     local dir = vim.fn.stdpath("data") .. "/sessions"
--     vim.fn.mkdir(dir, "p")
--     return dir .. "/" .. safe .. ".vim"
-- end
--
-- local function restore_session()
--     local file = get_session_file()
--     if vim.fn.filereadable(file) == 1 then
--         -- delete buffers
--         vim.cmd("%bd!")
--         pcall(vim.api.nvim_command, "source " .. file)
--     end
-- end
--
-- autocmd("VimEnter", {
--     group = augroup("SessionAuto", { clear = true }),
--     pattern = "*",
--     callback = function()
--         if vim.fn.argc() == 0 then
--             vim.schedule(restore_session)
--         end
--     end,
-- })
--
-- autocmd("VimLeavePre", {
--     group = augroup("SessionAuto", { clear = true }),
--     callback = function()
--         pcall(vim.api.nvim_command, "mksession! " .. get_session_file())
--     end,
-- })

-- theme
local theme_reload = augroup("ThemeReload", { clear = true })
autocmd("BufWritePost", {
	group = theme_reload,
	pattern = vim.fn.stdpath("config") .. "/lua/colors/g.lua",
	callback = function()
		package.loaded["colors.g"] = nil
		local theme_file = vim.fn.stdpath("config") .. "/lua/theme.lua"
		local ok, err = pcall(dofile, theme_file)
		if ok then
			vim.notify("✅ Theme reloaded!", vim.log.levels.INFO)
			vim.cmd("redraw!")
		else
			vim.notify("❌ Theme reload failed: " .. tostring(err), vim.log.levels.ERROR)
		end
	end,
})
