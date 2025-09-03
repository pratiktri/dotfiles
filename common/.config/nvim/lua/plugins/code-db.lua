return {
    {
        "kristijanhusak/vim-dadbod-ui",
        ft = { "sql", "mysql", "plsql" },
        dependencies = {
            { "tpope/vim-dadbod" },
            {
                "kristijanhusak/vim-dadbod-completion",
            },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            local data_path = vim.fn.stdpath("data")

            vim.g.db_ui_save_location = data_path .. "/db_ui"
            vim.g.db_ui_tmp_query_location = data_path .. "/db_ui/tmp"

            vim.g.db_ui_auto_execute_table_helpers = 1
            vim.g.db_ui_show_database_icon = true
            vim.g.db_ui_use_nerd_fonts = true
            vim.g.db_ui_use_nvim_notify = true
            vim.g.db_ui_execute_on_save = false

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql" },
                command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
            })
        end,
        keys = {
            { "<leader>qq", "<cmd>DBUIToggle<cr>", desc = "DB: UI Toggle" },
            { "<leader>qa", "<cmd>DBUIAddConnection<cr>", desc = "DB: Add Connection" },
            { "<leader>qf", "<cmd>DBUIFindBuffer<cr>", desc = "DB: Find Connection" },
            { "<leader>Q", "<Plug>(DBUI_ExecuteQuery)", desc = "DB: Execute Query Under Cursor" },
        },
    },
}
