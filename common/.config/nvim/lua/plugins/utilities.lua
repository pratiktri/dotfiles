return {
    -- Don't measure startuptime
    { "dstein64/vim-startuptime", enabled = false },

    -- Session management.
    {
        "folke/persistence.nvim",
        opts = {
            dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
        },
    },
}
