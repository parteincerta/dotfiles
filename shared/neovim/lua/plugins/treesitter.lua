-- Language parser with semantic capabilites.
-- https://github.com/nvim-treesitter/nvim-treesitter

return {
	"nvim-treesitter/nvim-treesitter",
	tag = "v0.10.0",
	lazy = false,
	enabled = true,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			sync_install = false,
			ensure_installed = {
				"bash", "c", "cmake", "cpp", "diff", "dockerfile", "editorconfig",
				"fish", "git_config", "git_rebase", "gitattributes", "gitcommit",
				"gitignore", "gpg", "ini", "java", "javascript", "json", "json5",
				"jsonc", "lua", "make", "markdown", "markdown_inline", "nginx",
				"nix", "pem", "powershell", "python", "query", "readline", "sql",
				"ssh_config", "toml", "typescript", "vim", "vimdoc", "xml",
				"yaml", "zig",
			},
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
}
