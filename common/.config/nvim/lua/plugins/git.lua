return {
    -- Better fugitive: neogit
    {
        "NeogitOrg/neogit",
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
        keys = {
            { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Git: Diffview Project against index/staging", mode = { "n" } },
        },
    },

    -- Adds git related signs to the gutter, as well as utilities for managing changes
    {
        "lewis6991/gitsigns.nvim",
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
            current_line_blame = true, -- Show git line blame-line by default
            current_line_blame_opts = {
                virt_text_opt = "right_align",
                ignore_whitespace = true,
            },
            current_line_blame_formatter = "<author>, <author_time:%R>, <summary>",
            on_attach = function(bufnr)
                local gs = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: Visual select hunk" })

                map({ "n", "v" }, "]h", function()
                    gs.next_hunk()
                end, { desc = "Next Git hunk" })

                map({ "n", "v" }, "[h", function()
                    gs.prev_hunk()
                end, { desc = "Previous Git hunk" })

                map("n", "<leader>gQ", function()
                    gs.setqflist("all", { open = false })
                end, { desc = "Git: Project Hunks to quickfix list" })

                map("n", "<leader>gd", function()
                    gs.diffthis("~1")
                end, { desc = "git: Diff the file against last commit" })

                map("n", "<leader>gr", gs.reset_hunk, { desc = "Git: Reset hunk" })
                map("n", "<leader>gp", gs.preview_hunk, { desc = "Git: Preview hunk" })
                map("n", "<leader>gs", gs.stage_hunk, { desc = "Git: Toggle Stage-Hunk" })

                map("n", "<leader>gK", function()
                    gs.blame_line({ full = true })
                end, { desc = "Git: Hover blame-line" })

                map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Git: Toggle virtual blame-line" })
            end,
        },
    },
}
