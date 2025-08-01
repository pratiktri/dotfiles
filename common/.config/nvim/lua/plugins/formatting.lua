return {
    {
        "stevearc/conform.nvim",
        cond = require("config.util").is_not_vscode(),
        lazy = true,
        event = { "BufWritePre" },
        opts = {
            formatters_by_ft = {
                bash = { "shfmt", "shellharden", stop_after_first = true },
                css = { "prettierd", "prettier", stop_after_first = true },
                graphql = { "prettierd", "prettier", stop_after_first = true },
                html = { "prettierd", "prettier", stop_after_first = true },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                json = { "prettierd", "prettier", stop_after_first = true },
                lua = { "stylua" },
                markdown = { "markdownlint", "markdown-toc" },
                python = { "black" },
                rust = { "rustfmt" },
                sh = { "shfmt", "shellharden", stop_after_first = true },
                svelte = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                yaml = { "yamlfmt", "prettierd", stop_after_first = true },
                zsh = { "shfmt", "shellharden", stop_after_first = true },
                ["_"] = { "trim_whitespace" },
            },
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                local lsp_format_opt
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    lsp_format_opt = "never"
                else
                    lsp_format_opt = "fallback"
                end
                return {
                    quiet = false,
                    timeout_ms = 500,
                    lsp_format = lsp_format_opt,
                }
            end,
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
                ["markdown-toc"] = {
                    -- Format only if TOC present in the file
                    condition = function(_, ctx)
                        for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                            if line:find("<!%-%- toc %-%->") then
                                return true
                            end
                        end
                    end,
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
