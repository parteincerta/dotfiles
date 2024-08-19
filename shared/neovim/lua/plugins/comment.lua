-- Comments support.
-- https://github.com/numToStr/Comment.nvim

return {
	"numToStr/Comment.nvim",
	lazy = false,
	config = function ()
		local comment = require("Comment")
		comment.setup({
			ignore = "^$",
			mappings = { basic = true, extra = true },
			opleader = {
				block = "<leader>cb",
				line = "<leader>cl",
			},
			toggler = {
				block = "<leader>cb",
				line = "<leader>cl",
			},
			extra = {
				above = "<leader>cO",
				below = "<leader>co",
				eol = "<leader>cA",
			},
		})
	end,
}
