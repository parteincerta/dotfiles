-- Automatic completion.
-- https://github.com/hrsh7th/nvim-cmp
-- https://github.com/hrsh7th/cmp-buffer
-- https://github.com/hrsh7th/cmp-nvim-lua
-- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help
-- https://github.com/hrsh7th/cmp-path
-- https://github.com/L3MON4D3/LuaSnip
-- https://github.com/onsails/lspkind.nvim
-- https://github.com/rafamadriz/friendly-snippets
-- https://github.com/saadparwaiz1/cmp_luasnip

return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-nvim-lua" },
		{ "hrsh7th/cmp-nvim-lsp-signature-help" },
		{ "hrsh7th/cmp-path" },
		{ "onsails/lspkind.nvim" },
		{
			"saadparwaiz1/cmp_luasnip",
			lazy = true,
			dependencies = {
				"L3MON4D3/LuaSnip",
				lazy = true,
				build = "make install_jsregexp",
				version = "v2.*",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function ()
					local luasnip_vscode = require("luasnip.loaders.from_vscode")
					luasnip_vscode.lazy_load()
				end
			},
		},
	},
	config = function ()
		local cmp = require("cmp")
		local lspkind = require("lspkind")
		local luasnip = require("luasnip")

		cmp.setup({
			preselect = cmp.PreselectMode.None,
			experimental = {
				ghost_text = true,
			},
			-- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
			formatting = {
				format = lspkind.cmp_format({
					mode = 'symbol_text',
					maxwidth = 50,
					ellipsis_char = '...',
				}),
			},
			mapping = cmp.mapping.preset.insert({
				["<Tab>"] = function (fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expandable() then
						luasnip.expand()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else fallback()
					end
				end,
				["<S-Tab>"] = function (fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else fallback()
					end
				end,
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-y>'] = cmp.config.disable,
				['<C-Space>'] = cmp.mapping.complete(),
				['<ESC>'] = cmp.mapping(function ()
					cmp.confirm()
					-- Go back to normal mode.
					local key = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
					vim.api.nvim_feedkeys(key, "n", true)
				end),
				['<CR>'] = cmp.mapping.confirm({ select = true }),
			}),
			snippet = {
				expand = function (args)
					luasnip.lsp_expand(args.body)
				end
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp_signature_help" },
				{ name = "path" },
				{
					name = "luasnip",
					priority = 2,
				},
				{
					name = "nvim_lsp",
					priority = 3,
				},
				{
					name = "nvim_lua",
					priority = 3,
				},
				{
					name = "buffer",
					priority = 1,
					option = {
						-- Buffer completions are sourced from all
						-- visible buffers.
						get_bufnrs = function ()
							local buffers = {}
							for _, v in ipairs(vim.api.nvim_list_wins()) do
								buffers[vim.api.nvim_win_get_buf(v)] = true
							end
							return vim.tbl_keys(buffers)
						end
					},
				},
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			}
		})
	end
}