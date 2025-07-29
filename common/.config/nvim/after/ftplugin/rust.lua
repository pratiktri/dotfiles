if pcall(require, "rustaceanvim") then
    local bufnr = vim.api.nvim_get_current_buf()
    vim.keymap.set("n", "gC", "<cmd>RustLsp openCargo<cr>", { desc = "Open Cargo.toml", buffer = bufnr })
    vim.keymap.set("n", "<leader>rm", "<cmd>RustLsp expandMacro<cr>", { desc = "Expand Macro", buffer = bufnr })
    vim.keymap.set("n", "<leader>rp", "<cmd>RustLsp parentModule<cr>", { desc = "Parent Module", buffer = bufnr })
    vim.keymap.set("n", "<leader>rJ", "<cmd>RustLsp joinLines<cr>", { desc = "Join Lines", buffer = bufnr })
    vim.keymap.set("n", "<leader>rh", "<cmd>RustLsp openDocs<cr>", { desc = "Open docs.rs Documentation" })
    vim.keymap.set("n", "<leader>rM", "<cmd>RustLsp view mir<cr>", { desc = "View Mid-Level IR", buffer = bufnr })
    vim.keymap.set("n", "<leader>rH", "<cmd>RustLsp view hir<cr>", { desc = "View High-Level IR", buffer = bufnr })
end
