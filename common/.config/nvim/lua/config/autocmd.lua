-- Auto reload existing session
if not vim.g.vscode then
    vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
        callback = function()
            -- If nvim started with arguments, do NOT restore
            if vim.fn.argc() ~= 0 then
                return
            end
            require("persistence").load()
        end,
        nested = true,
    })
end

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank({
            higroup = "Visual", -- Highlight group to use
            timeout = 400, -- Duration in milliseconds
            on_visual = true, -- Highlight visual selections
            on_macro = false, -- Don't highlight during macro playback
        })
    end,
})

-- New command: MasonInstallAll
vim.api.nvim_create_user_command("MasonInstallAll", function()
    vim.cmd("MasonInstall awk-language-server codelldb css-lsp docker-compose-language-service html-lsp json-lsp sqlls")
end, {})
