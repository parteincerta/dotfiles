-- Put the cursor at the last known location when opening a file.
-- https://github.com/ethanholz/nvim-lastplace

return {
	"ethanholz/nvim-lastplace",
	config = function ()
		require("nvim-lastplace").setup({
			lastplace_ignore_buftype = {
				"quickfix", "nofile", "help"
			},
			lastplace_ignore_filetype = {
				"gitcommit", "gitrebase", "svn", "hgcommit"
			},
			lastplace_open_folds = true
		})
	end,
}
