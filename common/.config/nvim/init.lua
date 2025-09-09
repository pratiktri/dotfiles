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
require("config.options")
require("config.keymaps")
require("core.lazy")
require("core.lsp")
require("config.autocmd")

-- NOTE: External Tools needed for this Nvim config to work
-- jsregexp
-- rust-analyzer, rustc, cargo (rustacean)
-- OS Installs: Use ../../../scripts/install.sh
--      general: curl, gzip, unzip, git, fd-find, ripgrep, fzf, tree-sitter
--      tools: ImageMagick, xclip, xsel, ghostscript
--      lsp: codespell, nodejs-bash-language-server, hadolint, lua, luajit, shellcheck, shfmt, trivy, pylint, stylua
-- Brew:
--      tools: lazygit
--      lsp: dockerfile-language-server, markdown-toc, markdownlint-cli, marksman, prettier, prettierd, python-lsp-server,
--           shellharden, taplo, typescript-language-server, vue-language-server, yaml-language-server, yamlfmt
-- Mason: When they aren't found on OS or Brew
--      codelldb, css-lsp, docker-compose-language-service, html-lsp, json-lsp, sqlls
