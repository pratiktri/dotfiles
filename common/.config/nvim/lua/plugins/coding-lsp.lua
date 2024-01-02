-- TODO: Autocompletion is a hit and miss. Way too complicated at this point
-- TODO: Try doing LazyVim.nvim instead

return {
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require("lspconfig")
            lspconfig.tsserver.setup({
                capabilities = capabilities,
            })
            lspconfig.html.setup({
                capabilities = capabilities,
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
        end
    },
    {
        -- Provides :Mason command which installs Language Servers
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end
    },
    {
        -- Helps to auto install Language Servers by specifying them
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
        config = function()
            require("mason-lspconfig").setup({})
        end
    },
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        config = function()
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                window = {
                    documentation = cmp.config.window.bordered(),
                    completion = cmp.config.window.bordered(),
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources(
                    {
                        { name = "nvim_lsp" },
                        { name = "luasnip" },
                    },
                    {
                        { name = "buffer" },
                    }),
            })
        end
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        lazy = false,
        config = true,
    },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        lazy = false,
        dependencies = {
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip",
        },
    },
    {
        -- Injects LSP's diagnostics, code actions & formatting
        -- None-ls provides methods to add none-LSP sources to provide hooks to NeoVim
        -- It also provides helpers to start and capture output of LS-CLI applications
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- Hover
                    null_ls.builtins.hover.dictionary,

                    -- Code Actions
                    null_ls.builtins.code_actions.eslint_d,
                    null_ls.builtins.code_actions.refactoring,
                    null_ls.builtins.code_actions.shellcheck,

                    -- Formattings
                    null_ls.builtins.formatting.prettierd,
                    null_ls.builtins.formatting.beautysh,
                    null_ls.builtins.formatting.buf,
                    null_ls.builtins.formatting.cs,
                    null_ls.builtins.formatting.jq,
                    null_ls.builtins.formatting.rustfmt,

                    -- Completions
                    null_ls.builtins.completion.luasnip,
                    null_ls.builtins.completion.spell,

                    -- Diagnostics
                    null_ls.builtins.diagnostics.buf,
                    null_ls.builtins.diagnostics.eslint_d,
                    null_ls.builtins.diagnostics.jsonlint,
                    null_ls.builtins.diagnostics.luacheck,
                    null_ls.builtins.diagnostics.markdownlint,
                    null_ls.builtins.diagnostics.shellcheck,
                    null_ls.builtins.diagnostics.stylelint,
                    null_ls.builtins.diagnostics.tsc,
                }
            })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})

            vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, {})
            vim.keymap.set("n", "<leader>df", vim.lsp.buf.format, {})

            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set("n", "<leader>da", vim.lsp.buf.code_action, {})
            vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float)
            vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist)
        end
    },
}
