-- Load configs from nvim/lua/config/options.vim (shared vimscript configs)
local sep = package.config:sub(1, 1)
vim.cmd("source " .. vim.fn.stdpath("config") .. sep .. "lua" .. sep .. "config" .. sep .. "options.vim")

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

-- WARN: Hides all nvim-navbuddy deprecation warnings
---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end
