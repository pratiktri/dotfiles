return {
    -- Better fugitive: neogit
    {
        "NeogitOrg/neogit",
        cond = require("config.util").is_not_vscode(),
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = true,
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Git: Open Neogit", mode = { "n" } },
        },
    },

    -- Git Diffview
    {
        "sindrets/diffview.nvim",
        cond = require("config.util").is_not_vscode(),
        keys = {

            { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git: Open Diffview", mode = { "n" } },
            { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Git: Open Diffview against master", mode = { "n" } },
        },
    },

    -- Adds git related signs to the gutter, as well as utilities for managing changes
    {
        "lewis6991/gitsigns.nvim",
        cond = require("config.util").is_not_vscode(),
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "—" },
                topdelete = { text = "—" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            attach_to_untracked = true,
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                gs.toggle_current_line_blame() -- git blame line

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map({ "n", "v" }, "]g", function()
                    if vim.wo.diff then
                        return "]g"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Next Git hunk" })

                map({ "n", "v" }, "[g", function()
                    if vim.wo.diff then
                        return "[g"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Previous Git hunk" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: Visual select hunk" })

                map("n", "<leader>gr", gs.reset_hunk, { desc = "Git: reset hunk" })
                map("n", "<leader>gp", gs.preview_hunk, { desc = "Git: Preview hunk" })

                map("n", "<leader>gK", function()
                    gs.blame_line({ full = true })
                end, { desc = "Git: Hover blame-line" })

                map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Git: Toggle virtual blame-line" })
            end,
        },
    },
}
