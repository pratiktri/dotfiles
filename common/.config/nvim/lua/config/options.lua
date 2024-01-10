-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Load configs from VIM
local vim_configs = os.getenv("HOME") .. "/.vim/configs.vim"
if vim.loop.fs_stat(vim_configs) then
    vim.cmd("source " .. vim_configs)
end

vim.opt.undodir = vim.fn.stdpath("config") .. "/undo"
vim.opt.backupdir = vim.fn.stdpath("config") .. "/backup/"

vim.opt.wrap = true
vim.opt.cursorline = true
