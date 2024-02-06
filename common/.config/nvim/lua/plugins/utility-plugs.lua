return {
    -- Navigate between NVIM & Tmux splits seamlessly
    { "christoomey/vim-tmux-navigator" },

    -- Navigate between NVIM & kitty splits seamlessly
    {
        "knubie/vim-kitty-navigator",
        build = "cp ./*.py ~/.config/kitty/",
    },

    -- Open Kitty terminal scrollback as buffer
    {
        "mikesmithgh/kitty-scrollback.nvim",
        lazy = true,
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

    {
        "folke/which-key.nvim",
        config = function()
            -- document existing key chains
            require("which-key").register({
                ["<leader>e"] = { name = "[E]xplorer", _ = "which_key_ignore" },
                ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
                ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
                ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
            })
            -- register which-key VISUAL mode
            -- required for visual <leader>hs (hunk stage) to work
            require("which-key").register({
                ["<leader>"] = { name = "VISUAL <leader>" },
                ["<leader>h"] = { "Git [H]unk" },
            }, { mode = "v" })
        end,
    },

    -- Session management. Saves your session in the background
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            -- Session files stored at: ~/.config/nvim/sessions/
            dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
            options = vim.opt.sessionoptions:get()
            -- NOTE: autocmd to autoload sessions at: ../config/autocmd.lua
        },
        keys = {
            -- Since we are auto-restoring sessions, keymaps aren't required
            -- { "<leader>sr", function() require("persistence").load() end,                desc = "[R]estore [S]ession" },
            -- { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "[R]estore [L]ast Session" },
        },
    },

    -- Speedup loading large files by disabling some plugins
    {
        "LunarVim/bigfile.nvim",
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

    -- Provides tldr on vertical split
    -- `:Tldr [command]`
    {
        "wlemuel/vim-tldr",
        lazy = true,
        dependencies = {
            "nvim-telescope/telescope.nvim"
        },
    },
}
