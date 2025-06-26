-- Jump anywhere.
-- https://github.com/smoka7/hop.nvim

return {
	"smoka7/hop.nvim",
	version = "v2.*",
	config = function ()
		require("hop").setup({
			case_insensitive = true,
			jump_on_sole_occurrence = true,
			multi_windows = true,
		})
	end,
}