-- vim:nowrap

-- Helpful resources:
-- https://neovim.io/doc/user/lua-guide.html
-- https://neovim.io/doc/user/lua.html

local defaultOpts = {
	noremap = true, -- Don't remap recursively.
	silent = true,  -- Don't echo the map when it is triggered.
}

-- Clear any mappings for <Space> and set it as <Leader>.
vim.api.nvim_set_keymap("", "<SPACE>", "<NOP>", defaultOpts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Vim-only mappings: Toggles
vim.keymap.set("n", "<ESC>",
function ()
	if vim.o.hlsearch then
		vim.o.hlsearch = false

		local key = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
		vim.api.nvim_feedkeys(key, "n", true)

		print("Search highlight disabled.")
	else
		vim.o.hlsearch = true
	end
end, defaultOpts)

vim.keymap.set("n", "çc",
function ()
	if (vim.o.colorcolumn == "") then
		vim.opt.colorcolumn = "80,120,160"
	else vim.opt.colorcolumn = ""
	end
end, defaultOpts)

local listchars_default = vim.o.listchars
vim.keymap.set("n", "çl",
function ()
	if (vim.o.listchars == listchars_default) then
		vim.opt.listchars = "eol:¬,tab:› ,lead:·,trail:·"
	else vim.opt.listchars = listchars_default
	end
end, defaultOpts)

vim.api.nvim_set_keymap("n", "çd", ":Trouble diagnostics toggle<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "çi", ":IBLToggle<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "çm", ":MarkdownPreviewToggle<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "ço", ":SymbolsOutline<CR>", defaultOpts)

vim.keymap.set("n", "çs", function ()
	if vim.o.spell then
		vim.o.spell = false
		print("Spellchecker disabled.")
	else
		vim.o.spell = true
		print("Spellchecker enabled.")
	end
end, defaultOpts)

vim.keymap.set("n", "çw", function ()
	if vim.o.wrap then
		vim.o.wrap = false
		print("Line wrap disabled.")
	else
		vim.o.wrap = true
		print("Line wrap enabled.")
	end
end, defaultOpts)

-- Vim-only mappings: Edition
vim.api.nvim_set_keymap("v", "<", "<gv", defaultOpts) -- Preserve visual mode after indenting text.
vim.api.nvim_set_keymap("v", ">", ">gv", defaultOpts)
vim.api.nvim_set_keymap("x", "<", "<gv", defaultOpts)
vim.api.nvim_set_keymap("x", ">", ">gv", defaultOpts)
vim.api.nvim_set_keymap("v", "<S-j>", ":move .+2<CR>==gv=gv", defaultOpts) -- Move selected text down/up.
vim.api.nvim_set_keymap("v", "<S-k>", ":move .-2<CR>==gv=gv", defaultOpts)
vim.api.nvim_set_keymap("x", "<S-j>", ":move '>+1<CR>gv-gv=gv", defaultOpts)
vim.api.nvim_set_keymap("x", "<S-k>", ":move '<-2<CR>gv-gv=gv", defaultOpts)
vim.api.nvim_set_keymap("x", "P", "I<C-r>0<ESC>", defaultOpts) -- Paste before visual block.
vim.api.nvim_set_keymap("n", "<S-k>", "k<S-j>", defaultOpts)   -- Append to line above.
vim.api.nvim_set_keymap("n", "<S-u>", "<C-r>", defaultOpts)    -- Redo w/ <S-u> instead of <C-r>
vim.api.nvim_set_keymap("n", "<leader>rr", ":%s///gc<left><left><left><left>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>//gc<left><left><left>", { noremap = true })

-- Vim-only mappings: Navigation
vim.api.nvim_set_keymap("n", "<C-a>", ":wall<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "<C-c>", ":quit!<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "<C-q>", ":wall<CR>:quit<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "<C-s>", ":update<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "<C-x>", ":quitall!<CR>", defaultOpts)
vim.api.nvim_set_keymap("i", "<C-a>", "<ESC>:bufdo update<CR>i", defaultOpts)
vim.api.nvim_set_keymap("i", "<C-c>", "<ESC>:quit!<CR>", defaultOpts)
vim.api.nvim_set_keymap("i", "<C-q>", "<ESC>:wall<CR>:quit<CR>i", defaultOpts)
vim.api.nvim_set_keymap("i", "<C-s>", "<ESC>:update<CR>i", defaultOpts)
vim.api.nvim_set_keymap("i", "<C-x>", "<ESC>:quitall!<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "j", "v:count ? 'j' : 'gj'", { noremap = true, expr = true }) -- Treat line wraps as a distinct line.
vim.api.nvim_set_keymap("n", "k", "v:count ? 'k' : 'gk'",  { noremap = true, expr = true })
vim.api.nvim_set_keymap("n", "<leader>h", "<C-w>h", defaultOpts) -- Focus window left/bellow/above/right
vim.api.nvim_set_keymap("n", "<leader>j", "<C-w>j", defaultOpts)
vim.api.nvim_set_keymap("n", "<leader>k", "<C-w>k", defaultOpts)
vim.api.nvim_set_keymap("n", "<leader>l", "<C-w>l", defaultOpts)
vim.api.nvim_set_keymap("n", "tt", ":tabnew<CR>", defaultOpts)   -- Open new tab / current file on new tab.
vim.api.nvim_set_keymap("n", "te", ":tabnew %<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "th", ":tabfirst<CR>", defaultOpts) -- Go to first/previous/next/last/tab.
vim.api.nvim_set_keymap("n", "tj", ":tabprevious<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "tk", ":tabnext<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "tl", ":tablast<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "ts", ":tab split<CR>", defaultOpts)
for i = 1,9 do -- Go to n-th tab.
	local ith = tostring(i)
	local src = "t" .. ith
	local dst = ith .. "gt"
	vim.api.nvim_set_keymap("n", src, dst, defaultOpts)
end
vim.keymap.set("n", "<leader>mc", function ()
	vim.cmd([[delm! | delm A-Z0-9]])
end, defaultOpts)
	-- Improve default search behavior.
vim.keymap.set("n", "*", function ()
	vim.opt.hlsearch = true
	vim.cmd([[keepjumps normal! msHmt`s*`tzt`s]]) -- Highligh w/o moving
end, defaultOpts)

vim.keymap.set("n", "#", function ()
	vim.opt.hlsearch = true
	vim.cmd([[keepjumps normal! msHmt`s#`tzt`s]]) -- Highligh w/o moving
end, defaultOpts)

vim.keymap.set("n", "n", function ()
	vim.opt.hlsearch = true
	local key = vim.api.nvim_replace_termcodes("n", true, false, true)
	vim.api.nvim_feedkeys(key, "n", true)
end, defaultOpts)

vim.keymap.set("n", "N", function ()
	vim.opt.hlsearch = true
	local key = vim.api.nvim_replace_termcodes("N", true, false, true)
	vim.api.nvim_feedkeys(key, "n", true)
end, defaultOpts)

-- Plugins

	-- fzf-lua
		-- Fuzzy search open buffers.
vim.keymap.set("n", ",b", function ()
	local fzflua = require("fzf-lua")
	fzflua.buffers({ resume = false })
end, defaultOpts)
		-- Fuzzy search files in current the CWD.
vim.keymap.set("n", ",f", function ()
	local fzflua = require("fzf-lua")
	fzflua.files({ resume = false })
end, defaultOpts)
		-- Fuzzy search file history in the CWD.
vim.keymap.set("n", ",h", function ()
	local fzflua = require("fzf-lua")
	fzflua.oldfiles({
		cwd_only = true,
		include_current_session = true,
		stat = true
	})
end, defaultOpts)
		-- Fuzzy search current buffer content
vim.keymap.set("n", ",t", function ()
	local fzflua = require("fzf-lua")
	fzflua.blines({ resume = true })
end, defaultOpts)
		-- Fuzzy search content on all open buffers.
vim.keymap.set("n", ",T", function ()
	local fzflua = require("fzf-lua")
	fzflua.lines({ resume = true })
end, defaultOpts)
		-- Fuzzy search recursively all files' content in the CWD.
vim.keymap.set("n", ",a", function ()
	local fzflua = require("fzf-lua")
	fzflua.grep_project({ resume = true })
end, defaultOpts)

	-- Gitsigns
vim.api.nvim_create_autocmd("VimEnter", { callback = function ()
	vim.api.nvim_del_keymap("n", "[%")
	vim.api.nvim_del_keymap("n", "]%")
end })
vim.api.nvim_set_keymap("n", "[", ":Gitsigns prev_hunk navigation_message=false<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", "]", ":Gitsigns next_hunk navigation_message=false<CR>", defaultOpts)

	-- Hop
vim.api.nvim_set_keymap("n", "d,c", "d:HopChar1<CR>", defaultOpts)
vim.api.nvim_set_keymap("n", ",c", ":HopChar1<CR>", defaultOpts)
vim.api.nvim_set_keymap("v", ",c", "<cmd>HopChar1<CR>", defaultOpts)

	-- ToggleTerm
vim.api.nvim_set_keymap("n", "<C-t>", ":ToggleTerm direction=float<CR>", defaultOpts)
vim.api.nvim_set_keymap("t", "<C-t>", "<cmd>ToggleTerm direction=float<CR>", defaultOpts)

	-- Pick window to jump to.
vim.keymap.set("n", ",w", function ()
	local picker = require("window-picker")
	local window_id = picker.pick_window()
	if window_id ~= nil then
		vim.api.nvim_set_current_win(window_id)
	end
end, defaultOpts)

if os.getenv("IS_PAGER") == "yes" or
	os.getenv("IS_NOTES") == "yes" then
	vim.api.nvim_set_keymap("n", "q", ":q!<CR>", defaultOpts)
end