-- vim:nowrap

vim.opt.expandtab = false  -- Don't replace tabs with spaces.
vim.opt.shiftwidth = 0     -- # of spaces for each indent level. Set to 0 to use tabstop's value.
vim.opt.smartindent = true -- Auto indent when curly braces or keywords are present.
vim.opt.smarttab = false   -- <BS> will always delete one space at a time.
vim.opt.tabstop = 4        -- A tab is represented by this many spaces.

vim.opt.colorcolumn = ""                        -- Disable colored column.
vim.opt.completeopt = { "menuone", "noselect" } -- Let the completion menu have a single item and don't autos-select it.
vim.opt.cmdheight = 0                           -- Hide command line when not in use.
vim.opt.cursorline = true                       -- Emphasize the cursor's current line.
vim.opt.fileencoding = "utf-8"                  -- Default file encoding.
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.foldcolumn = '1'
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.hlsearch = true                         -- Search highlighting enabled by default.
vim.opt.iskeyword:append("-")                   -- Consider these chars part of a word.
vim.opt.ignorecase = true                       -- Case-insensitive search.
vim.opt.laststatus = 3                          -- Show a single status line.
vim.opt.list = true                             -- Print invisible chars.
vim.opt.listchars = "tab:  ,trail:·"            -- How invisible chars should be represented.
vim.opt.mouse = "a"                             -- Mouse support available under all modes.
vim.opt.number = true                           -- Show line numbers.
vim.opt.relativenumber = true                   -- Show distance to other lines.
vim.opt.ruler = true                            -- Show current buffer position at the bottom right.
-- vim.opt.rulerformat = "%l,%c%V %p%%"         -- Position format. Disabled in favor of lualine.
vim.opt.scrolloff = 8                           -- Minimum number of lines to keep visible above/bellow the cursor.
vim.opt.sidescroll = 1                          -- Number of columns to scroll at a time.
vim.opt.sidescrolloff = 8                       -- Minimum number of columns to keep visible.
vim.opt.signcolumn = "yes"                      -- Always show the sign column to avoid shifting text when it show up.
vim.opt.shortmess:append("cI")                  -- Disable messages from completion results.
vim.opt.showbreak = "↳ "                        -- Representation of line break due to wrap.
vim.opt.smartcase = true                        -- Turn on case-sensitive search when capital letters are used.
vim.opt.spell = false                           -- Spellchecker disabled by default.
vim.opt.splitbelow = true                       -- Horizontal split goes bellow the current window.
vim.opt.splitright = true                       -- Vertical split goes to the right of the current window.
vim.opt.swapfile = false                        -- Disable swap file creation.
vim.opt.undofile = true                         -- Persist undo history.
vim.opt.whichwrap:append("h,l")                 -- Let these keys move cursor to the prev/next line.
vim.opt.wrap = false                            -- Wrap text.
