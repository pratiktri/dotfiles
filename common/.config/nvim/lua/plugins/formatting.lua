return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                bash = { "shfmt" },
                sh = { "shfmt" },
                zsh = { "shfmt" },

                css = { "prettierd" },
                graphql = { "prettierd" },
                html = { "prettierd" },
                javascript = { "prettierd" },
                javascriptreact = { "prettierd" },
                json = { "prettierd" },
                jsonc = { "prettierd" },
                svelte = { "prettierd" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
                yaml = { "prettierd" },

                lua = { "stylua" },
                markdown = { "markdownlint" },
                python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
                xml = { "xmllint" },
                rust = { "rustfmt" },
                sql = { "sqruff" },

                ["_"] = { "trim_whitespace" },
            },
            format_on_save = {
                lsp_format = "fallback",
                async = false,
                timeout_ms = 1000,
            },
            formatters = {
                injected = { options = { ignore_errors = true } },
                prettierd = {
                    env = {
                        PRETTIERD_DEFAULT_CONFIG = vim.loop.os_homedir() .. "/.config/templates/.prettierrc",
                    },
                },
                shfmt = { prepend_args = { "-i", "4" } },
                markdownlint = {
                    prepend_args = {
                        "--config",
                        vim.loop.os_homedir() .. "/.config/templates/markdownlint.json",
                    },
                },
            },
        },
    },
}
