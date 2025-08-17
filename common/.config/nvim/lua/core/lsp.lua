-- TIP:
-- Step 1: Install the LSP through either of the following:
--         OS Installer > Brew-linux > Mason NeoVim Plugin
-- Step 2: Append the LSP server name in the below array
vim.lsp.enable({
    "bashls",
    "cssls",
    "docker_compose_language_service",
    "dockerls",
    "html",
    "jsonls",
    "lua_ls",
    "markdownlint",
    "marksman",
    "prettier",
    "pylsp",
    "shellcheck",
    "shellharden",
    "shfmt",
    "sqlls",
    "taplo",
    "trivy",
    "ts_ls",
    "yamlls",
})

-- TIP: On new systems, install these through Mason
-- They aren't usually found on either OS installer or brew-linux
---@diagnostic disable-next-line: unused-local
local to_installed = vim.tbl_keys({
    "codelldb",
    "css-lsp",
    "docker-compose-language-service",
    "html-lsp",
    "json-lsp",
    "sqlls",
})

-- Setup native diagnostic
vim.diagnostic.config({
    underline = false,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    virtual_text = {
        enabled = true,
        severity = { min = vim.diagnostic.severity.ERROR },
    },
    -- virtual_lines = {
    --     current_line = true,
    --     severity = { min = vim.diagnostic.severity.INFO },
    -- },
})

-- Change diagnostic symbols in the sign column (gutter)
if vim.g.have_nerd_font then
    local signs = require("config.util").icons.diagnostics
    local diagnostic_signs = {}
    for type, icon in pairs(signs) do
        diagnostic_signs[vim.diagnostic.severity[type]] = icon
    end
    vim.diagnostic.config({ signs = { text = diagnostic_signs } })
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Generic Keymaps
        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("<F2>", vim.lsp.buf.rename, "Rename Symbol")
        map("<leader>cR", vim.lsp.buf.rename, "Rename Symbol")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- LspSaga
        map("<C-.>", "<cmd>Lspsaga code_action<cr>", "Code Actions")
        map("K", "<cmd>Lspsaga hover_doc<cr>", "Hover Documentation")
        map("<leader>cr", "<cmd>Lspsaga finder<cr>", "Goto References")
        map("<leader>cF", "<cmd>Lspsaga peek_definition<cr>", "Peek definition: Function")
        map("<leader>cT", "<cmd>Lspsaga peek_type_definition<cr>", "Peek definition: Type")
        map("<leader>cI", "<cmd>Lspsaga finder imp<cr>", "Peek: Implementations")
        -- e to jump to the symbol under cursor; q to quit
        map("<leader>co", "<cmd>Lspsaga outline<cr>", "Outline Panel on Left")

        -- Telescope
        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        map("<leader>cs", require("telescope.builtin").lsp_document_symbols, "Search Document Symbols")
        map("<leader>cS", require("telescope.builtin").lsp_workspace_symbols, "Search Workspace Symbols")
        map("<leader>ct", require("telescope.builtin").lsp_type_definitions, "Goto Type Definition")

        Snacks.toggle({
            name = "Diagnostics Virtual Text",
            get = function()
                return vim.diagnostic.config().virtual_text ~= false
            end,
            set = function(state)
                vim.diagnostic.config({ virtual_text = state })
            end,
        }):map("<leader>dx")

        -- Native lsp inline virtual text / inlay hints
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable(true)
            vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5c7086", bg = "NONE" })

            map("<leader>ch", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle Inlay Hints")
        end
    end,
})
