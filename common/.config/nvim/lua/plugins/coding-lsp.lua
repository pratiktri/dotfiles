-- This function gets run when an LSP connects to a particular buffer.
-- Define mappings specific for LSP related items.
-- It sets the mode, buffer and description for us each time.
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
end

return {
    {
        -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { "williamboman/mason.nvim", config = true },
            { "williamboman/mason-lspconfig.nvim" },

            -- Useful status updates for LSP
            { "j-hui/fidget.nvim", opts = {} },

            { "folke/neodev.nvim" },
        },
        -- WARN: DO NOT do config here
        -- That would override config from autoformat
    },

    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            -- NOTE: We configure lsp here instead of in the lspconfig's config
            -- Reason? read the warnings above

            -- Configure LSP

            -- mason-lspconfig requires that these setup functions are called in this order
            -- before setting up the servers.
            require("mason").setup()
            require("mason-lspconfig").setup()

            -- Enable the following language servers
            --  Add any additional override configuration in the following tables. They will be passed to
            --  the `settings` field of the server config. You must look up that documentation yourself.
            --
            --  If you want to override the default filetypes that your language server will attach to you can
            --  define the property 'filetypes' to the map in question.
            local servers = {
                -- clangd = {},
                -- gopls = {},
                -- pyright = {},
                -- rust_analyzer = {},
                -- tsserver = {},
                -- html = { filetypes = { 'html', 'twig', 'hbs'} },

                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        -- diagnostics = { disable = { 'missing-fields' } },
                    },
                },
            }

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            -- Ensure the servers above are installed
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(servers),
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                    })
                end,
            })
        end,
    },

    {
        "j-hui/fidget.nvim",
        opts = {
            -- Options related to LSP progress subsystem
            progress = {
                poll_rate = 1, -- How and when to poll for progress messages
                suppress_on_insert = true, -- Suppress new messages while in insert mode
                ignore_done_already = true, -- Ignore new tasks that are already complete
                ignore_empty_message = true, -- Ignore new tasks that don't contain a message
                ignore = {}, -- List of LSP servers to ignore

                -- Options related to how LSP progress messages are displayed as notifications
                display = {
                    render_limit = 1, -- How many LSP messages to show at once
                    skip_history = true, -- Whether progress notifications should be omitted from history
                },
            },

            -- Options related to notification subsystem
            notification = {
                filter = vim.log.levels.WARN, -- Minimum notifications level
            },
        },
    },
}
