-- Interactive vertical scrollbars and signs.
-- https://github.com/dstein64/nvim-scrollview

return {
	'dstein64/nvim-scrollview',
	enabled = true,
	version = "v5.*",
	config = function ()
		local scrollview = require('scrollview')
		scrollview.setup({
			base = 'right',
			current_only = true,
			diagnostics_severities = {vim.diagnostic.severity.ERROR},
			excluded_filetypes = {'neo-tree', 'fzf-lua'},
			floating_windows = false,
			signs_on_startup = {'cursor', 'diagnostics', 'search'},
			winblend = 20,
		})
	end
}