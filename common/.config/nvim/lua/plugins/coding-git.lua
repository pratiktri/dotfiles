return {

    { "tpope/vim-fugitive" },
    --{  "tpope/vim-rhubarb" }, --If fugitive.vim is the Git, rhubarb.vim is the Hub.

    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
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
            attach_to_untracker = true,
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

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

                -- Staging
                -- Actions
                map("n", "<leader>gr", gs.reset_hunk, { desc = "Git: reset hunk" })
                map("n", "<leader>gsh", gs.stage_hunk, { desc = "Git: Stage Hunk" })
                map("n", "<leader>gsu", gs.undo_stage_hunk, { desc = "Git: Undo Stage Hunk" })
                map("n", "<leader>gsb", gs.stage_buffer, { desc = "Git: Stage Current File" })

                -- visual mode
                map("v", "<leader>gsH", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Git: Visual Stage Hunk" })
                map("v", "<leader>gsR", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Git: Visual Reset Hunk" })

                -- normal mode
                map("n", "<leader>gp", gs.preview_hunk, { desc = "Git: Preview hunk" })
                map("n", "<leader>gD", gs.diffthis, { desc = "Git: diff against index" })
                map("n", "<leader>gd", function()
                    gs.diffthis("~")
                end, { desc = "Git: diff against last commit" })

                -- Toggles
                map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Git: toggle blame line" })
                map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Git: toggle show deleted" })

                -- Text object
                map({ "o", "x" }, "gih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git: Visual select hunk" })
            end,
        },
    },
}
