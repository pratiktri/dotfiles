return {
    {
        "easymotion/vim-easymotion",
        keys = {
            { "<leader>j", "<Plug>(easymotion-s)", desc = "Easymotion jump" },
        },
    },

    {
        "unblevable/quick-scope",
        init = function()
            vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }

            vim.cmd([[
              highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
              highlight QuickScopeSecondary guifg='#00C7DF' gui=underline ctermfg=81 cterm=underline
            ]])
        end,
    },

    -- File Explorer: Neotree
    {
        "nvim-neo-tree/neo-tree.nvim",
        cond = require("config.util").is_not_vscode(),
        keys = {
            { "<leader><tab>", "<CMD>Neotree toggle left<CR>", desc = "Open NeoTree Explorer at Git root", remap = true },
        },
        deactivate = function()
            vim.cmd([[Neotree close]])
        end,
        opts = {
            enable_git_status = true,
            filesystem = {
                bind_to_cwd = true,
                follow_current_file = {
                    enabled = true, -- Highlight the current buffer
                    leave_dirs_open = false,
                },
                use_libuv_file_watcher = true, -- Sync file system changes
                filtered_items = {
                    visible = true,
                    show_hidden_count = true,
                    hide_dotfile = false,
                    hide_gitignore = false,
                },
            },
            window = {
                position = "left",
                width = 30, -- Saner window size
                mappings = {
                    ["s"] = "open_split",
                    ["v"] = "open_vsplit",
                    ["Y"] = function(state) -- Copy file's path to + register
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        vim.fn.setreg("+", path, "c")
                    end,
                },
            },
            default_component_configs = {
                indent = {
                    indent_size = 2,
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
            },
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
        },
        config = function(_, opts)
            local config = require("config.util")

            local function on_move(data)
                config.on_rename(data.source, data.destination)
            end

            local events = require("neo-tree.events")
            opts.event_handlers = opts.event_handlers or {}
            vim.list_extend(opts.event_handlers, {
                { event = events.FILE_MOVED, handler = on_move },
                { event = events.FILE_RENAMED, handler = on_move },
            })
            require("neo-tree").setup(opts)
        end,
    },

    -- Telescope: Fuzzy Finder (files, lsp, etc)
    {
        "nvim-telescope/telescope.nvim",
        cond = require("config.util").is_not_vscode(),
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            "nvim-telescope/telescope-ui-select.nvim",
            {
                "nvim-tree/nvim-web-devicons",
                enabled = vim.g.have_nerd_font,
            },
        },
        config = function()
            local telescopeConfig = require("telescope.config")

            local filters = {
                "--hidden",
                "--glob",
                "!**/.git/*",
                "--glob",
                "!**/node_modules/*",
                "--glob",
                "!**/target/*",
            }

            -- Clone the default Telescope configuration
            local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

            -- Merge default arguments with filters
            for i = 1, #filters do
                vimgrep_arguments[#vimgrep_arguments + 1] = filters[i]
            end

            require("telescope").setup({
                defaults = {
                    hidden = true,
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
                        find_command = {
                            unpack(telescopeConfig.values.vimgrep_arguments),
                            "--files",
                            unpack(filters),
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            -- Load some required Telescope extensions
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            -- Keymaps for LSP Things -> In code-lsp.lua

            -- Buffer
            vim.keymap.set("n", "<leader>bl", require("telescope.builtin").buffers, { desc = "List Buffers" })

            -- TIP: Needs terminal (kitty) configured to send correct key code to NeoVim: \x1b[70;5u
            vim.keymap.set("n", "<C-S-f>", require("telescope.builtin").live_grep, { desc = "Search/LiveGrep the Project" })

            -- List
            vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, { desc = "Search Files" })

            -- Git
            vim.keymap.set("n", "<leader>gc", require("telescope.builtin").git_commits, { desc = "Git: Commits" })
            vim.keymap.set("n", "<leader>gb", require("telescope.builtin").git_branches, { desc = "Git: Branches" })

            -- Neovim Things
            vim.keymap.set("n", "<leader>nh", require("telescope.builtin").help_tags, { desc = "Search NeoVIM Help" })
            vim.keymap.set("n", "<leader>nm", require("telescope.builtin").man_pages, { desc = "Help: System Man Pages" })
            vim.keymap.set("n", "<leader>nv", require("telescope.builtin").vim_options, { desc = "Help: Vim Options" })
            vim.keymap.set("n", "<leader>nk", require("telescope.builtin").keymaps, { desc = "Help: NeoVIM Keymaps" })
            vim.keymap.set("n", "<leader>ns", require("telescope.builtin").search_history, { desc = "Search History" })
            vim.keymap.set("n", "<leader>nH", require("telescope.builtin").command_history, { desc = "Command History" })
            vim.keymap.set("n", "<leader>nc", require("telescope.builtin").colorscheme, { desc = "Colorschemes (with preview)" })
        end,
    },
}
