local w = vim.uv.new_fs_event()
local colors_path = vim.fn.stdpath("config") .. "/lua/colors/g.lua"
local theme_file = vim.fn.stdpath("config") .. "/lua/theme.lua"
local last_event = 0

local function reload_theme()
	package.loaded["colors.g"] = nil
	local ok, err = pcall(dofile, theme_file)
	if ok then
		vim.notify("🎨 Theme reloaded!", vim.log.levels.INFO)
		vim.cmd("redraw!")
	else
		vim.notify("❌ Error: " .. tostring(err), vim.log.levels.ERROR)
	end
end

local function on_change(err, fname, status)
	local now = vim.loop.hrtime() / 1e6 -- ms
	if now - last_event < 100 then
		return
	end
	last_event = now

	reload_theme()
	if not w then
		return
	end
	w:stop()
	w:start(vim.fn.fnamemodify(colors_path, ":p"), {}, vim.schedule_wrap(on_change))
end

if not w then
	return
end
w:start(vim.fn.fnamemodify(colors_path, ":p"), {}, vim.schedule_wrap(on_change))
vim.api.nvim_create_user_command("ReloadTheme", reload_theme, {})
vim.notify("👁️ Watching colors file for changes", vim.log.levels.INFO)
