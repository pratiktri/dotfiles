return {
    {
        "unblevable/quick-scope",
        init = function()
            vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }

            -- `:colorscheme` clears highlights, so set them on every colorscheme load
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = vim.api.nvim_create_augroup("quick_scope_colors", { clear = true }),
                callback = function()
                    vim.cmd([[
                      highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
                      highlight QuickScopeSecondary guifg='#00C7DF' gui=underline ctermfg=81 cterm=underline
                    ]])
                end,
            })
        end,
    },
}
