return {
    {
        "stevearc/conform.nvim",
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    javascript = { { "prettierd", "prettier" } },
                    typescript = { { "prettierd", "prettier" } },
                    javascriptreact = { { "prettierd", "prettier" } },
                    typescriptreact = { { "prettierd", "prettier" } },
                    svelte = { { "prettierd", "prettier" } },
                    css = { { "prettierd", "prettier" } },
                    html = { { "prettierd", "prettier" } },
                    json = { { "prettierd", "prettier" } },
                    graphql = { { "prettierd", "prettier" } },
                    yaml = { { "yamlfmt", "prettierd" } },
                    markdown = { { "markdownlint" } },
                    lua = { "stylua" },
                    python = { "black" },
                    sh = { { "shfmt", "shellharden" } },
                    bash = { { "shfmt", "shellharden" } },
                    zsh = { { "shfmt", "shellharden" } },
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
