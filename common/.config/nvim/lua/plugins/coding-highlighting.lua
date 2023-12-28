return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local tree_config = require("nvim-treesitter.configs")
            tree_config.setup({
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = "<C-CR>",
                        node_decremental = "<bs>",
                    }
                }
            })
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup({})
        end
    },
    -- { "windwp/nvim-autopairs" },
    -- {
    --     "akinsho/toggleterm.nvim",
    --     version = "*",
    --     config = function ()
    --         require("toggleterm").setup({})
    --     end
    -- },
}


