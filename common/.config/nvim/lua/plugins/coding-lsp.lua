return {
    -- TODO: Configure following plugins in separate files

    -- LSP Configuration
    {
        -- Provides :Mason command which installs Language Servers
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        -- Helps to auto install Language Servers by specifying them
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls", "bashls", "cssls", "dockerls", "emmet_ls", "jsonls", "tsserver", "marksman",
                    "pyre", "rust_analyzer", "sqlls", "taplo"
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- Hook up NVIM with the above installed Language Servers
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.bashls.setup({})
            lspconfig.cssls.setup({})
            lspconfig.dockerls.setup({})
            lspconfig.emmet_ls.setup({})
            lspconfig.jsonls.setup({})
            lspconfig.tsserver.setup({})
            lspconfig.marksman.setup({})
            lspconfig.pyre.setup({})
            lspconfig.rust_analyzer.setup({})
            lspconfig.sqlls.setup({})
            lspconfig.taplo.setup({})

            -- LSP Keybindings
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
            -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {})
            vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, {})
            vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, {})
            vim.keymap.set('n', '<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, {})
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, {})
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
            vim.keymap.set('n', '<leader>f', function()
                vim.lsp.buf.format { async = true }
            end, {})
        end
    },

    -- None-ls
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    -- TODO: Segement these by language & Install required ones through :Mason
                    -- null_ls.builtins.formatting.stylua,
                    -- null_ls.builtins.formatting.beautysh,
                    -- null_ls.builtins.formatting.csharpier,
                    -- null_ls.builtins.formatting.jq,
                    -- null_ls.builtins.formatting.markdownlint_toc,
                    -- null_ls.builtins.formatting.nginx_beautifier,
                    -- null_ls.builtins.formatting.pg_format,
                    -- null_ls.builtins.formatting.prettierd,
                    -- null_ls.builtins.formatting.protolint,
                    -- null_ls.builtins.formatting.rustfmt,
                    -- null_ls.builtins.formatting.shellharden,
                    -- null_ls.builtins.formatting.shfmt,

                    -- null_ls.builtins.diagnostics.alex,
                    -- null_ls.builtins.diagnostics.codespell,
                    -- null_ls.builtins.diagnostics.eslint_d,
                    -- null_ls.builtins.diagnostics.jsonlint,
                    -- null_ls.builtins.diagnostics.luacheck,
                    -- null_ls.builtins.diagnostics.protolint,
                    -- null_ls.builtins.diagnostics.shellcheck,
                    -- null_ls.builtins.diagnostics.stylelint,
                    -- null_ls.builtins.diagnostics.tidy,
                    -- null_ls.builtins.diagnostics.tsc,
                    -- null_ls.builtins.diagnostics.vlint,
                    -- null_ls.builtins.diagnostics.yamllint,

                    -- null_ls.builtins.code_actions.gitsigns,
                    -- null_ls.builtins.code_actions.eslint_d,
                    -- null_ls.builtins.code_actions.refactoring,
                    -- null_ls.builtins.code_actions.shellcheck,

                    -- null_ls.builtins.completion.spell,
                    -- null_ls.builtins.completion.tags,
                    -- null_ls.builtins.completion.luasnip,
                }
            })

            vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
        end
    },

}
