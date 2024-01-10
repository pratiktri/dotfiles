return {
    "nvim-lualine/lualine.nvim",
    config = function()
        local lazy_status = require("lazy.status")

        require("lualine").setup({
            options = {
                -- theme = "horizon",
                -- TODO: Following ain't taking effect. Why?
                sections = {
                    lualine_a = {'mode','filename'},
                    lualine_b = {'branch'},
                    lualine_c = {'diff', 'diagnostics'},
                    lualine_x = { { lazy_status.updates, cond = lazy_status.has_updates } },
                    lualine_y = {'progress'},
                    lualine_z = {'location', 'searchcount'}
                },
            }
        })
    end
}
