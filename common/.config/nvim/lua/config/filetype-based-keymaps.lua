-- Enable keymaps that are specific to only a certain LSP
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("keymaps-javascript", { clear = true }),
    pattern = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
    callback = function()
        -- vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>OmniSharpGetCodeActions<CR>", { desc = "Code: Code Actions  (C#)" })
        vim.keymap.set({ "n", "v" }, "<leader>co", function()
            vim.lsp.buf.code_action({
                apply = true,
                context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {},
                },
            })
        end, { desc = "Code: Typescript: Organize Imports" })
        vim.keymap.set({ "n", "v" }, "<leader>cO", function()
            vim.lsp.buf.code_action({
                apply = true,
                context = {
                    only = { "source.removeUnused.ts" },
                    diagnostics = {},
                },
            })
        end, { desc = "Code: Typescript: Remove Unused Imports" })
    end,
    nested = true,
})

-- Enable spell check on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("spell_check_text_files", { clear = true }),
    pattern = { "markdown", "gitcommit", "text" },
    callback = function()
        vim.opt.spell = true
    end,
    nested = true,
})
