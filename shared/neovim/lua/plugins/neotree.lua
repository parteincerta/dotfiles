-- Tree-like filesystem explorer
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "3.x",
	dependencies = {
		{ "MunifTanjim/nui.nvim", version = "v0.*" },
		{ "nvim-lua/plenary.nvim", tag = "v0.1.4" },
		{ "nvim-tree/nvim-web-devicons" },
	},
	config = function ()
		local nwi = require("nvim-web-devicons")
		local wp = require("window-picker")
		local nt = require("neo-tree")

		nwi.setup({
			color_icons = true,
			default = true,
			strict = true,
		})

		wp.setup({
			autoselect_one = true,
			include_current_win = false,
			show_prompt = false,
			use_winbar = "smart",
		})

		vim.g.neo_tree_remove_legacy_commands = 1
		nt.setup({
			close_if_last_window = true,
			enable_git_status = true,
			git_status_async = false,
			hide_root_node = true,
			popup_border_style = "rounded",
			use_default_mappings = false,
			buffers = {
				follow_current_file = {
					enabled = true,
				},
			},
			default_component_configs = {
				icon = {
					folder_closed = "",
					folder_empty = "",
					folder_open = "",
				},
				git_status = {
					symbols = {
						renamed = "󰁕",
						unstaged = "󰄱",
					}
				},
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				hijack_netrw_behavior = "open_default",
				use_libuv_file_watcher = true,
				filtered_items = {
					hide_dotfiles = false,
					never_show = { ".git" },
				}
			},
			source_selector = {
				winbar = false,
				statusline = false,
			},
			window = {
				auto_expand_width = true,
				position = "left",
				width = "15%",
				mappings = {
					["<2-LeftMouse>"] = "open_with_window_picker",
					["<ESC>"] = "clear_filter",
					["<C-c>"] = "revert_preview",
					["<S-r>"] = "refresh",

					["."] = "set_root",
					["ff"] = "fuzzy_finder",
					["fd"] = "fuzzy_finder_directory",

					["c"] = "copy",
					["d"] = "delete",
					["l"] = "focus_preview",
					["m"] = "move",
					["n"] = "add",
					["o"] = "open_with_window_picker",
					["P"] = { "toggle_preview", config = { use_float = true }},
					["q"] = "close_window",
					["r"] = "rename",
					["s"] = "split_with_window_picker",
					["t"] = "open_tabnew",
					["u"] = "close_node",
					["U"] = "navigate_up",
					["v"] = "vsplit_with_window_picker",

					["x"] = "cut_to_clipboard",     -- Mark to cut
					["y"] = "copy_to_clipboard",    -- Mark to copy
					["p"] = "paste_from_clipboard", -- Paste cut/copy marks
				},
				mapping_options = { noremap = true, nowait = true },
			},
		})
	end,
}