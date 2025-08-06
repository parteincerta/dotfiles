-- Language Server Protocol integration
-- https://github.com/hrsh7th/cmp-nvim-lsp
-- https://github.com/mason-org/mason.nvim
-- https://github.com/mason-org/mason-lspconfig.nvim
-- https://github.com/neovim/nvim-lspconfig

local _enabled = true
if os.getenv("IS_PAGER") == "yes" or os.getenv("IS_NOTES") == "yes" then
	_enabled = false
end

return {
	"mason-org/mason.nvim",
	enabled = _enabled,
	version = "v2.*",
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		-- List of all Mason packages
		-- https://mason-registry.dev/registry/list
		mason.setup({})

		-- List of all LSP servers and their default server_configurations:
		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
		local lsp_servers_list = {
			"bashls",
			"clangd",
			"jsonls",
			"lua_ls",
			-- "ols",
			"pyright",
			"ts_ls",
			-- "zls",
		}
		if os.getenv("JAVA_HOME") ~= nil then
			table.insert(lsp_servers_list, "jdtls")
		end
		mason_lspconfig.setup({
			automatic_installation = false,
			ensure_installed = lsp_servers_list
		})

		local lspconfig = require("lspconfig")
		local cmp = require("cmp_nvim_lsp")
		local cmp_caps = cmp.default_capabilities()

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#bashls
		local lspconfig_bash = {
			capabilities = cmp_caps,
			cmd = { 'bash-language-server', 'start' },
		}
		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#clangd
		local lspconfig_clangd = {
			capabilities = cmp_caps,
			cmd = { "clangd" },
		}
		--[[ if vim.loop.os_uname().sysname == "Darwin" then
			-- Use this instance of clangd for macOS instead of
			-- /usr/bin/clangd, because it properly detects macros
			-- related with target architecture: __amd64__, __aarch64__, ...
			lspconfig_clangd.cmd = {
				"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clangd",
			}
		end ]]

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#jdtls
		local lspconfig_jdtls = {
			capabilities = cmp_caps,
			cmd = { "jdtls" },
		}

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#jsonls
		local lspconfig_jsonls = {
			capabilities = vim.lsp.protocol.make_client_capabilities()
		}
		lspconfig_jsonls.capabilities.textDocument.completion.completionItem.snippetSupport = true;

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
		local lspconfig_lua = {
			capabilities = cmp_caps,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					telemetry = { enable = false },
				}
			}
		}

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ols
		local lspconfig_ols = { capabilities = cmp_caps }

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#pyright
		local lspconfig_python = { capabilities = cmp_caps }

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ts_ls
		local lspconfig_tsls = {
			capabilities = cmp_caps,
			init_options = { hostInfo = "neovim" },
			root_dir = function()
				-- See :help lspconfig-root-dir for other possibilities
				return vim.fn.getcwd()
			end,
			settings = { diagnostics = { ignoredCodes = { 7016, 80001, 80006 } } }
		}

		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#zls
		local lspconfig_zls = { capabilities = cmp_caps }

		if lspconfig.bashls then
			lspconfig.bashls.setup(lspconfig_bash)
		end
		if lspconfig.clangd then
			lspconfig.clangd.setup(lspconfig_clangd)
		end
		if lspconfig.jdtls then
			lspconfig.jdtls.setup(lspconfig_jdtls)
		end
		if lspconfig.jsonls then
			lspconfig.jsonls.setup(lspconfig_jsonls)
		end
		if lspconfig.lua_ls then
			lspconfig.lua_ls.setup(lspconfig_lua)
		end
		if lspconfig.ols then
			lspconfig.ols.setup(lspconfig_ols)
		end
		if lspconfig.pyright then
			lspconfig.pyright.setup(lspconfig_python)
		end
		if lspconfig.ts_ls then
			lspconfig.ts_ls.setup(lspconfig_tsls)
		end
		if lspconfig.zls then
			lspconfig.zls.setup(lspconfig_zls)
		end
	end,
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp" },
		{
			"neovim/nvim-lspconfig",
			version = "v2.*",
			config = function()
				vim.diagnostic.config({
					virtual_text = false,
					signs = true,
					underline = true,
					update_in_insert = true
				})

				local lsp_diagnostics_signs = {
					Error = "󰩏",
					Warn = "",
					Hint = "󰌵",
					Info = ""
				}
				for d_type, d_icon in pairs(lsp_diagnostics_signs) do
					local hl = "DiagnosticSign" .. d_type
					vim.fn.sign_define(hl, { text = d_icon, texthl = hl, numhl = hl })
				end
			end,
		},
		{
			"mason-org/mason-lspconfig.nvim",
			version = "v2.*",
		}
	}
}
