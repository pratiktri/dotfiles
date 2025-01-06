return {
    -- codeium
    {
        "Exafunction/codeium.nvim",
        cond = require("config.util").is_not_vscode(),
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "saghen/blink.compat",
                opts = function()
                    -- Do NOT use if codeium is not loaded
                    local codeium_loaded, _ = pcall(require, "codeium")
                    if not codeium_loaded then
                        return {}
                    end
                    return {
                        enable_events = true,
                        sources = {
                            providers = {
                                codeium = {
                                    name = "codeium",
                                    module = "blink.compat.source",
                                    score_offset = 1200,
                                    async = true,
                                },
                            },
                        },
                    }
                end,
            },
        },
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
