-- Load Keybindings from VIM
local sep = package.config:sub(1, 1)
local vim_mappings = vim.loop.os_homedir() .. sep .. ".vim" .. sep .. "key_maps.vim"
if vim.loop.fs_stat(vim_mappings) then
    vim.cmd("source " .. vim_mappings)
end

vim.keymap.set({ "n" }, "<C-,>", "<cmd>edit " .. vim.fn.expand(vim.fn.stdpath("config")) .. sep .. "init.lua<cr>", { desc = "open neovim config" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- Remap for dealing with word wrap
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Auto add undo breakpoints at different points, while typing
vim.keymap.set("i", "<C-BS>", "<C-g>u<C-w>", { desc = "Add undo breakpoint and delete last word" })
vim.keymap.set("i", ",", ",<C-g>u", { desc = "Auto add undo breakpoints on ','" })
vim.keymap.set("i", ".", ".<C-g>u", { desc = "Auto add undo breakpoints on '.'" })
vim.keymap.set("i", ";", ";<C-g>u", { desc = "Auto add undo breakpoints on ';'" })
vim.keymap.set("i", "\r", "\r<C-g>u", { desc = "Auto add undo breakpoints on new lines" })

-- Save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
vim.keymap.set({ "i", "x", "n", "s" }, "<C-q>", "<cmd>wqa<cr><esc>", { desc = "Save all files and Quit Neovim" })

-- Close Current Buffer
vim.keymap.set({ "n", "v" }, "<leader>bx", function()
    if vim.bo.modified then
        vim.cmd.write()
    end
    vim.cmd("bdelete")
end, { desc = "Save and close current buffer" })
vim.keymap.set({ "n", "v" }, "<leader>xb", function()
    if vim.bo.modified then
        vim.cmd.write()
    end
    vim.cmd("bdelete")
end, { desc = "Save and close current buffer" })

vim.keymap.set("n", "<leader>xt", "<cmd>tabclose<cr>", { desc = "Close current tab" })

-- Clear searches
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
vim.keymap.set({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
vim.keymap.set({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
        vim.cmd("normal! zz")
    end
end
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>zz", { desc = "Quickfix: Next" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>zz", { desc = "Quickfix: Previous" })
vim.keymap.set("n", "<leader>cq", function()
    vim.diagnostic.setqflist()
end, { desc = "Project Diagnostics -> Quickfix" })

-- Center cursor
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
