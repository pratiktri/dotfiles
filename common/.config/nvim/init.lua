-- TIP: General Usage and debugging Nvim hints:
-- Use `vim.print()` to printout variables
-- :lua > `require("plugin-name")` to load a plugin manually
-- To check all issues in plugins -> :checkhealth
-- To check all the keymaps -> :Telescope keymaps
-- Check all notifications -> :Notifications
-- Check past messages -> :messages
-- Select last visual selection -> gv
-- Copy visual section to a line number -> :'<,'>t15 (copies To line 15)

-- Load keymaps & options: Order matters
require("core.lazy")
require("core.lsp")
require("config.autocmd")

-- NOTE: External Tools needed for this Nvim config to work
-- jsregexp
-- rust-analyzer, rustc, cargo (rustacean)
-- OS Installs:
--      general: curl, gzip, unzip, git, fd-find, ripgrep, fzf, tree-sitter
--      tools: ImageMagick, xclip, xsel, ghostscript
--      lsp: ../../../scripts/package-list-os
-- Brew:
--      tools: lazygit
--      lsp: ../../../scripts/package-list-brew
-- MasonInstallAll to install the rest:
--      (./lua/config/autocmd.lua)
