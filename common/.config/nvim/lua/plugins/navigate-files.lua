return {

    -- File Explorer: Neotree
    {
        "nvim-neo-tree/neo-tree.nvim",
        cond = require("config.util").is_not_vscode(),
        branch = "v3.x",
        keys = {
            { "<leader><tab>", "<CMD>Neotree toggle left<CR>",  desc = "Open NeoTree Explorer at Git root", remap = true },
            { "<leader>e",     "<CMD>Neotree toggle float<CR>", desc = "Open NeoTree on Floating Window",   remap = true },

            {
                "<leader>be",
                function()
                    require("neo-tree.command").execute({ source = "buffers", toggle = true })
                end,
                desc = "NeoTree: Open Buffer Explorer",
            },
        },
        deactivate = function()
            vim.cmd([[Neotree close]])
        end,
        init = function()
            if vim.fn.argc(-1) == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
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
                width = 30,                 -- Saner window size
                mappings = {
                    ["s"] = "open_split",   -- horizontal split
                    ["v"] = "open_vsplit",  -- vertical split
                    ["Y"] = function(state) -- Copy file's path to + register
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        vim.fn.setreg("+", path, "c")
                    end,
                },
            },
            default_component_configs = {
                indent = {
                    indent_size = 2,       -- Compact tree display
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
                { event = events.FILE_MOVED,   handler = on_move },
                { event = events.FILE_RENAMED, handler = on_move },
            })
            require("neo-tree").setup(opts)
            vim.api.nvim_create_autocmd("TermClose", {
                pattern = "*lazygit",
                callback = function()
                    if package.loaded["neo-tree.sources.git_status"] then
                        require("neo-tree.sources.git_status").refresh()
                    end
                end,
            })
        end,
    },

    -- Telescope: Fuzzy Finder (files, lsp, etc)
    {
        "nvim-telescope/telescope.nvim",
        cond = require("config.util").is_not_vscode(),
        branch = "0.1.x",
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
                "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font
            }
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
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            -- Load some required Telescope extensions
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            -- Special Things: Telescope
            vim.keymap.set("n", "<leader>nc", require("telescope.builtin").colorscheme,
                { desc = "List Neovim Colorschemes (with preview)" })

            -- Grep things -> Search
            vim.keymap.set("n", "<leader>sb", function()
                require("telescope.builtin").live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                })
            end, { desc = "Search Open Buffers" })
            vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep,
                { desc = "Search/LiveGrep the Project" })
            vim.keymap.set("n", "<C-a-f>", require("telescope.builtin").live_grep,
                { desc = "Search/LiveGrep the Project" })
            vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string,
                { desc = "Search current Word in Project" })

            -- List
            vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "List Buffers" })
            vim.keymap.set("n", "<leader>fc", require("telescope.builtin").command_history,
                { desc = "List NeoVIM Command History" })
            vim.keymap.set("n", "<C-a-p>", require("telescope.builtin").find_files, { desc = "List & Search Files" })
            vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "List & Search Files" })
            vim.keymap.set("n", "<leader>fn", require("telescope.builtin").help_tags,
                { desc = "List & Search NeoVIM Help" })
            vim.keymap.set("n", "<leader>fq", require("telescope.builtin").quickfixhistory,
                { desc = "List Quickfix History" })
            vim.keymap.set("n", "<leader>fs", require("telescope.builtin").search_history,
                { desc = "List Search History" })

            -- Git
            vim.keymap.set("n", "<leader>gfb", require("telescope.builtin").git_branches, { desc = "List Git Branches" })
            vim.keymap.set("n", "<leader>gfc", require("telescope.builtin").git_commits, { desc = "List Git Commits" })

            -- LSP Things -> Coding
            vim.keymap.set("n", "<leader>cld", require("telescope.builtin").diagnostics,
                { desc = "Code: List Diagnostics" })

            vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations,
                { desc = "Code: Goto Implementation" })

            vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "Code: Goto Definition" })
            vim.keymap.set("n", "<leader>ct", require("telescope.builtin").lsp_type_definitions,
                { desc = "Code: Goto Type Definition" })
            -- vim.keymap.set("n", "<leader>cgD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })

            vim.keymap.set("n", "<leader>cR", require("telescope.builtin").lsp_references,
                { desc = "Code: Goto References" })
            -- vim.keymap.set("n", "<leader>cR", require("telescope.builtin").lsp_references, { desc = "Code: List References for word under cursor" })

            vim.keymap.set("n", "<leader>O", require("telescope.builtin").lsp_workspace_symbols,
                { desc = "Code: Search Workspace Symbols" })

            vim.keymap.set("n", "<leader>nk", require("telescope.builtin").keymaps,
                { desc = "List & Search NeoVIM Keymaps" })
            vim.keymap.set("n", "<leader>nm", require("telescope.builtin").man_pages,
                { desc = "List & Search System Man Pages" })
            vim.keymap.set("n", "<leader>nn", "<cmd>Telescope notify<cr>", { desc = "List past notifications" })
            vim.keymap.set("n", "<leader>nv", require("telescope.builtin").vim_options, { desc = "List Vim Options" })
        end,
    },
}
