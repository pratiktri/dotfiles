return {
    -- codeium
    {
        "Exafunction/codeium.nvim",
        cond = require("config.util").is_not_vscode(),
        cmd = "Codeium",
        build = ":Codeium Auth",
        event = "InsertEnter",
        opts = {
            enable_cmp_source = vim.g.ai_cmp,
            virtual_text = {
                enabled = not vim.g.ai_cmp,
                key_bindings = {
                    accept = false, -- handled by nvim-cmp / blink.cmp
                    next = "<M-]>",
                    prev = "<M-[>",
                },
            },
        },
        config = function()
            -- Setup basic configuration
            require("codeium").setup({})

            vim.keymap.set("n", "<leader>aa", function()
                vim.cmd("Codeium Enable")
                vim.notify("Codeium enabled", vim.log.levels.INFO)
            end, { desc = "Enable Codeium" })

            vim.keymap.set("n", "<leader>ax", function()
                vim.cmd("Codeium Disable")
                vim.notify("Codeium disabled", vim.log.levels.INFO)
            end, { desc = "Disable Codeium" })
        end,
    },
}
