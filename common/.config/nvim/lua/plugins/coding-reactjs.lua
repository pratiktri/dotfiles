return {
    -- Automatically add closing tags for HTML and JSX
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },

    -- Intelligent commenting on JSX
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
            options = {
                enable_autocmd = false,
            },
        },
        config = function()
            vim.g.skip_ts_context_commentstring_module = true
        end,
    },

    -- Highlight colors
    {
        "brenoprata10/nvim-highlight-colors",
        setup = {
            enable_tailwind = true,
        },
        config = function()
            require("nvim-highlight-colors").setup()
        end,
    },
}
