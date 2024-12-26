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
            preset = "helix",
            warning = true,
            -- Document existing key chains
            spec = {
                { "<leader>a", group = "AI" },
                { "<leader>c", group = "Code", icon = { icon = "", color = "orange" } },
                { "<leader>b", group = "Buffer Operations", icon = { icon = "", color = "orange" } },
                { "<leader>d", group = "Diagnostics", icon = { icon = "", color = "orange" } },
                { "<leader>g", group = "Git", icon = { icon = "", color = "orange" } },
                { "<leader>h", group = "Help", icon = { icon = "󰞋", color = "orange" } },
                { "<leader>n", group = "Neovim Things", icon = { icon = "", color = "orange" } },
                { "<leader>q", group = "Database", icon = { icon = "", color = "orange" } },
                { "<leader>s", group = "Search/Grep", icon = { icon = "", color = "orange" } },
                { "<leader>t", group = "Unit Test" },
                { "<leader>x", group = "Delete/Disable/Remove", icon = { icon = "", color = "orange" } },
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
        "epwalsh/obsidian.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cond = require("config.util").is_not_vscode(),
        ft = "markdown",
        opts = {
            workspaces = {
                { name = "personal", path = "~/Code/Notes" },
            },
            completion = {
                nvim_cmp = true,
            },
        },
    },
}
