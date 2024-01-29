return {

    { "tpope/vim-fugitive", },
    --{  "tpope/vim-rhubarb" }, --If fugitive.vim is the Git, rhubarb.vim is the Hub.

    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map({ "n", "v" }, "]h", function()
                    if vim.wo.diff then
                        return "]h"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Jump to next git hunk" })

                map({ "n", "v" }, "[h", function()
                    if vim.wo.diff then
                        return "[h"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Jump to previous git hunk" })

                -- Actions
                -- visual mode
                map("v", "<leader>ghr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "reset git hunk" })
                -- normal mode
                map("n", "<leader>ghp", gs.preview_hunk, { desc = "preview git hunk" })

                map("n", "<leader>ghr", gs.reset_hunk, { desc = "git reset hunk" })
                map("n", "<leader>ghb", function()
                    gs.blame_line({ full = false })
                end, { desc = "git blame line" })
                map("n", "<leader>ghD", gs.diffthis, { desc = "git diff against index" })
                map("n", "<leader>ghd", function()
                    gs.diffthis("~")
                end, { desc = "git diff against last commit" })

                -- Toggles
                map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
                map("n", "<leader>gtd", gs.toggle_deleted, { desc = "toggle git show deleted" })

                -- Text object
                map({ "o", "x" }, "gih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
            end,
        },
    },
}