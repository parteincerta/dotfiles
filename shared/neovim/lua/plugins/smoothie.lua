-- Smooth scroll.
-- https://github.com/psliwka/vim-smoothie

return {
	"psliwka/vim-smoothie",
	init = function ()
		vim.g.smoothie_speed_constant_factor = 45
	end,
}
