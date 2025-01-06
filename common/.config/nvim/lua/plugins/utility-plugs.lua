return {
    -- Various Quality of Life plugins into one
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        cond = require("config.util").is_not_vscode(),
        opts = {
            -- Want these but after they are fixed
            indent = {
                -- NOTE: highlights for blanklines are too noisy
                -- mini.indentscope does it much better
                enabled = false,
            },
            scope = {
                -- NOTE: mini.indentscope does this and indent guide as well
                enabled = false,
            },
            statuscolumn = {
                -- NOTE: just did not work
                enabled = false,
            },

            bigfile = {
                enabled = true,
                notify = true,
                size = 10 * 1024 * 1024, -- 10 MB
            },
            bufdelete = {
                enabled = true,
            },
            gitbrowse = {
                enabled = true,
            },
            input = {
                enabled = true,
            },
            lazygit = {
                enabled = true,
                configure = true,
                win = { style = "lazygit" },
            },
            notifier = {
                enabled = true,
                timeout = 2000,
                style = "fancy",
            },
            scroll = {
                enabled = false,
            },
            scratch = {
                enabled = true,
            },
            word = {
                enabled = true,
            },
            zen = {
                enabled = true,
            },

            animate = {
                fps = 60,
                duration = {
                    step = 10,
                    total = 200,
                },
            },
            styles = {
                notification = {
                    wo = {
                        wrap = true,
                    },
                },
            },
        },
        keys = {
            {
                "<leader>//",
                function()
                    Snacks.scratch()
                end,
                desc = "Toggle Scratch Buffer",
            },
            {
                "<leader>/s",
                function()
                    Snacks.scratch.select()
                end,
                desc = "Select Scratch Buffer",
            },
            {
                "<leader>gz",
                function()
                    Snacks.lazygit.open(opts)
                end,
                desc = "Git: Show LazyGit",
            },
            {
                "<leader>gl",
                function()
                    Snacks.lazygit.log(opts)
                end,
                desc = "Git: Log",
            },
            {
                "<leader>gf",
                function()
                    Snacks.lazygit.log_file(opts)
                end,
                desc = "Git: Show File Log",
            },
            {
                "]]",
                function()
                    Snacks.words.jump(vim.v.count1)
                end,
                desc = "Next Reference",
                mode = { "n", "t" },
            },
            {
                "[[",
                function()
                    Snacks.words.jump(-vim.v.count1)
                end,
                desc = "Prev Reference",
                mode = { "n", "t" },
            },
            {
                "<leader>xx",
                function()
                    Snacks.notifier.hide()
                end,
                desc = "Hide Notifications",
            },
            {
                "<leader>nn",
                function()
                    Snacks.notifier.show_history()
                end,
                desc = "Notification History",
            },
            {
                "<leader>z",
                function()
                    Snacks.zen()
                end,
                desc = "Toggle Zen Mode",
            },
            {
                "<leader>gO",
                function()
                    Snacks.gitbrowse.open(opts)
                end,
                desc = "Git: Open the file on Browser",
            },
        },
    },

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
            vim.g.rooter_patterns = { ".git" }
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
            delay = 450,
            preset = "helix",
            warning = true,
            -- Document existing key chains
            spec = {
                { "<leader>/", group = "NVIM Scratch Buffer" },
                { "<leader>a", group = "AI" },
                { "<leader>b", group = "Buffer Operations", icon = { icon = "", color = "orange" } },
                { "<leader>c", group = "Code", icon = { icon = "", color = "orange" } },
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
}
