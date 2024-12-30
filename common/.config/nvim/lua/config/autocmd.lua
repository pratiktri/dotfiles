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
