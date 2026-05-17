-- TIP: Setup a new LSP:
-- Step 1: Install the LSP through:
--         OS Installer > Brew-linux > :MasonInstall
-- Step 2: Append the LSP server name in the below array ("new-lsp") (not linter or formatter)
-- Step 3: If you have special configuration for the lsp add those to ("new-lsp.lua") in ../../lsp/
-- Step 4: Return a lua table containing required lsp config in it
-- NOTE: Only LSPs here, NOT linter or formatter
vim.lsp.enable({
    "awk_ls",
    "basedpyright",
    "bashls",
    "cssls",
    "docker_compose_language_service",
    "dockerls",
    "html",
    "jsonls",
    "lua_ls",
    "markdown_oxide",
    "marksman",
    "pylsp",
    "sqlls",
    "systemd_lsp",
    "taplo",
    "ts_ls",
    "yamlls",
})

-- Setup native diagnostic
vim.diagnostic.config({
    underline = true,
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
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")

        -- LspSaga
        map("<C-.>", "<cmd>Lspsaga code_action<cr>", "Code Actions")
        map("<leader>co", "<cmd>Lspsaga outline<cr>", "Open Symbol Outline Panel on Left")

        -- Snacks
        map("<leader>cr", function()
            Snacks.picker.lsp_references()
        end, "Goto References")
        map("gI", function()
            Snacks.picker.lsp_implementations()
        end, "Goto Implementation")
        map("<leader>cI", function()
            Snacks.picker.lsp_implementations()
        end, "Goto Implementation")
        map("<leader>s", function()
            Snacks.picker.lsp_symbols()
        end, "Search Document Symbols")
        map("<leader>S", function()
            Snacks.picker.lsp_workspace_symbols()
        end, "Search Workspace Symbols")
        map("<leader>ct", function()
            Snacks.picker.lsp_type_definitions()
        end, "Goto Type Definition")
        map("<leader>L", function()
            Snacks.picker.lsp_config()
        end, "Check all LSP configurations")

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
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable(true)
            vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5c7086", bg = "NONE" })

            map("<leader>ch", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle Inlay Hints")
        end
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspCodeLens", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.codeLensProvider then
            vim.lsp.codelens.enable(true)
        end
    end,
})
