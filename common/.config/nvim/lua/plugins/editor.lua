return {

    -- Changes the Nvim root to git root
    {
        "airblade/vim-rooter",
        config = function()
            vim.g.rooter_cd_cmd = "tcd" -- Use tcd command to change the root
        end,
    },

    -- File Explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        keys = {
            { "<leader>e", ":Neotree filesystem toggle<CR>", desc = "Open NeoTree [E]plorer at Git root", remap = true },

            {
                "<leader>be",
                function()
                    require("neo-tree.command").execute({ source = "buffers", toggle = true })
                end,
                desc = "NeoTree: Open [B]uffer [E]xplorer",
            },
        },
        opts = {
            enable_git_status = true,
            filesystem = {
                bind_to_cwd = true,
                follow_current_file = {
                    enabled = true, -- Highlight the current buffer
                    leave_dirs_open = true,
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
                width = 30,                -- Saner window size
                mappings = {
                    ["s"] = "open_split",  -- Default vim keymap for horizontal split
                    ["v"] = "open_vsplit", -- Default vim keymap for vertical split
                },
            },
            default_component_configs = {
                indent = {
                    indent_size = 2, -- Compact tree display
                },
            },
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
        },
    },

    -- Automatically highlights other instances of the word under cursor
    {
        "RRethy/vim-illuminate",
        config = function(_, opts)
            -- Copied from LazyNvim
            require("illuminate").configure(opts)

            local function map(key, dir, buffer)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. dir .. "_reference"](false)
                end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
            end

            map("]]", "next")
            map("[[", "prev")

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map("]]", "next", buffer)
                    map("[[", "prev", buffer)
                end,
            })
        end,
        keys = {
            { "]]", desc = "Next Reference" },
            { "[[", desc = "Prev Reference" },
        },
    },

    -- Display undotree
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },

    -- Show buffers like VS Code tabs
    {
        "akinsho/bufferline.nvim",
        dependencies = {
            { "echasnovski/mini.bufremove", version = "*" },
        },
        event = "VeryLazy",
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",   desc = "Toggle buffer-pin" },
            { "<leader>xo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
        },
        opts = {
            options = {
                close_command = function(n) require("mini.bufremove").delete(n, false) end,
                right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
                diagnostics = "nvim_lsp",
                always_show_bufferline = false,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
        config = function(_, opts)
            require("bufferline").setup(opts)
            -- Fix bufferline when restoring a session
            vim.api.nvim_create_autocmd("BufAdd", {
                callback = function()
                    vim.schedule(function()
                        pcall(nvim_bufferline)
                    end)
                end,
            })
        end,
    },

    -- UI Stuff ------------------------------------------------------------------------

    -- icons
    { "nvim-tree/nvim-web-devicons" },

    -- ui components
    { "MunifTanjim/nui.nvim" },

    -- Better vim.ui
    { "stevearc/dressing.nvim" },

    -- Better `vim.notify()`
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader>xn",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss all Notifications",
            },
        },
        opts = {
            render = "wrapped-compact", -- Smaller popups
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.25)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.5)
            end,
            on_open = function(win)
                vim.api.nvim_win_set_config(win, { zindex = 100 })
            end,
        },
    },

    -- Completely replaces the UI for messages, cmdline and the popupmenu.
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            routes = {
                {
                    -- Show popup message when @recording macros
                    view = "notify",
                    filter = { event = "msg_showmode" },
                },
                {
                    filter = { event = "notify", find = "No information available" },
                    opts = { skin = true },
                },
                {
                    -- Direct some messages to bottom - obove lualine
                    view = "mini",
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },

                            -- Display delete, yank, jump notifications at bottom
                            { find = "yanked" },
                            { find = "fewer lines" },
                            { find = "more lines" },
                            { find = "EasyMotion" }, -- This can be completely discarded
                            { find = "Target key" },
                            { find = "search hit BOTTOM" },
                            { find = "lines to indent" },
                            { find = "lines indented" },
                        },
                    },
                },
            },
            presets = {
                lsp_doc_border = true,
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
            },
        },
        keys = {
            { "<leader>nx", "<cmd>NoiceDismiss<CR>", desc = "Dismiss all [N]oice notifications" },
            -- TODO: Find better keymaps
            -- { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                 desc = "Redirect Cmdline" },
            -- { "<leader>snl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
            -- { "<leader>snh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
            -- { "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
            -- { "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
            -- { "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
            -- { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,              expr = true,              desc = "Scroll forward",  mode = { "i", "n", "s" } },
            -- { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,              expr = true,              desc = "Scroll backward", mode = { "i", "n", "s" } },
        },
    },

    -- Set lualine as statusline
    {
        "nvim-lualine/lualine.nvim",
        -- See `:help lualine.txt`
        opts = {
            -- TODO: Need the following:
            -- - Remove encoding & OS
            -- - Add Breadcrumb
            -- - Show command that was typed
            options = {
                icons_enabled = false,
                component_separators = "|",
                section_separators = "",
            },
        },
    },
}
