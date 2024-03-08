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
                ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
                ["<leader>b"] = { name = "[B]buffer Operations", _ = "which_key_ignore" },
                ["<leader>d"] = { name = "[D]iagnostics", _ = "which_key_ignore" },
                ["<leader>f"] = { name = "[F]ile Operations", _ = "which_key_ignore" },
                ["<leader>g"] = { name = "[G]it Operations", _ = "which_key_ignore" },
                ["<leader>l"] = { name = "[L]ist Things", _ = "which_key_ignore" },
                ["<leader>n"] = { name = "[N]VIM Operations", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "[S]earch/Grep Things", _ = "which_key_ignore" },
                ["<leader>t"] = { name = "Unit [T]est Operations", _ = "which_key_ignore" },
                ["<leader>x"] = { name = "Delete/Remove Something", _ = "which_key_ignore" },
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
    -- TIP: autocmd to autoload sessions at: ../config/autocmd.lua
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            -- Session files stored at: ~/.config/nvim/sessions/
            dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
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
}
