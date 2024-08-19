-- Language parser with semantic capabilites.
-- https://github.com/nvim-treesitter/nvim-treesitter

return {{
	"nvim-treesitter/nvim-treesitter",
	tag = "v0.9.2",
	lazy = false,
	enabled = true,
	build = ":TSUpdate",
	config = function ()
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			sync_install = false,
			ensure_installed = { "diff", "git_rebase" },
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			incremental_selection = {
				enable = false
			},
			indent = {
				enable = true,
				disable = { "javascript" },
			},
		})
	end
}}