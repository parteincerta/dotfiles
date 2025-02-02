-- Identation guides with colored lines.
-- https://github.com/lukas-reineke/indent-blankline.nvim

return {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    main = "ibl",
    version = "3.*",
    config = function ()
        if os.getenv("COLORTERM") ~= "truecolor" then
            return
        end

        vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })

        local highlight = {
            "RainbowDelimiterRed",
            "RainbowDelimiterYellow",
            "RainbowDelimiterBlue",
            "RainbowDelimiterOrange",
            "RainbowDelimiterGreen",
            "RainbowDelimiterViolet",
            "RainbowDelimiterCyan",
        }
        vim.g.rainbow_delimiters = { highlight = highlight }

        local hooks = require('ibl.hooks')
        hooks.register(
            hooks.type.SCOPE_HIGHLIGHT,
            hooks.builtin.scope_highlight_from_extmark
        )

        local ibl = require("ibl");
        ibl.setup({
            enabled = true,
            indent = {
                char = " ",
                tab_char = " ",
            },
            scope = {
                enabled = true;
                char = "│",
                show_start = false,
                show_end = false,
                highlight = highlight,
            },
        })
    end,
}
