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
                    yaml = { { "prettierd", "prettier" } },
                    markdown = { { "prettierd", "prettier" } },
                    graphql = { { "prettierd", "prettier" } },
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
                    timeout_ms = 1000,
                },
                formatters = {
                    shfmt = {
                        prepend_args = { "-i", "4" },
                    },
                },
            })

            vim.keymap.set({ "n", "v" }, "<leader>cf", function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                })
            end, { desc = "[C]ode [F]ormat (visual selection)" })
        end,
    },
}
