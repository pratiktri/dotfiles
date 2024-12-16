local function db_completion()
    require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
end

return {
    {
        "tpope/vim-dadbod",
        cond = require("config.util").is_not_vscode(),
        opt = true,
        dependencies = {
            { "kristijanhusak/vim-dadbod-ui" },
            { "kristijanhusak/vim-dadbod-completion" },
        },
        config = function()
            vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"
            vim.g.db_ui_use_nerd_fonts = 1

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "sql",
                },
                command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "sql",
                    "mysql",
                    "plsql",
                },
                callback = function()
                    vim.schedule(db_completion)
                end,
            })
        end,
        keys = {
            { "<leader>qq", desc = "DB: UI" },
            { "<leader>qq", "<cmd>DBUIToggle<cr>",        desc = "DB: UI Toggle" },
            { "<leader>qa", "<cmd>DBUIAddConnection<cr>", desc = "DB: Add Connection" },
            { "<leader>qf", "<cmd>DBUIFindBuffer<cr>",    desc = "DB: Find Connection" },
        },
    },
}
