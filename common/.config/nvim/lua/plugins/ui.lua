return {
    -- icons
    {
        "nvim-tree/nvim-web-devicons",
        cond = require("config.util").is_not_vscode(),
    },

    -- ui components
    {
        "MunifTanjim/nui.nvim",
        cond = require("config.util").is_not_vscode(),
    },

    -- Better vim.ui
    {
        "stevearc/dressing.nvim",
        cond = require("config.util").is_not_vscode(),
    },

    { "machakann/vim-highlightedyank" },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                compile_path = vim.fn.stdpath("cache") .. "/catppuccin",

                integrations = {
                    telescope = {
                        style = "nvchad",
                    },

                    -- These were disabled by default
                    blink_cmp = true,
                    diffview = true,
                    fidget = true,
                    lsp_saga = true,
                    mason = true,
                    neotest = true,
                    noice = true,
                    notify = true,
                    dadbod_ui = true,
                    nvim_surround = true,
                    navic = {
                        enabled = true,
                    },
                    illuminate = {
                        lsp = true,
                    },
                    snacks = true,
                    which_key = true,

                    -- These were enabled by default
                    render_markdown = false,
                },

                flavour = "mocha",
            })

            require("nvim-navic").setup({
                highlight = true,
            })
            vim.cmd("colorscheme catppuccin")
        end,
    },

    -- Show buffers like VS Code tabs
    {
        "akinsho/bufferline.nvim",
        cond = require("config.util").is_not_vscode(),
        event = "VeryLazy",
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle buffer-pin" },
            { "<leader>bX", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
            { "<leader>xo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
            { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
            { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
        },
        opts = {
            options = {
                close_command = function(n)
                    Snacks.bufdelete.delete(n, false)
                end,
                right_mouse_command = function(n)
                    Snacks.bufdelete.delete(n, false)
                end,
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
            local buf_line = require("bufferline")
            buf_line.setup(opts)

            -- <alt+1> ... <alt+9> to switch to a buffer
            for i = 1, 9 do
                vim.keymap.set(
                    { "n", "v" },
                    string.format("<A-%s>", i),
                    string.format("<cmd>BufferLineGoToBuffer %s<CR>", i),
                    { noremap = true, silent = true }
                )
            end

            -- Fix bufferline when restoring a session
            vim.api.nvim_create_autocmd("BufAdd", {
                callback = function()
                    vim.schedule(function()
                        ---@diagnostic disable-next-line: param-type-mismatch
                        pcall(buf_line)
                    end)
                end,
            })
        end,
    },

    -- Completely replaces the UI for messages, cmdline and the popupmenu.
    {
        "folke/noice.nvim",
        cond = require("config.util").is_not_vscode(),
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            lsp = {
                progress = {
                    throttle = 1000 / 100,
                },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                hover = {
                    silent = true,
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

                            -- When message contains following
                            { find = "yanked" },
                            { find = "fewer lines" },
                            { find = "more lines" },
                            { find = "EasyMotion" },
                            { find = "Target key" },
                            { find = "search hit BOTTOM" },
                            { find = "lines to indent" },
                            { find = "lines indented" },
                            { find = "lines changed" },
                            { find = ">ed" },
                            { find = "<ed" },
                            { find = "The only match" },
                            { find = "DB:" },
                            { find = "cwd:" },
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
    },

    -- Set lualine as statusline
    {
        "nvim-lualine/lualine.nvim",
        cond = require("config.util").is_not_vscode(),
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        opts = function()
            local lualine_require = require("lualine_require")
            lualine_require.require = require
            vim.o.laststatus = vim.g.lualine_laststatus

            local config = require("config.util")

            return {
                options = {
                    theme = "auto",
                    icons_enabled = true,
                    globalstatus = true,
                    component_separators = "|",
                    section_separators = "",
                },
                extensions = { "neo-tree", "lazy" },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        "branch",
                        {
                            "diff",
                            symbols = {
                                added = config.icons.git.added,
                                modified = config.icons.git.modified,
                                removed = config.icons.git.removed,
                            },
                            source = function()
                                local gitsigns = vim.b.gitsigns_status_dict
                                if gitsigns then
                                    return {
                                        added = gitsigns.added,
                                        modified = gitsigns.changed,
                                        removed = gitsigns.removed,
                                    }
                                end
                            end,
                        },
                    },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                error = config.icons.diagnostics.Error,
                                warn = config.icons.diagnostics.Warn,
                                info = config.icons.diagnostics.Info,
                                hint = config.icons.diagnostics.Hint,
                            },
                        },
                        {
                            function()
                                return "  " .. require("dap").status()
                            end,
                            cond = function()
                                return package.loaded["dap"] and require("dap").status() ~= ""
                            end,
                            color = config.fg("Debug"),
                        },
                    },

                    lualine_x = {
                        {
                            function()
                                return require("noice").api.status.command.get()
                            end,
                            cond = function()
                                return package.loaded["noice"] and require("noice").api.status.command.has()
                            end,
                            color = config.fg("Statement"),
                        },
                        {
                            function()
                                return require("noice").api.status.mode.get()
                            end,
                            cond = function()
                                return package.loaded["noice"] and require("noice").api.status.mode.has()
                            end,
                            color = config.fg("Constant"),
                        },
                    },

                    lualine_y = {
                        {
                            "filename",
                            file_status = true,
                            path = 1,
                        },
                        { "filetype", padding = { left = 1, right = 1 } },
                    },
                    lualine_z = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                },
            }
        end,
    },
}
