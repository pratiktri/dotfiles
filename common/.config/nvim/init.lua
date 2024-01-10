-- General Usage and debugging Nvim hints ---------------------------
-- Use `vim.print()` to printout some variable
-- :lua > `require("plugin-name")` to load a plugin manually
-- To check all issues in plugins -> :checkhealth
-- To remove a keymaps -> `vim.keymap.del("n", "<leader>someth")`
-- To override plugin's keymap -> inside "/lua/plugins" create a file > refer to the plugin > change whatever you want in the plugins. cmd, event, ft, keys, opts, dependencies properties are merged. All other properties are overridden. But if any property takes a function -> it'll always be overridden.
-- To remove/disable a plugin - in the above step add `enabled = false` property.
-- Show diff: 2 splits with the files -> :windo diffthis. To exit -> :windo diffoff

-- NOTE: To check all the keymaps -> :Telescope keymaps
-- NOTE: Check all notifications -> :Notifications

-- NOTE: For autoformatting language:
-- 1. Add to :Mason ensure_installed,
-- 2. Add to null-ls sources,
-- 3. Add to conform's formatter_by_ft list.

-- NOTE: For supporting a language LSP:
-- 1. Add to treesitter ensure_installed,
-- 2. Add to :Mason ensure_installed,
-- 3. Add to none-ls sources,
-- 4. Add to nvim-lint's linters_by_ft list,
-- 5. Add to nvim-lspconfig's servers

---------------------------------------------------------------------
---------------------------TODO Items--------------------------------
---------------------------------------------------------------------
-- Editor
-- TODO: Telescope: search hidden folders (except .git/.idea/.vscode/node_modules etc.)
-- TODO: Telescope: Map opening selected file in different splits/tabs
-- FIXIT: nvim-lsp: Reduce LSP update progress messages-> opts.lsp.progress{}
-- FIXIT: Disable which-key prompts for 'd' - way too much distraction
-- FIXIT: Remove padding from bottom (below lualine) & right border

-- Coding General
-- FIXIT: LSP suggestions hides the line being edited
-- Keymap to close LSP hints?
-- FIXIT: ys commands do not work - some paste thing is overriding it

-- FIXIT: SymbolsOutline doesn't work sometimes
-- TODO: Which file installs mason?
-- TODO: Configure following:
-- 1. coding-json.lua,
-- 2. coding-markdown.lua,
-- 4. coding-python.lua (+black),
-- 5. coding-rust.lua
-- TODO: Have inline hints - rust-tools + https://github.com/simrat39/inlay-hints.nvim
-- Test autocomplete on Rust projects
-- 6. coding-tailwind.lua,
-- 7. coding-typescript.lua (+eslint+prettier),
-- TODO: Typescript - LSP integration - not being attached right now
-- Test autocomplete on Typescript projects
-- 8. coding-yaml.lua,
-- 9. coding-docker.lua
-- TODO: null-ls + dap + nlua + neotest in coding.lua

-- Coding Rust
-- TODO: Rust debugging

-- General
-- TODO: Create Ulauncher plugin for reading/searching/quickaccess saved sessions
-- This needs to open the session in desired terminal app
-- TODO: fzf scipt to show pop-up of all saved sessions on nvim <tab>

-- TODO: Figure out how to quickly stop all code suggestions & completions

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
