return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        -- Keymaps for Neotree
        vim.keymap.set("n", "<Leader>n", ":lcd %:h <BAR>:Neotree filesystem reveal left<CR>")
    end
}
