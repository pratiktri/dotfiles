-- Load Keybindings from VIM
local vim_mappings = os.getenv("HOME") .. "/.vim/key_maps.vim"
if vim.loop.fs_stat(vim_mappings) then
    vim.cmd("source " .. vim_mappings)
end

vim.keymap.set({ "n" }, "<leader><CR>", function()
    vim.cmd("source " .. vim.fn.expand(vim.fn.stdpath("config") .. "/init.lua"))
end, { desc = "Apply NVIM config changes" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({ "n" }, "<C-c>", "<cmd> %y+ <CR>", { desc = "Copy entire content of the current buffer" })

vim.keymap.set("n", "<leader>fn", "<cmd>enew<CR>", { desc = "Create new file/buffer" })

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

-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

vim.keymap.set("i", "<C-BS>", "<C-g>u<C-w>", { desc = "Add undo breakpoint and delete last word" })
vim.keymap.set("i", ",", ",<C-g>u", { desc = "Auto add undo breakpoints on ','" })
vim.keymap.set("i", ".", ".<C-g>u", { desc = "Auto add undo breakpoints on '.'" })
vim.keymap.set("i", ";", ";<C-g>u", { desc = "Auto add undo breakpoints on ';'" })
vim.keymap.set("i", "\r", "\r<C-g>u", { desc = "Auto add undo breakpoints on new lines" })

-- Traverse Buffer
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Switch to next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Switch to previous buffer" })

-- Save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
vim.keymap.set({ "i", "x", "n", "s" }, "<C-q>", "<cmd>wqa<cr><esc>", { desc = "Save all files and Quit Neovim" })

-- Close Current Buffer
vim.keymap.set({ "n", "v" }, "<leader>xb", function()
    if vim.bo.modified then
        vim.cmd.write()
    end
    vim.cmd("bdelete")
end, { desc = "Save and close current buffer" })

-- Traverse quickfix
-- TODO: Friendly message when no quickfix
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- Clear searches
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
vim.keymap.set("n", "<leader>/", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / clear hlsearch / diff update" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
vim.keymap.set({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
vim.keymap.set({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- diagnostic: From LazyVim
local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end
vim.keymap.set("n", "<leader>dc", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Git
vim.keymap.set("n", "<leader>gg", "<Cmd>0G<cr>", { desc = "Git: Open fugitive in a new buffer" })
