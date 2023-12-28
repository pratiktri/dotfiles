return {
    {
        "airblade/vim-rooter",
        config = function()
            vim.g.rooter_cd_cmd = "tcd"
        end
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    follow_current_file = {
                        enabled = true,         -- Highlight the current buffer
                        leave_dirs_open = true,
                    },
                    use_libuv_file_watcher = true, -- Sync file system changes
                    filtered_items = {
                        visible = true,
                        show_hidden_count = true,
                        hide_dotfile = false,
                        hide_gitignore = false
                    },
                },
                window = {
                    position = "left",
                    width = 25,                 -- Saner window size
                    mappings = {
                        ["s"] = "open_split",   -- Default vim keymap for horizontal split
                        ["v"] = "open_vsplit"   -- Default vim keymap for vertical split
                    }
                },
                default_component_configs = {
                    indent = {
                        indent_size = 1,        -- Compact tree display
                        padding = 0             -- Compact tree display
                    }
                }
            })
            -- Keymaps for Neotree
            vim.keymap.set("n", "<Leader>e", ":Neotree filesystem toggle<CR>")
        end
    }
}
