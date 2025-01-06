-- Enable keymaps that are specific to only a certain LSP
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("keymaps-javascript", { clear = true }),
    pattern = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
    callback = function()
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

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("markdown-keymaps", { clear = true }),
    pattern = { "markdown", "gitcommit", "text" },
    callback = function()
        vim.keymap.set("v", "<leader>ml", function()
            -- Save visually selected text to register 'v'
            vim.cmd('normal! "vy')
            -- Delete the selected text
            vim.cmd("normal! gvd")
            -- Get the content of the system clipboard
            local clipboard_content = vim.fn.getreg("+")
            -- Insert the markdown link
            local link = string.format("[%s](%s)", vim.fn.getreg("v"), clipboard_content)
            vim.api.nvim_put({ link }, "c", false, true)
            -- Move cursor inside the square brackets
            vim.cmd("normal! F[l")
        end, { desc = "Markdown: Make link" })
    end,
    nested = true,
})
