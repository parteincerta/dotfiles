-- Fuzzy search on top of Ripgrep's results
-- https://github.com/ibhagwan/fzf-lua

return {
	"ibhagwan/fzf-lua",
	lazy = true,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function ()
		local fzflua = require("fzf-lua")
		fzflua.setup({
			"default",
			-- "fzf-native",
			-- "max-perf",
			file_ignore_patterns = { "^%.git/", "%node_modules/" },
			fzf_opts = {
				["--ansi"] = "",
				["--border"] = "none",
				["--cycle"] = "",
				-- ["--delimiter"] = "[\\]:]",
				["--height"] = "100%",
				["--info"] = "inline",
				["--layout"] = "reverse",
				-- ["--nth"] = "2..",
				["--tiebreak"] = "chunk,length,begin",
				["--scrollbar"] = "▌▐",
			},
			grep = {
				multiprocess = true,
				git_icons = false,
				file_icons = false,
				color_icons = false,
				rg_opts = "--color=always --colors 'match:none' --column " ..
					"--glob '!{.git,node_modules}/' " ..
					"--glob '!{*.eot,*.svg,*.ttf,*.woff,*.woff2}' --hidden " ..
					"--line-number --max-columns=512 --no-heading --no-mmap " ..
					"--smart-case --sort-files --threads=3 --trim",
			},
			winopts = {
				preview = {
					default = "bat",
					delay = 350,
				},
			},
		})
	end
}