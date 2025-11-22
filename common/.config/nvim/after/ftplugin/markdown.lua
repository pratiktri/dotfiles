require("shared.text_settings").setup()

local function check_codelens_support()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, c in ipairs(clients) do
        if c.server_capabilities.codeLensProvider then
            return true
        end
    end
    return false
end

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "LspAttach", "BufEnter" }, {
    buffer = vim.api.nvim_get_current_buf(),
    callback = function()
        if check_codelens_support() then
            vim.lsp.codelens.refresh({ bufnr = 0 })
        end
    end,
})
-- trigger codelens refresh
vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
