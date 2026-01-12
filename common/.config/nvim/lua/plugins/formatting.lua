return {
    {
        "stevearc/conform.nvim",
        lazy = false,
        event = { "BufWritePre" },
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

                lua = { "stylua" },
                markdown = { "markdownlint" },
                python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
                xml = { "xmllint" },
                yaml = { "yamlfmt" },

                go = { "gofmt" },
                rust = { "rustfmt" },

                ["_"] = { "trim_whitespace" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            },
            formatters = {
                injected = { options = { ignore_errors = true } },
                shfmt = { prepend_args = { "-i", "4" } },
                markdownlint = {
                    prepend_args = {
                        "--config",
                        vim.loop.os_homedir() .. "/.config/templates/markdownlint.json",
                    },
                },
                yamlfmt = {
                    prepend_args = {
                        "-formatter",
                        "include_document_start=true,retain_line_breaks_single=true",
                        "-gitignore_excludes",
                    },
                },
            },
        },
    },
}
