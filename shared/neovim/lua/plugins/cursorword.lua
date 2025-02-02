-- Highlight word under the cursor.
-- https://github.com/tzachar/local-highlight.nvim

return {
	'tzachar/local-highlight.nvim',
	config = function()
		local lh = require('local-highlight')
		lh.setup({
			cw_hlgroup =  'LocalHighlight',
			hlgroup = 'LocalHighlight',
			insert_mode = false,
			min_match_len = 3,
			max_match_len = 64,
			highlight_single_match = false,
		})

		vim.cmd.set('updatetime=60')
	end
}