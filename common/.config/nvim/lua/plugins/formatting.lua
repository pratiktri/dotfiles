return {
    {
        "stevearc/conform.nvim",
        lazy = true,
        event = { "BufWritePre" },
        opts = {
            formatters_by_ft = {
                sh = { "shfmt" },
                bash = { "shfmt" },
                zsh = { "shfmt" },

                graphql = { "prettierd" },
                css = { "prettierd" },
                html = { "prettierd" },
                javascript = { "prettierd" },
                javascriptreact = { "prettierd" },
                svelte = { "prettierd" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
                json = { "prettierd" },

                lua = { "stylua" },
                markdown = { "markdownlint" },
                python = { "black" },
                rust = { "rustfmt" },
                yaml = { "yamlfmt" },

                ["_"] = { "trim_whitespace" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
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
