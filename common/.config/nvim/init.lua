-- TIP: General Usage and debugging Nvim hints:
-- Use `vim.print()` to printout variables
-- :lua > `require("plugin-name")` to load a plugin manually
-- To check all issues in plugins -> :checkhealth
-- To check all the keymaps -> :Telescope keymaps
-- Check all notifications -> :Notifications
-- Check past messages -> :messages

-- Load keymaps & options
require("config")

--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
    { import = "plugins" },
}, {
    lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",
    change_detection = {
        notify = false,
    },
    build = {
        warn_on_override = true,
    },
    performance = {
        rtp = {
            -- Disable some rtp plugins
            disabled_plugins = {
                "gzip",
                "matchit",
                -- "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
