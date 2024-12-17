if not vim.g.vscode then
    -- Auto reload existing session
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

-- Enable spell check on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("spell_check_text_files", { clear = true }),
    pattern = { "markdown", "gitcommit", "text" },
    callback = function()
        vim.opt.spell = true
    end,
    nested = true,
})
