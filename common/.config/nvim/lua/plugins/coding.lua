return {

    -- FIX: Vale (markdown linter) isn't working
    -- TODO: Configure the linter

    -- Treesitter is a parser generator tool that we can use for syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        keys = {
            { "<C-Space>", desc = "Increment selection" },
            { "<C-CR>", desc = "Increment scope selection" },
            { "<bs>", desc = "Decrement selection", mode = "x" },
        },
        ---@type TSConfig
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            auto_install = true,
            -- stylua: ignore
            ensure_installed = {
                "lua", "luadoc", "luap", "vim", "vimdoc",
                "diff","query", "regex", "toml", "yaml",
                "c", "python", "bash",
                "markdown", "markdown_inline",
                "html", "javascript", "jsdoc", "json", "jsonc", "tsx", "typescript",
            },
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
                -- stylua: ignore
                -- Defaults(not mentioned below): Select text objects (similar to ip & ap)
                    -- af: Selects around current function
                    -- if: Selects inside current function
                    -- ac: around current Class
                    -- ic: inside current Class
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
            },
        },
    },

    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
        -- lazy = false,
        opts = {
            -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
            -- Be aware that you also will need to properly configure your LSP server to
            -- provide the inlay hints.
            inlay_hints = {
                enabled = true,
            },
            -- add any global capabilities here
            capabilities = {},
            -- options for vim.lsp.buf.format
            -- `bufnr` and `filter` is handled by the LazyVim formatter,
            -- but can be also overridden when specified
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            -- LSP Server Settings
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
                tsserver = {
                    keys = {
                        {
                            "<leader>co",
                            function()
                                vim.lsp.buf.code_action({
                                    apply = true,
                                    context = {
                                        only = { "source.organizeImports.ts" },
                                        diagnostics = {},
                                    },
                                })
                            end,
                            desc = "Organize Imports",
                        },
                        {
                            "<leader>cR",
                            function()
                                vim.lsp.buf.code_action({
                                    apply = true,
                                    context = {
                                        only = { "source.removeUnused.ts" },
                                        diagnostics = {},
                                    },
                                })
                            end,
                            desc = "Remove Unused Imports",
                        },
                    },
                    settings = {
                        typescript = {
                            format = {},
                        },
                        javascript = {
                            format = {},
                        },
                        completions = {
                            completeFunctionCalls = true,
                        },
                    },
                },
            },
        },
    },

    -- Linting
    {
        "mfussenegger/nvim-lint",
        lazy = false,
        opts = {
            -- Event to trigger linters
            events = { "BufWritePost", "BufReadPost", "InsertLeave" },
            linters_by_ft = {
                fish = { "fish" },
                -- Use the "*" filetype to run linters on all filetypes.
                -- ['*'] = { 'global linter' },
                -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
                -- ['_'] = { 'fallback linter' },
            },
            -- LazyVim extension to easily override linter options
            -- or add custom linters.
            ---@type table<string,table>
            linters = {
                -- -- Example of using selene only when a selene.toml file is present
                -- selene = {
                --   -- `condition` is another LazyVim extension that allows you to
                --   -- dynamically enable/disable linters based on the context.
                --   condition = function(ctx)
                --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
                --   end,
                -- },
            },
        },
    },

    -- Mason configuration
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "prettier",
                "js-debug-adapter",
                "eslint-lsp",
                "json-lsp",
                "typescript-language-server",
                "codelldb",
                "rust-analyzer",
                "yaml-language-server",
                "black",
                "csharpier",
                "omnisharp",
                "stylua",
                "lua-language-server",
                "shfmt",
                "pyright",
                "hadolint",
                "docker-compose-language-service",
                "dockerfile-language-server",
                "vale",
                "vale-ls",
                "markdownlint",
                "marksman",
                "taplo",
            },
        },
    },
    { "williamboman/mason-lspconfig.nvim" },

    -- Formatter
    {
        "nvimtools/none-ls.nvim",
        lazy = false,
        opts = function(_, opts)
            local nls = require("null-ls")
            opts.root_dir = opts.root_dir
                or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
            opts.sources = vim.list_extend(opts.sources or {}, {
                nls.builtins.formatting.fish_indent,
                nls.builtins.diagnostics.fish,
                nls.builtins.formatting.stylua,
                nls.builtins.formatting.shfmt,
                nls.builtins.formatting.eslint_d,
                nls.builtins.formatting.black,
                nls.builtins.formatting.prettierd,
            })
        end,
    },

    -- Auto pairs
    { "echasnovski/mini.pairs" },

    -- Automatically add closing tags for HTML and JSX
    { "windwp/nvim-ts-autotag" },

    -- Surround things
    { "tpope/vim-surround" },
    -- Tpope one(above) is more predictable
    { "echasnovski/mini.surround", enabled = false },

    -- Comments
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    { "echasnovski/mini.comment" },

    -- Better text-objects
    {
        -- Extends a & i with the following:
        -- a/i <space>: around/inside continuous Whitespace
        -- a/i ": around/inside double quotes
        -- a/i ': around/inside single quotes
        -- a/i `: around/inside backticks
        -- a/i q: around/inside any 2 quotes of any kind (`, ', ")

        -- a/i (: around/inside braces - does NOT include spaces around
        -- a/i ): around/inside braces - DOES include spaces around
        -- a/i ]/[
        -- a/i }/{
        -- a/i b: around/inside any 2 braces of any kind (), ], }) - NOT including spaces around

        -- a/i >: around/inside tags - does NOT include spaces
        -- a/i <: around/inside tags - DOES include spaces
        -- a/i t: around/inside 2 tags of any kind

        -- a/i _: around/inside 2 Underscores

        -- a/i a: around/inside function arguments
        -- a/i f: around/inside Function
        -- a/i c: around/inside class
        -- a/i o: around/inside any block of code (conditional, loop, etc.)
        "echasnovski/mini.ai",
    },

    -- Indent guides for Neovim
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = { scope = { enabled = true } },
    },

    -- This highlights the current level of indentation and animates the highlighting
    { "echasnovski/mini.indentscope" },

    -- Navic does a much better job without taking any screen space
    { "nvim-treesitter/nvim-treesitter-context", enabled = false },
    -- VSCode like breadcrumbs in lualine
    { "SmiteshP/nvim-navic" },

    -- Shows symbols in the current window on a vsplit on left
    {
        "simrat39/symbols-outline.nvim",
        keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    },
}
