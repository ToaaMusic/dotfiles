local function get_user_name()
	return os.getenv("USER") or os.getenv("USERNAME") or "user"
end

---@param scheme tdf.ColorScheme
---@return string
return function(scheme)
	local tpl = [[
[mgr]
cwd            = { fg = "%s" }
symlink_target = { fg = "%s", italic = true }
border_style   = { fg = "%s" }
# border_symbol = " "

[tabs]
active   = { fg = "%s", bg = "%s", bold = true }
inactive = { fg = "%s", bg = "%s" }

[filetype]
rules = [
	{ mime = "**/image/*", fg = "yellow" },
	{ mime = "**/{audio,video}/*", fg = "magenta" },
	{ mime = "**/application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", fg = "red" },
	{ mime = "**/application/{pdf,doc,rtf}", fg = "cyan" },
	{ mime = "vfs/{absent,stale}", fg = "gray" },
	{ url = "*", is = "orphan", fg = "red" },
	{ url = "*", is = "exec"  , fg = "green" },
	{ url = "*", is = "dummy", bg = "red" },
	{ url = "*/", is = "dummy", bg = "red" },
	{ url = "*/", fg = "%s" }
]

[icon]
prepend_dirs = [
	{ name = ".config", text = "", fg = "%s" },
	{ name = ".local", text = "", fg = "%s" },
	{ name = ".cache", text = "", fg = "%s" },
	{ name = "go", text = "󰟓", fg = "%s" },
	{ name = ".cargo", text = "", fg = "%s" },
	{ name = ".rustup", text = "", fg = "%s" },
	{ name = ".dotnet", text = "󰌛", fg = "%s" },
	{ name = ".nuget", text = "󰌛", fg = "%s" },
	{ name = ".npm", text = "", fg = "%s" },
	{ name = ".java", text = "", fg = "%s" },
	{ name = ".agents", text = "󱚝", fg = "%s" },
	{ name = ".dsh", text = "󱚝", fg = "%s" }, # 🐳
	{ name = ".ssh", text = "󰖟", fg = "%s" },
	{ name = ".minecraft", text = "󰆧", fg = "%s" },
	{ name = ".steam", text = "󰓓", fg = "%s" },
	{ name = ".wine", text = "⊞", fg = "%s" },
	{ name = ".android", text = "󰀲", fg = "%s" },
	{ name = ".mozilla", text = "󰈹", fg = "%s" },

	{ name = "%s", text = "", fg = "%s" },

	{ name = "game", text = "󰊴", fg = "%s" },

	{ name = "dotfiles", text = "", fg = "%s" },
]

prepend_conds = [
	{ if = "orphan", text = "", fg = "red" },
	{ if = "link", text = "", fg = "%s" },
	{ if = "dir", text = "", fg = "%s" },
	{ if = "!dir", text = "", fg = "%s" },
]
]]

	local content = tpl:format(
		scheme.brand,
		scheme.syntax.comment,
		scheme.bg.border,
		scheme.bg.common,
		scheme.brand,
		scheme.fg.common,
		scheme.bg.elevated,
		scheme.brand,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		get_user_name(),
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.syntax.keyword,
		scheme.brand,
		scheme.fg.common
	)

	return content
end
