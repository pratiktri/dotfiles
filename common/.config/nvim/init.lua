-- TODO: Todo-Comments: Highlight TODOs
-- TODO: Neo-Tree: reduce size, hidden visible by default, set vcs root at pwd+cwd
-- TODO: Telescope: open in a new window -> vertial & horizontal
-- TODO: LSPConfig: Standardize keymaps to <leader>d[x]
-- TODO: Note what exactly Treesitter does???

-- Loads the system's Vim configs: keeps the VIM & NVim configs in sync
local vimrc = vim.fn.stdpath("config") .. "/vim-sync.vim"
if vim.loop.fs_stat(vimrc) then
    vim.cmd("source " .. vimrc)
end

-- Setup Lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
    change_detection = {
        enabled = true,
        notify = false
    }
})
