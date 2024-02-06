return {
    {
        -- nvim-treesitter provides parsers for individual languages
        -- Output of these parses are fed to the NVIM's native treesitter(vim.treesitter)
        -- What is fed to the native treesitter is essentially the AST
        -- This AST is then used for syntax-highlighting and many other operations on the code
        -- Hence, this plugin is only to make installing parsers easier

        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treeitter** module to be loaded in time.
            -- Luckily, the only thing that those plugins need are the custom queries, which we make available
            -- during startup.
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            config = function()
                -- When in diff mode, we want to use the default
                -- vim text objects c & C instead of the treesitter ones.
                local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
                local configs = require("nvim-treesitter.configs")
                for name, fn in pairs(move) do
                    if name:find("goto") == 1 then
                        move[name] = function(q, ...)
                            if vim.wo.diff then
                                local config = configs.get_module("textobjects.move")
                                    [name] ---@type table<string,string>
                                for key, query in pairs(config or {}) do
                                    if q == query and key:find("[%]%[][cC]") then
                                        vim.cmd("normal! " .. key)
                                        return
                                    end
                                end
                            end
                            return fn(q, ...)
                        end
                    end
                end
            end,
        },

        config = function()
            -- See `:help nvim-treesitter`
            -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
            vim.defer_fn(function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = {
                        -- These 2 are required for cmdline
                        "regex",
                        "markdown",
                        "markdown_inline",
                    },

                    auto_install = true,
                    highlight = { enable = true },
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
                            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                            keymaps = {
                                -- You can use the capture groups defined in textobjects.scm (:TSEditQuery textobjects)
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
                            enable = true,
                            goto_next_start = {
                                ["]f"] = { query = "@function.outer", desc = "Goto next inner function start" },
                                ["]c"] = { query = "@class.outer", desc = "Goto next inner class start" },
                            },
                            goto_next_end = {
                                ["]F"] = { query = "@function.outer", desc = "Goto next outer function end" },
                                ["]C"] = { query = "@class.outer", desc = "Goto next outer class end" },
                            },
                            goto_previous_start = {
                                ["[f"] = { query = "@function.outer", desc = "Goto goto previous inner function start" },
                                ["[c"] = { query = "@class.outer", desc = "Previous inner class start" },
                            },
                            goto_previous_end = {
                                ["[F"] = { query = "@function.outer", desc = "Goto goto previous outer function start" },
                                ["[C"] = { query = "@class.outer", desc = "Goto previous outer class start" },
                            },
                        },

                        lsp_interop = {
                            enable = true,
                            border = "none",
                            floating_preview_opts = {},
                            peek_definition_code = {
                                -- TIP: Press the shortcut 2 times to enter the floating window
                                ["<leader>cd"] = { query = "@function.outer", desc = "Peek function definition on a popup" },
                                ["<leader>cD"] = { query = "@class.outer", desc = "Peek class definition on a popup" },
                            },
                        },
                    },
                })
            end, 0)
        end,
    },
}
