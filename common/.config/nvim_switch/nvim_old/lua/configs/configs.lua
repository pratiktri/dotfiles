-- Load configs from VIM
local vim_configs = os.getenv("HOME") .. "/.vim/configs.vim"
if vim.loop.fs_stat(vim_configs) then
    vim.cmd("source " .. vim_configs)
end

vim.opt.undodir = vim.fn.stdpath("config") .. "/undo"
vim.opt.backupdir = vim.fn.stdpath("config") .. "/backup/"
