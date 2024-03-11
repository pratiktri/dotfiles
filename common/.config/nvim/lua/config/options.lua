-- Options available as-is: VimScript,
--      Options starting with nvim_: lua
--      To set VimScript options in lua: use either vim.opt (:help vim.opt)

-- Load configs from VIM
local vim_configs = os.getenv("HOME") .. "/.vim/configs.vim"
if vim.loop.fs_stat(vim_configs) then
    vim.cmd("source " .. vim_configs)
end

vim.opt.undodir = vim.fn.stdpath("config") .. "/undo"
vim.opt.backupdir = vim.fn.stdpath("config") .. "/backup/"

vim.opt.wrap = true
vim.opt.cursorline = true
vim.opt.inccommand = "split" -- With :%s command, show the preview in a split instead of inline
vim.opt.splitkeep = "screen"
-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
