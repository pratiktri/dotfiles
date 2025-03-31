return {
    {
        "saghen/blink.compat",
        lazy = true,
        opts = {},
    },

    -- codeium
    {
        "Exafunction/codeium.nvim",
        cond = require("config.util").is_not_vscode(),
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Codeium",
        build = ":Codeium Auth",
        event = "InsertEnter",
        opts = {
            -- TODO: Get all sources.default on blink.nvim and add "codeium" to the list
            -- TODO: Get all sources.providers registered on blink.nvim and append "codeium" to it here
            enable_cmp_source = true,
            virtual_text = {
                enabled = false,
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
