return {
    {
        "stevearc/conform.nvim",
        -- cond = require("config.util").is_not_vscode(),
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    typescript = { "prettierd", "prettier", stop_after_first = true },
                    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                    svelte = { "prettierd", "prettier", stop_after_first = true },
                    css = { "prettierd", "prettier", stop_after_first = true },
                    html = { "prettierd", "prettier", stop_after_first = true },
                    json = { "prettierd", "prettier", stop_after_first = true },
                    graphql = { "prettierd", "prettier", stop_after_first = true },
                    yaml = { "yamlfmt", "prettierd", stop_after_first = true },
                    markdown = { "markdownlint" },
                    lua = { "stylua" },
                    python = { "black" },
                    sh = { "shfmt", "shellharden", stop_after_first = true },
                    bash = { "shfmt", "shellharden", stop_after_first = true },
                    zsh = { "shfmt", "shellharden", stop_after_first = true },
                    ["_"] = { "trim_whitespace" },
                },
                format_on_save = {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 3000,
                    quiet = false,
                },
                formatters = {
                    injected = { options = { ignore_errors = true } },
                    shfmt = {
                        prepend_args = { "-i", "4" },
                    },
                    markdownlint = {
                        prepend_args = {
                            "--config",
                            "~/.config/templates/markdownlint.json",
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
            })
        end,
    },
}
