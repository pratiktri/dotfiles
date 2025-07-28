-- TODO: Map all native Nvim 0.11 LSP commands to corresponding rustaceanvim ones
-- grn -> Rename
-- grr -> References
-- gri -> Implementation
-- gO -> document_symbol
-- gra -> code_action
-- Mine
-- F2 -> Rename
-- gD -> Go to definition
-- <leader>cr -> References
-- <leader>co -> document_symbol

if pcall(require, "rustaceanvim") then
    local bufnr = vim.api.nvim_get_current_buf()

    vim.keymap.set("n", "<C-.>", function()
        vim.cmd.RustLsp("codeAction")
    end, { silent = true, buffer = bufnr })

    vim.keymap.set("n", "K", function()
        vim.cmd.RustLsp({ "hover", "actions" })
    end, { silent = true, buffer = bufnr })
end
