-- Bring up a throw-away shell in a floating window.
-- https://github.com/akinsho/toggleterm.nvim

return {
	"akinsho/toggleterm.nvim",
	version = "v2.*",
	config = function ()
		local tt = require("toggleterm")
		tt.setup({})
	end
}