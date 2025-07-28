return {
    -- Various Quality of Life plugins into one
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        cond = require("config.util").is_not_vscode(),
        opts = {
            bigfile = { enabled = false },
            dashboard = { enabled = false },
            explorer = { enabled = false },
            indent = { enabled = false },
            scope = { enabled = false },
            layout = { enabled = false },
            statuscolumn = { enabled = false },
            terminal = { enabled = false },
            win = { enabled = false },

            bufdelete = { enabled = true },
            git = { enabled = true },
            gitbrowse = {
                enabled = true,
                notify = true,
                url_patterns = {
                    ["git%.pratik%.live"] = {
                        branch = "/src/branch/{branch}",
                        file = "/src/branch/{branch}/{file}#L{line_start}-L{line_end}",
                        permalink = "/src/commit/{commit}/{file}#L{line_start}-L{line_end}",
                        commit = "/commit/{commit}",
                    },
                },
            },
            input = { enabled = true },
            image = {
                enabled = true,
                doc = {
                    max_width = 80,
                    max_height = 68,
                },
                img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments", ".artifacts/img", ".artifacts", ".assets" },
            },
            lazygit = { enabled = true, configure = true, win = { style = "lazygit" } },
            notifier = {
                enabled = true,
                timeout = 2000,
                style = "fancy",
            },
            picker = { enabled = true },
            quickfile = { enabled = true },
            scratch = {
                enabled = true,
                ft = "markdown",
                root = "~/Code/journal/scratch",
            },
            words = { enabled = true },
            zen = { enabled = true, toggles = { dim = true } },

            animate = {
                fps = 90,
                duration = { step = 10, total = 200 },
            },
            styles = {
                notification = { wo = { wrap = true } },
                scratch = { width = 120, height = 35 },
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
                desc = "LazyGit: List Git Log",
            },
            {
                "<leader>gL",
                function()
                    Snacks.git.blame_line(opts)
                end,
                desc = "Git: Line Log",
            },
            {
                "<leader>gf",
                function()
                    Snacks.lazygit.log_file(opts)
                end,
                desc = "Git: Show File Log",
            },
            {
                "<leader>gO",
                function()
                    Snacks.gitbrowse.open(opts)
                end,
                desc = "Git: Open the file on Browser",
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
                "<S-Esc>",
                function()
                    Snacks.zen()
                end,
                desc = "Toggle Zen Mode",
            },
        },
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
                { "<leader>a", group = "AI", icon = { icon = "󰚩", color = "orange" } },
                { "<leader>b", group = "Buffer Operations", icon = { icon = "󰲂", color = "orange" } },
                { "<leader>c", group = "Code", icon = { icon = "", color = "orange" } },
                { "<leader>d", group = "Diagnostics", icon = { icon = "🔬", color = "orange" } },
                { "<leader>D", group = "Debug", icon = { icon = "", color = "orange" } },
                { "<leader>g", group = "Git", icon = { icon = "", color = "orange" } },
                { "<leader>h", group = "Help", icon = { icon = "󰞋", color = "orange" } },
                { "<leader>n", group = "Neovim Things", icon = { icon = "", color = "orange" } },
                { "<leader>q", group = "Database", icon = { icon = "", color = "orange" } },
                { "<leader>s", group = "Search/Grep", icon = { icon = "", color = "orange" } },
                { "<leader>t", group = "Unit Test" },
                { "<leader>x", group = "Delete/Disable/Remove", icon = { icon = "", color = "orange" } },
                -- More icons: https://github.com/echasnovski/mini.icons/blob/main/lua/mini/icons.lua#L686
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
