-- Select and window to jump to.
-- https://github.com/s1n7ax/nvim-window-picker

return {
	"s1n7ax/nvim-window-picker",
	name = "window-picker",
	event = "VeryLazy",
	version = "v2.*",
	config = function ()
		local plenary = require("plenary")
		require("window-picker").setup({
			picker_config = {
				statusline_winbar_picker = {
					selection_display = function(char, window_id)
						local buffer_id = vim.api.nvim_win_get_buf(window_id)
						local abs_apth = plenary.path:new(vim.api.nvim_buf_get_name(buffer_id))
						local relative_path = abs_apth:make_relative()
						return "%=" .. char .. "%=" .. relative_path .. "%="
						-- return "%=" .. char .. "%=" .. "%f" .. "%="
					end,
				}
			},
			highlights = {
				statusline = {
					focused = {
						fg = vim.g.terminal_color_3,
						bg = vim.g.terminal_color_8,
					},
					unfocused = {
						fg = vim.g.terminal_color_3,
						bg = vim.g.terminal_color_8,
					},
				},
			},
		})
	end
}