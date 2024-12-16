return {
    -- Navigate between NVIM & Tmux splits seamlessly
    {
        "christoomey/vim-tmux-navigator",
        cond = require("config.util").is_not_vscode(),
    },

    -- Navigate between NVIM & kitty splits
    {
        "knubie/vim-kitty-navigator",
        cond = require("config.util").is_not_vscode(),
        build = "cp ./*.py ~/.config/kitty/",
        keys = {
            { "<C-S-h>", "<cmd>KittyNavigateLeft<cr>" },
            { "<C-S-j>", "<cmd>KittyNavigateDown<cr>" },
            { "<C-S-k>", "<cmd>KittyNavigateUp<cr>" },
            { "<C-S-l>", "<cmd>KittyNavigateRight<cr>" },
        },
    },

    -- Open Kitty terminal scrollback as buffer
    {
        "mikesmithgh/kitty-scrollback.nvim",
        lazy = true,
        cond = require("config.util").is_not_vscode(),
        cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
        event = { "User KittyScrollbackLaunch" },
        version = "^4.0.0",
        opts = {
            status_window = {
                icons = { nvim = "" },
            },
        },
        config = function()
            require("kitty-scrollback").setup()
        end,
    },

    -- Changes the Nvim root to git root
    {
        "airblade/vim-rooter",
        cond = require("config.util").is_not_vscode(),
        config = function()
            vim.g.rooter_cd_cmd = "tcd" -- Use tcd command to change the root
        end,
    },

    -- Display undotree
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree panel" },
        },
    },

    {
        "folke/which-key.nvim",
        cond = require("config.util").is_not_vscode(),
        dependencies = {
            "echasnovski/mini.icons",
        },
        opts = {
            -- Document existing key chains
            spec = {
                { "<leader>c", group = "Code" },
                { "<leader>b", group = "Buffer Operations" },
                { "<leader>d", group = "Diagnostics" },
                { "<leader>f", group = "File Operations" },
                { "<leader>g", group = "Git" },
                { "<leader>f", group = "Find and List Things" },
                { "<leader>h", group = "Help" },
                { "<leader>n", group = "NVIM Things" },
                { "<leader>q", group = "Database" },
                { "<leader>s", group = "Search/Grep Things" },
                { "<leader>t", group = "Unit Test Operations" },
                { "<leader>x", group = "Delete/Remove Something" },
            },
        },
    },

    -- Session management. Saves your session in the background
    -- TIP: autocmd to autoload sessions at: ../config/autocmd.lua
    {
        "folke/persistence.nvim",
        cond = require("config.util").is_not_vscode(),
        event = "BufReadPre",
        opts = {
            -- Session files stored at: ~/.config/nvim/sessions/
            dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
        },
    },

    -- Speedup loading large files by disabling some plugins
    {
        "LunarVim/bigfile.nvim",
        cond = require("config.util").is_not_vscode(),
        lazy = true,
        opts = {
            filesize = 2, --2MiB
            pattern = "*",
            features = {
                "indent_blankline",
                "lsp",
                "syntax",
                "treesitter",
            },
        },
    },

    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
}
