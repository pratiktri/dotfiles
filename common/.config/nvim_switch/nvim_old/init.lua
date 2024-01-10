-- TODO: Git: Add a plugin
-- TODO: System install and setup lazygit
-- TODO: Setup auto complete
-- TODO: Provide description to each keymap
-- TODO: tpope/vim-obsession configure to work with tmux-resurrection
-- TODO: Check why Nvim can't find todos
-- TODO: Put all plugin configs inside /after/plugin directory

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
		notify = false,
	},
})

require("configs.autocommands")
require("configs.configs")
require("configs.keymaps")
