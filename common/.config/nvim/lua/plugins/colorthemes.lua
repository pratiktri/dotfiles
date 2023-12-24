return {
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        priority = 1000,
        lazy = false,
        config = function()
            vim.cmd.colorscheme "kanagawa-wave"
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        -- config = function()
        --     show_end_of_buffer = true,
        --     integrations = {
        --         cmp = true,
        --         gitsigns = true,
        --         nvimtree = true,
        --     },
        --     vim.cmd.colorscheme "catppuccin-macchiato",
        -- end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
    },
}
