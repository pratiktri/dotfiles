-- TIP: General Usage and debugging Nvim hints:
-- Use `vim.print()` to printout variables
-- :lua > `require("plugin-name")` to load a plugin manually
-- To check all issues in plugins -> :checkhealth
-- To check all the keymaps -> :Telescope keymaps
-- Check all notifications -> :Notifications
-- Check past messages -> :messages

-- TIP: Keymap structure:
-- b+: [B]buffer Operations
-- c+: [C]oding Stuff
-- d+: [D]iagnostics
-- f+: [F]ile Operations
-- g+: [G]it Operations
-- l+: [L]ist Things
-- n+: [N]eoVim Stuff
-- q+: DB [Q]ueries
-- r+: [R]efactor Things
-- s+: Grep/[S]earch Things
-- t+: [T]est runner stuff
-- x+: close/dismiss something
-- e: explorer
-- j: EasyMotion jump
-- p: Paste from system clipboard
-- y: Copy selected stuff to system clipboard
-- u: Open undo-tree side-panel
-- v: Open document symbol explorer

-- TODO:
-- Reduce noice timeout

-- Load keymaps & options
require("config")

--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
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
