return {
    { "tpope/vim-repeat" },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },

    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
        opts = {
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--hidden", -- adds dotfiles
                    "--glob=!.git", -- exclude .git directory
                    "--glob=!target",
                    "--glob=!node_modules",
                },
            },
            signs = false,
            keywords = {
                HACK = { alt = { "TIP" } },
            },
        },
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next todo comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous todo comment",
            },
            { "<leader>df", "<cmd>TodoTelescope keywords=FIX,FIXME,BUG<cr>", desc = "FIXME: Tags" },
            { "<leader>dt", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME,BUG<cr>", desc = "Project TODOs" },
            { "<leader>dT", "<cmd>TodoTelescope<cr>", desc = "All tags: FIX, NOTE, TIP, TODO, WARN" },
        },
    },

    {
        "folke/trouble.nvim",
        lazy = false,
        cmd = "Trouble",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- Default: Preview in a split
            preview = {
                type = "split",
                relative = "win",
                position = "right",
                size = 0.6,
            },
            modes = {
                -- Show only the most severe diagnostics; once resolved, less severe will be shown
                project_warnings = {
                    mode = "diagnostics", -- inherit from diagnostics mode
                    filter = function(items)
                        local severity = vim.diagnostic.severity.WARN
                        for _, item in ipairs(items) do
                            severity = math.min(severity, item.severity)
                        end
                        return vim.tbl_filter(function(item)
                            return item.severity == severity
                        end, items)
                    end,
                },

                -- Diagnostics from buffer + Errors from current project
                file_hints = {
                    mode = "diagnostics", -- inherit from diagnostics mode
                    filter = {
                        any = {
                            buf = 0, -- current buffer
                            {
                                severity = vim.diagnostic.severity.INFO,
                                -- limit to files in the current project
                                function(item)
                                    return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
                                end,
                            },
                        },
                    },
                },
            },
        },
        keys = {
            { "<leader>dd", "<cmd>Trouble file_hints toggle focus=true<cr>", desc = "Trouble: File Diagnostics" },
            { "<leader>dw", "<cmd>Trouble project_warnings toggle focus=true<cr>", desc = "Trouble: List Project Diagnostics" },
            { "<leader>dq", "<cmd>Trouble quickfix toggle focus=true<cr>", desc = "Trouble: Quickfix List" },
            { "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>", desc = "Goto References" },
        },
    },

    {
        "nvimdev/lspsaga.nvim",
        event = { "FileType" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local disabled_filetypes = { "awk" }
            require("lspsaga").setup({
                ui = {
                    kind = require("config.util").icons.kind_lspsaga,
                    devicon = true,
                    title = true,
                },
                implement = {
                    enable = true,
                    virtual_text = true,
                    sign = true,
                    priority = 100,
                },
                symbol_in_winbar = {
                    enable = not vim.tbl_contains(disabled_filetypes, vim.bo.filetype),
                    hide_keyword = true,
                },
                lightbulb = { virtual_text = false },
                outline = { auto_preview = false },
            })

            vim.keymap.set({ "n", "t" }, "<C-`>", "<cmd>Lspsaga term_toggle<cr>", { desc = "Toggle Floating Terminal" })
            -- Rest of the keymaps in ../core/lsp.lua
        end,
    },

    {
        "hasansujon786/nvim-navbuddy",
        dependencies = {
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            local actions = require("nvim-navbuddy.actions")
            local navbuddy = require("nvim-navbuddy")

            navbuddy.setup({
                lsp = { auto_attach = true },
                icons = require("config.util").icons.kinds,
                window = {
                    border = "rounded",
                    size = "80%",
                },
                mappings = {
                    -- Telescope search symbols at current level
                    ["/"] = actions.telescope({
                        layout_config = {
                            height = 0.8,
                            width = 0.8,
                        },
                    }),

                    -- Default Mappings on the popup
                    --
                    -- ["J"] = actions.move_down(), -- Move focused node down
                    -- ["K"] = actions.move_up(), -- Move focused node up
                    --
                    -- ["r"] = actions.rename(), -- Rename currently focused symbol
                    --
                    -- ["<C-v>"] = actions.vsplit(), -- Open selected node in a vertical split
                    -- ["<C-s>"] = actions.hsplit(), -- Open selected node in a horizontal split
                    --
                    -- ["0"] = actions.root(), -- Move to first panel
                    --
                    -- ["g?"] = actions.help(), -- Open mappings help window
                },
            })
        end,
        keys = {
            {
                "<leader>o",
                function()
                    return require("nvim-navbuddy").open()
                end,
                desc = "Navigate through document symbols",
            },
        },
    },

    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neo-tree/neo-tree.nvim",
        },
        config = function()
            require("lsp-file-operations").setup()
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        init = function(plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },

        config = function()
            vim.defer_fn(function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = {
                        "bash",
                        "css",
                        "dockerfile",
                        "go",
                        "html",
                        "javascript",
                        "json5",
                        "jsonc",
                        "lua",
                        "markdown",
                        "markdown_inline",
                        "python",
                        "regex",
                        "rust",
                        "scss",
                        "sql",
                        "svelte",
                        "tsx",
                        "typescript",
                        "vue",
                        "yaml",
                    },

                    auto_install = true,
                    indent = { enable = true },

                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = "<C-space>",
                            node_incremental = "<C-space>",
                            scope_incremental = "<C-CR>",
                            node_decremental = "<bs>",
                        },
                    },

                    textobjects = {
                        select = {
                            enable = true,
                            lookahead = true, -- Automatically jump forward to textobj
                            keymaps = {
                                ["aa"] = { query = "@parameter.outer", desc = "Select around the parameter" },
                                ["ia"] = { query = "@parameter.inner", desc = "Select inside the parameter" },
                                ["af"] = { query = "@function.outer", desc = "Select around the function" },
                                ["if"] = { query = "@function.inner", desc = "Select inside of the function" },
                                ["ac"] = { query = "@class.outer", desc = "Select around the class" },
                                ["ic"] = { query = "@class.inner", desc = "Select inside of the class" },

                                ["al"] = { query = "@loop.outer", desc = "Select around the loop" },
                                ["il"] = { query = "@loop.inner", desc = "Select inside of the loop" },
                                ["as"] = { query = "@scope", query_group = "locals", desc = "Select around the scope" },
                            },
                        },

                        move = {
                            -- Jump to next and previous text objects
                            -- ]a -> next argument
                            -- ]T -> next test
                            enable = true,
                            goto_next_start = {
                                ["]f"] = { query = "@function.outer", desc = "Goto next inner function start" },
                                ["]o"] = { query = "@loop.*", desc = "Goto next loop start" },
                                ["]a"] = { query = "@parameter.inner", desc = "Goto next parameter" },
                            },
                            goto_next_end = {
                                ["]F"] = { query = "@function.outer", desc = "Goto next outer function end" },
                                ["]C"] = { query = "@class.outer", desc = "Goto next outer class end" },
                                ["]O"] = { query = "@loop.*", desc = "Goto next loop end" },
                            },
                            goto_previous_start = {
                                ["[f"] = { query = "@function.outer", desc = "Goto goto previous inner function start" },
                                ["[o"] = { query = "@loop.*", desc = "Goto previous loop start" },
                                ["[a"] = { query = "@parameter.inner", desc = "Goto previous parameter" },
                            },
                            goto_previous_end = {
                                ["[F"] = { query = "@function.outer", desc = "Goto goto previous outer function start" },
                                ["[C"] = { query = "@class.outer", desc = "Goto previous outer class start" },
                                ["[O"] = { query = "@loop.*", desc = "Goto previous loop start" },
                            },
                        },

                        lsp_interop = {
                            enable = true,
                            border = "none",
                            floating_preview_opts = {},
                        },
                    },
                })
            end, 0)
        end,
    },
}
