return {
    { "tpope/vim-repeat" },
    { "tpope/vim-surround" },
    { "easymotion/vim-easymotion" },
    { "machakann/vim-highlightedyank" },

    -- "gc" to comment visual regions/lines
    { "numToStr/Comment.nvim",        opts = {} },

    -- auto pairs
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        opts = {},
    },

    -- indent guides for Neovim
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            indent = { char = "│", tab_char = "│", },
            scope = { enabled = false },
            exclude = {
                filetypes = {
                    "help", "alpha", "dashboard", "neo-tree",
                    "Trouble", "trouble", "lazy", "mason",
                    "notify", "toggleterm", "lazyterm",
                },
            },
        },
        main = "ibl",
    },

    -- Highlights the current level of indentation, and animates the highlighting.
    {
        "echasnovski/mini.indentscope",
        opts = { symbol = "│", options = { try_as_border = true }, },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help", "neo-tree", "Trouble", "trouble",
                    "lazy", "mason", "notify", "toggleterm",
                    "lazyterm",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    -- Finds and lists all of the TODO, HACK, BUG, etc comment
    {
        "folke/todo-comments.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
        opts = {
            keywords = {
                HACK = { alt = { "TIP" } },
            },
        },
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },

            -- TODO: Find better keymaps for below
            -- { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
            -- { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
            -- { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
            -- { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
        },
    },
}
