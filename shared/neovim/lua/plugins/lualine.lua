-- Statusline plugin
-- https://github.com/nvim-lualine/lualine.nvim

local _enabled = true
if os.getenv("IS_PAGER") == "yes" or
	os.getenv("IS_NOTES") == "yes" then
	_enabled = false
	vim.o.laststatus = 0
end

return {
	"nvim-lualine/lualine.nvim",
	enabled = _enabled,
	config = function ()
		local lualine = require("lualine")
		lualine.setup({
			options = {
				theme = "tokyonight",
				disabled_filetypes = {
					statusline = { "neo-tree" }
				},
				ignore_focus = { "neo-tree" },
				section_separators = {left = '', right = ''},
			},
			sections = {
				lualine_a = {'mode'},
				lualine_b = {'branch', 'diff', 'diagnostics'},
				lualine_c = {{ 'filename', path = 4 }},
				-- lualine_x = {'encoding', 'fileformat', 'filetype'},
				lualine_x = {'filetype'},
				lualine_y = {'location', 'selectioncount'},
				lualine_z = {'progress'}
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {{ 'filename', path = 4 }},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end
}
