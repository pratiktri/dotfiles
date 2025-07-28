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
    "pylsp",
    "sqlls",
    "ts_ls",
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
    virtual_lines = {
        current_line = true,
        severity = { min = vim.diagnostic.severity.INFO },
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

        -- Setup native LSP completion
        -- This is already done by blink, but better prefer the builtin one
        if client:supports_method("textDocument/completion") then
            vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
            vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
            vim.keymap.set("i", "<C-Space>", function()
                vim.lsp.completion.get()
            end)
        end

        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("<F2>", vim.lsp.buf.rename, "Rename Symbol")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("<leader>nf", function()
            vim.fn.setreg("+", vim.fn.expand("%:p"))
            print("Copied: " .. vim.fn.expand("%:p") .. " to + register")
        end, "Copy current [F]ile path to register")

        -- LspSaga
        map("<C-.>", "<cmd>Lspsaga code_action<cr>", "Code Actions")
        map("<leader>cr", "<cmd>Lspsaga finder<cr>", "Goto References")
        map("<leader>cpf", "<cmd>Lspsaga peek_definition<cr>", "Peek definition: Function")
        map("<leader>cpt", "<cmd>Lspsaga peek_type_definition<cr>", "Peek definition: Class")
        map("<leader>cpi", "<cmd>Lspsaga finder imp<cr>", "Peek: Implementations")
        -- e to jump to the symbol under cursor; q to quit
        map("<leader>co", "<cmd>Lspsaga outline<cr>", "Outline Panel on Left")

        -- Telescope
        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        map("<leader>cs", require("telescope.builtin").lsp_document_symbols, "Search Document Symbols")
        map("<leader>cS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Search Workspace Symbols")
        map("<leader>ct", require("telescope.builtin").lsp_type_definitions, "Goto Type Definition")
        map("<leader>cd", require("telescope.builtin").diagnostics, "List Diagnostics")

        -- The following two autocommands are used to highlight references of the
        -- word under cursor when cursor rests there for a little while.
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                end,
            })
        end

        -- Native lsp inline virtual text / inlay hints
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable() -- enabled by default

            map("<leader>cI", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle Inlay Hints")
        end
    end,
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

vim.diagnostic.config({
    virtual_text = {
        enabled = true,
        spacing = 5,
        severity = { min = vim.diagnostic.severity.ERROR },
    },
    virtual_lines = {
        current_line = true,
        severity = { min = vim.diagnostic.severity.INFO },
    },
})
