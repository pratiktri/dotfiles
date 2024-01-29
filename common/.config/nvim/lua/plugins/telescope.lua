return {
    -- Fuzzy Finder (files, lsp, etc)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
        config = function()
            -- NOTE: Search in hidden files trick taken from: https://stackoverflow.com/a/75500661/11057673
            local telescopeConfig = require("telescope.config")

            -- Clone the default Telescope configuration
            local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

            -- Add flag to search hidden files/folders
            table.insert(vimgrep_arguments, "--hidden")
            table.insert(vimgrep_arguments, "--glob")
            -- And to ignore .git directory. Needed since its not `.gitignore`d
            table.insert(vimgrep_arguments, "!**/.git/*")

            require("telescope").setup({
                defaults = {
                    -- `hidden = true` is not supported in text grep commands.
                    hidden = true,
                    -- Without this live_grep would show .git entries
                    vimgrep_arguments = vimgrep_arguments,
                    mappings = {
                        i = {
                            ["<C-u>"] = false,
                            ["<C-d>"] = false,
                        },
                    },
                },
                pickers = {
                    colorscheme = { enable_preview = true },
                    find_files = {
                        hidden = true,
                        -- Redoing the vimgrep_arguments changes for find_files as well
                        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                    },
                },
            })

            -- Load some required Telescope extensions
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "noice")
            pcall(require("telescope").load_extension, "undo")

            -- Special Things: [T]elescope
            vim.keymap.set("n", "<leader>tr", require("telescope.builtin").resume,
                { desc = "[T]elescope [R]esume Last Search" })
            vim.keymap.set("n", "<leader>tc", require("telescope.builtin").colorscheme,
                { desc = "List Colorschemes (with preview)" })

            -- Grep things -> [S]earch
            vim.keymap.set("n", "<leader>sb", function()
                require("telescope.builtin").live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                })
            end, { desc = "[S]earch Open [B]uffers" })
            vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep,
                { desc = "[S]earch/Live[G]rep the Project" })
            vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string,
                { desc = "[S]earch current [W]ord in Project" })

            -- [L]ist
            vim.keymap.set("n", "<leader>lb", require("telescope.builtin").buffers, { desc = "[L]ist [B]uffers" })
            vim.keymap.set("n", "<leader>lc", require("telescope.builtin").command_history,
                { desc = "[L]ist NeoVIM [C]ommand History" })
            vim.keymap.set("n", "<leader>lf", require("telescope.builtin").find_files,
                { desc = "[L]ist & Search [F]iles" })
            vim.keymap.set("n", "<leader>lh", require("telescope.builtin").help_tags,
                { desc = "[L]ist & Search NeoVIM [H]elp" })
            vim.keymap.set("n", "<leader>lk", require("telescope.builtin").keymaps,
                { desc = "[L]ist & Search NeoVIM [K]eymaps" })
            vim.keymap.set("n", "<leader>lm", require("telescope.builtin").marks, { desc = "[L]ist [M]arks" })
            vim.keymap.set("n", "<leader>ln", require("telescope.builtin").man_pages,
                { desc = "[L]ist & Search System Ma[n] Pages" })
            vim.keymap.set("n", "<leader>lq", require("telescope.builtin").quickfixhistory,
                { desc = "[L]ist [Q]uickfix History" })
            vim.keymap.set("n", "<leader>ls", require("telescope.builtin").search_history,
                { desc = "[L]ist [S]earch History" })
            vim.keymap.set("n", "<leader>lv", require("telescope.builtin").vim_options, { desc = "[L]ist [V]im Options" })

            -- Git things -> [G]it
            vim.keymap.set("n", "<leader>gb", require("telescope.builtin").git_branches,
                { desc = "List [G]it [B]ranches" })
            vim.keymap.set("n", "<leader>gc", require("telescope.builtin").git_commits, { desc = "List [G]it [C]ommits" })

            -- LSP Things -> [C]oding
            vim.keymap.set("n", "<leader>cd", require("telescope.builtin").diagnostics,
                { desc = "[C]ode: List [D]iagnostics" })
            vim.keymap.set(
                "n",
                "<leader>ci",
                require("telescope.builtin").lsp_implementations,
                { desc = "[C]ode: Goto [I]mplementation of the word under cursor" }
            )
            vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references,
                { desc = "[C]ode: List [R]eferences for word under cursor" })
            vim.keymap.set(
                "n",
                "<leader>ct",
                require("telescope.builtin").lsp_type_definitions,
                { desc = "[C]ode: Goto definition of the [T]ype under cursor" }
            )
        end,
    },
}
