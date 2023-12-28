return {
    {
        "nvim-telescope/telescope.nvim", tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "neovim/nvim-lspconfig",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            local actions = require("telescope.actions")

            require("telescope").setup({
                pickers = {
                    find_files = {
                        mappings = {
                            i = {
                                -- Ctrl + s to open in horizontal split
                                ["<C-s>"] = actions.select_horizontal
                            }
                        }
                    }
                }
            })
            require("telescope").load_extension("fzf")

            -- Keymaps for Telescope
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!{**/.git/*,**/node_modules/*,**/package-lock.json,**/yarn.lock}' }})<cr>", {})
            -- TODO: Live grep ain't working
            -- vim.keymap.set("n", "<Leader>fl", builtin.live_grep, {})
            vim.keymap.set("n", "<Leader>fm", builtin.marks, {})
            vim.keymap.set("n", "<Leader>fc", builtin.colorscheme, {})
            vim.keymap.set("n", "<Leader>fr", builtin.registers, {})
            vim.keymap.set("n", "<Leader>fs", builtin.lsp_document_symbols, {})
            vim.keymap.set("n", "<Leader>fw", builtin.grep_string, {})
            vim.keymap.set("n", "<Leader>fg", "<cmd>AdvancedGitSearch<CR>", {})
            vim.keymap.set("n", "<Leader>ft", builtin.treesitter, {})
            -- TODO: Find TODO ain't working either
            vim.keymap.set("n", "<Leader>fd", ":TodoTelescope<CR>", {})
        end
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },
    {
        -- For displaying LSP Code Actions
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown{
                        }
                    }
                }
            })
            require("telescope").load_extension("ui-select")
        end
    },
    {
        "aaronhallaert/advanced-git-search.nvim",
        config = function()
            require("telescope").load_extension("advanced_git_search")
        end
    }
}
