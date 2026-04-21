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
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        init = function()
            -- Disable the plugin's own vimscript runtime
            vim.g.loaded_nvim_treesitter = 1
        end,
        config = function()
            require("nvim-treesitter").setup({
                auto_install = true,
            })

            local parsers = {
                "bash",
                "css",
                "dockerfile",
                "go",
                "html",
                "javascript",
                "json5",
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
            }

            local installed = require("nvim-treesitter").get_installed()
            local to_install = vim.tbl_filter(function(p)
                return not vim.tbl_contains(installed, p)
            end, parsers)

            if #to_install > 0 then
                require("nvim-treesitter.install").install(to_install)
            end

            -- Auto-install when opening a new filetype
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("TSAutoInstall", { clear = true }),
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
                    if not lang then
                        return
                    end

                    local ok = pcall(vim.treesitter.language.inspect, lang)
                    if not ok then
                        -- Parser not installed yet, install it
                        require("nvim-treesitter.install").install({ lang })
                    end
                end,
            })

            -- FileType autocmd: wire up highlight + indent for every treesitter-capable buffer
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("TSEnable", { clear = true }),
                callback = function(args)
                    local buf = args.buf
                    -- start() returns false if no parser is available, pcall catches missing parsers
                    if pcall(vim.treesitter.start, buf) then
                        -- Treesitter-based indentation
                        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })

            -- Incremental selection is NATIVE in 0.12 (no plugin config)
            -- 0.12 defaults: gnn (init), grn (expand node), grm (shrink), grc (scope)
            -- Remap to your existing keys:
            vim.keymap.set("n", "<C-space>", "gnn", { remap = true, desc = "Init treesitter selection" })
            vim.keymap.set("x", "<C-CR>", "grc", { remap = true, desc = "Expand scope selection" })
            vim.keymap.set("x", "<bs>", "grm", { remap = true, desc = "Shrink node selection" })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["aa"] = { query = "@parameter.outer", desc = "Select around the parameter" },
                        ["ia"] = { query = "@parameter.inner", desc = "Select inside the parameter" },
                        ["af"] = { query = "@function.outer", desc = "Select around the function" },
                        ["if"] = { query = "@function.inner", desc = "Select inside of the function" },
                        ["ac"] = { query = "@class.outer", desc = "Select around the class" },
                        ["ic"] = { query = "@class.inner", desc = "Select inside of the class" },
                        ["al"] = { query = "@loop.outer", desc = "Select around the loop" },
                        ["il"] = { query = "@loop.inner", desc = "Select inside of the loop" },
                        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select around the scope" },
                    },
                },
                move = {
                    set_jumps = true,
                },
            })

            local move = require("nvim-treesitter-textobjects.move")

            -- goto_next_start
            vim.keymap.set({ "n", "x", "o" }, "]f", function()
                move.goto_next_start("@function.outer", "textobjects")
            end, { desc = "Goto next function start" })
            vim.keymap.set({ "n", "x", "o" }, "]o", function()
                move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
            end, { desc = "Goto next loop start" })
            vim.keymap.set({ "n", "x", "o" }, "]a", function()
                move.goto_next_start("@parameter.inner", "textobjects")
            end, { desc = "Goto next parameter" })

            -- goto_next_end
            vim.keymap.set({ "n", "x", "o" }, "]F", function()
                move.goto_next_end("@function.outer", "textobjects")
            end, { desc = "Goto next function end" })
            vim.keymap.set({ "n", "x", "o" }, "]C", function()
                move.goto_next_end("@class.outer", "textobjects")
            end, { desc = "Goto next class end" })
            vim.keymap.set({ "n", "x", "o" }, "]O", function()
                move.goto_next_end({ "@loop.inner", "@loop.outer" }, "textobjects")
            end, { desc = "Goto next loop end" })

            -- goto_previous_start
            vim.keymap.set({ "n", "x", "o" }, "[f", function()
                move.goto_previous_start("@function.outer", "textobjects")
            end, { desc = "Goto previous function start" })
            vim.keymap.set({ "n", "x", "o" }, "[o", function()
                move.goto_previous_start({ "@loop.inner", "@loop.outer" }, "textobjects")
            end, { desc = "Goto previous loop start" })
            vim.keymap.set({ "n", "x", "o" }, "[a", function()
                move.goto_previous_start("@parameter.inner", "textobjects")
            end, { desc = "Goto previous parameter" })

            -- goto_previous_end
            vim.keymap.set({ "n", "x", "o" }, "[F", function()
                move.goto_previous_end("@function.outer", "textobjects")
            end, { desc = "Goto previous function end" })
            vim.keymap.set({ "n", "x", "o" }, "[C", function()
                move.goto_previous_end("@class.outer", "textobjects")
            end, { desc = "Goto previous class end" })
            vim.keymap.set({ "n", "x", "o" }, "[O", function()
                move.goto_previous_end({ "@loop.inner", "@loop.outer" }, "textobjects")
            end, { desc = "Goto previous loop end" })
        end,
    },
}
