local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_path_cache = vim.fn.stdpath("cache") .. "/lazy/cache"
local lazy_path_plugins = vim.fn.stdpath("data") .. "/lazy"

-- Plugins to manually check for major version updates:
-- https://github.com/numToStr/Comment.nvim
-- https://github.com/lewis6991/gitsigns.nvim
-- https://github.com/lukas-reineke/indent-blankline.nvim
-- https://github.com/folke/lazy.nvim
-- https://github.com/L3MON4D3/LuaSnip
-- https://github.com/williamboman/mason.nvim
-- https://github.com/williamboman/mason-lspconfig.nvim
-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/dstein64/nvim-scrollview
-- https://github.com/nvim-treesitter/nvim-treesitter
-- https://github.com/kevinhwang91/nvim-ufo
-- https://github.com/s1n7ax/nvim-window-picker
-- https://github.com/stevearc/oil.nvim
-- https://github.com/akinsho/toggleterm.nvim
-- https://github.com/folke/tokyonight.nvim
-- https://github.com/folke/trouble.nvim

if not vim.loop.fs_stat(lazy_path)
then
	print("plugins: Installing lazy.nvim ...")
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazy_path
	})
	vim.notify("plugins: lazy.nvim successfully installed.")
end
vim.opt.rtp:prepend(lazy_path)

local lazy_opts = {
	root = lazy_path_plugins,
	change_detection = { enabled = false, notify = false },
	checker = { enabled = false },
	concurrency = 4,
	defaults = {
		lazy = false,
		version = "v11.*",
	},
	git = { timeout = 180 },
	install = { missing = true },
	performance = {
		cache = {
			enabled = true,
			path = lazy_path_cache,
		},
	},
	spec = {{ import = "plugins" }}
}

local ok, lazy = pcall(require, "lazy")
if ok then
	lazy.setup(lazy_opts)
else
	vim.notify("plugins: Failed to require lazy.nvim")
end
