-- TIP: General Usage and debugging Nvim hints:
-- Use `vim.print()` to printout variables
-- :lua > `require("plugin-name")` to load a plugin manually
-- To check all issues in plugins -> :checkhealth
-- To check all the keymaps -> :Telescope keymaps
-- Check all notifications -> :Notifications
-- Check past messages -> :messages
-- Select last visual selection -> gv
-- Copy visual section to a line number -> :'<,'>t15 (copies To line 15)

-- Load keymaps & options
-- Order matters
require("config.options")
require("config.keymaps")
require("core.lazy")
require("core.lsp")
require("config.filetype-based-keymaps")
require("config.autocmd")
