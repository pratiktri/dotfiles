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
            require("codeium").setup({})
        end,
    },
}
