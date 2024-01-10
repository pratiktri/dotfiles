-- TODO: Autocompletion is a hit and miss. Way too complicated at this point
-- TODO: Try doing LazyVim.nvim instead

-- TODO: Use nvim-lint for linting - newer thing

return {
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            -- local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- local lspconfig = require("lspconfig")
            -- lspconfig.tsserver.setup({
            --     capabilities = capabilities,
            -- })
            -- lspconfig.html.setup({
            --     capabilities = capabilities,
            -- })
            -- lspconfig.lua_ls.setup({
            --     capabilities = capabilities,
            -- })
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
        -- Spawns linters, parses their outputs & reports results via nvim.diagnostic
        "mfussenegger/nvim-lint",
        event = {
            "BufReadPre",
            "BufNewFile"
        },
        config = function()
            local lint = require("lint")
            local linters = require("lint").linters
            local linterConfig = vim.fn.stdpath("config") .. "linter_configs"

            lint.linters_by_ft = {
                json = { "jsonlint" },
                protobuf = { "buf", "codespell" },

                text = { "vale" },
                markdown = { "vale", "markdownlint" },
                rst = { "vale" },

                html = { "markuplint", "htmlhint" },

                bash = { "shellcheck", "codespell" },
                shell = { "shellcheck", "codespell" },
                lua = { "compiler", "selene", "codespell" },
                luau = { "compiler", "selene", "codespell" },

                javascript = { "eslint_d", "codespell" },
                typescript = { "eslint_d", "codespell" },
                javascriptreact = { "eslint_d", "codespell" },
                typescriptreact = { "eslint_d", "codespell" },

                python = { "pyre", "codespell" },
            }

            -- use for codespell for all except css
            for ft, _ in pairs(lint.linters_by_ft) do
                if ft ~= "css" then table.insert(lint.linters_by_ft[ft], "codespell") end
            end

            linters.codespell.args = {
                "--ignore-words",
                linterConfig .. "/codespell-ignore.txt",
                "--builtin=pratik,kumar,tripathy",
            }

            linters.shellcheck.args = {
                "--shell=bash", -- force to work with zsh
                "--format=json",
                "-",
            }

            linters.yamllint.args = {
                "--config-file",
                linterConfig .. "/yamllint.yaml",
                "--format=parsable",
                "-",
            }

            linters.markdownlint.args = {
                "--disable=no-trailing-spaces", -- not disabled in config, so it's enabled for formatting
                "--disable=no-multiple-blanks",
                "--config=" .. linterConfig .. "/markdownlint.yaml",
            }

            local lint_group = vim.api.nvim_create_augroup("lint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_group,
                callback = function ()
                    lint.try_lint()
                end,
            })

            vim.keymap.set("n", "<leader>ll", function ()
                lint.try_lint()
            end, { desc = "Lint current file" })
        end,
    },
}
