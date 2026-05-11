-- https://github.com/keaising/im-select.nvim
return {
	"keaising/im-select.nvim",
	config = function()
		require("im_select").setup({
			default_im_select = "keyboard-us",
			-- default_command = "fcitx5-remote"
		})
	end,
}
