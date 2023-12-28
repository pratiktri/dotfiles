-- <Ctrl-Alt-s> -> to save all files
vim.keymap.set({ "n", "i", "v" }, "<C-M-s>", "<cmd>wa<CR>", {})
-- <Ctrl-q> -> Save all files and quit Nvim
vim.keymap.set({ "n", "i", "v" }, "<C-q>", "<cmd>wqa<CR>", {})

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

