-- Ultra fold in Neovim
-- https://github.com/kevinhwang91/nvim-ufo

local handler = function (virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = (' 󰁂 %d '):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, {chunkText, hlGroup})
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, {suffix, 'MoreMsg'})
	return newVirtText
end

return {
	'kevinhwang91/nvim-ufo',
	enabled = os.getenv('IS_PAGER') ~= 'yes',
	version = "v1.*",
	dependencies = {{
		'kevinhwang91/promise-async',
		enabled = true,
		version = "v1.*",
	},{
		'luukvbaal/statuscol.nvim',
		enabled = true,
		config = function()
			local statuscol = require("statuscol")
			local builtin = require("statuscol.builtin")
			statuscol.setup({
				relculright = true,
				segments = {
					{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
					{ text = { "%s" }, click = "v:lua.ScSa" },
					{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
				},
			})
		end,
	}},
	config = function ()
		local ufo = require('ufo')
		ufo.setup({
			fold_virt_text_handler = handler,
			provider_selector = function (bufnr, filetype, buftype)
				return {'treesitter', 'indent'}
			end
		})
	end
}
