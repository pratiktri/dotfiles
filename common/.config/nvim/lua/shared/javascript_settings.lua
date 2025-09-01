-- Used in:
-- ../../after/ftplugin/javascript.jsx.lua
-- ../../after/ftplugin/javascript.lua
-- ../../after/ftplugin/javascriptreact.lua
-- ../../after/ftplugin/typescript.jsx.lua
-- ../../after/ftplugin/typescript.lua
-- ../../after/ftplugin/typescriptreact.lua
-- ../../after/ftplugin/vue.lua

local M = {}

function M.setup()
    vim.keymap.set({ "n", "v" }, "<leader>co", function()
        vim.lsp.buf.code_action({
            apply = true,
            context = {
                only = { "source.organizeimports.ts" },
                diagnostics = {},
            },
        })
    end, { desc = "Typescript: organize imports" })
    vim.keymap.set({ "n", "v" }, "<leader>co", function()
        vim.lsp.buf.code_action({
            apply = true,
            context = {
                only = { "source.removeunused.ts" },
                diagnostics = {},
            },
        })
    end, { desc = "Typescript: remove unused imports" })
end

return M
