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
            local data_path = vim.fn.stdpath("data")

            vim.g.db_ui_auto_execute_table_helpers = 1
            vim.g.db_ui_save_location = data_path .. "/db_ui"
            vim.g.db_ui_show_database_icon = true
            vim.g.db_ui_tmp_query_location = data_path .. "/db_ui/tmp"
            vim.g.db_ui_use_nerd_fonts = true
            vim.g.db_ui_use_nvim_notify = true

            -- NOTE: The default behavior of auto-execution of queries on save is disabled
            -- this is useful when you have a big query that you don't want to run every time
            -- you save the file running those queries can crash neovim to run use the
            -- default keymap: <leader>S
            vim.g.db_ui_execute_on_save = false

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
            { "<leader>qq", "<cmd>DBUIToggle<cr>", desc = "DB: UI Toggle" },
            { "<leader>qa", "<cmd>DBUIAddConnection<cr>", desc = "DB: Add Connection" },
            { "<leader>qf", "<cmd>DBUIFindBuffer<cr>", desc = "DB: Find Connection" },
        },
    },

    {
        "kristijanhusak/vim-dadbod-ui",
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
        dependencies = "vim-dadbod",
        init = function() end,
    },
}
