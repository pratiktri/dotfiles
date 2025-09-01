-- Load configs from VIM
local sep = package.config:sub(1, 1)
local home = os.getenv("HOME") or os.getenv("USERPROFILE")
local vim_configs = home .. sep .. ".vim" .. sep .. "configs.vim"
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

vim.g.have_nerd_font = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
