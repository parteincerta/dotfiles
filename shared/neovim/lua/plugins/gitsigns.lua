-- Highligh changes in files under Git's version control.
-- https://github.com/lewis6991/gitsigns.nvim

return {
	"lewis6991/gitsigns.nvim",
	version = "v0.*",
	config = function ()
		local gitsigns = require("gitsigns")
		gitsigns.setup({
			attach_to_untracked = false,
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "▎" },
				topdelete = { text = "▎" },
				changedelete = { text = "▎" },
			},
		})
	end
}