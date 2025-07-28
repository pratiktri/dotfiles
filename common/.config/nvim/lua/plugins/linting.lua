return {
    {
        "mfussenegger/nvim-lint",
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            -- Linters are only required for dynamically typed languages
            lint.linters_by_ft = {
                python = { "pylint", "codespell" },
                markdown = { "markdownlint", "codespell" },
                yaml = { "yamllint" },
                lua = { "codespell" },
                bash = { "codespell" },
                sh = { "codespell" },
                zsh = { "codespell" },
                typescript = { "codespell" },
                javascript = { "codespell" },
                typescriptreact = { "codespell" },
                javascriptreact = { "codespell" },
                dockerfile = { "hadolint" },
                html = { "codespell" },
            }

            local markdownlint = lint.linters.markdownlint
            markdownlint.args = {
                "--config",
                "~/.config/templates/markdownlint.json",
                "--",
            }

            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
