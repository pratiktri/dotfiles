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

    nmap("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
    nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
    nmap("<C-.>", vim.lsp.buf.code_action, "Code Action: VSCode Style")
    -- See `:help K` for why this keymap
    -- nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    -- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("<leader>cS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Search Workspace Symbols")
    nmap("<leader>clf", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "Workspace List Folders")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
end

return {
    {
        -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        cond = require("config.util").is_not_vscode(),
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { "williamboman/mason.nvim", config = true },
            { "williamboman/mason-lspconfig.nvim" },
            { "folke/neodev.nvim" },

            -- Useful status updates for LSP
            { "j-hui/fidget.nvim", opts = {} },
        },
    },

    {
        "williamboman/mason-lspconfig.nvim",
        cond = require("config.util").is_not_vscode(),
        config = function()
            -- Configure LSP

            -- mason-lspconfig requires that these setup functions are called in this order
            -- BEFORE setting up the servers.
            require("mason").setup()
            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup()

            -- Enable the following language servers
            --  Add any additional override configuration in the following tables. They will be passed to the `settings` field of the server config
            --  If you want to override the default filetypes that your language server will attach to you can define the property 'filetypes' to the map in question.
            local servers = {
                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                        completion = { callSnippet = "Replace" },
                        hint = { enable = true },
                        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        -- diagnostics = { disable = { 'missing-fields' } },
                    },
                },
                bashls = { filetypes = { "sh", "bash", "zsh" } },
                html = { filetypes = { "html", "twig", "hbs" } },
                ltex = {
                    filetypes = { "markdown", "text" },
                    flags = { debounce_text_changes = 3000 },
                    settings = {
                        ltex = {
                            language = "en",
                            markdown = {
                                nodes = {
                                    CodeBlock = "ignore",
                                    FencedCodeBlock = "ignore",
                                    Code = "ignore",
                                    AutoLink = "ignore",
                                },
                                checkFrequency = "save",
                                languageToolHttpServerUri = "https://api.languagetool.org",
                            },
                        },
                    },
                },

                omnisharp = {
                    -- DotNet = {
                    --     enablePackageRestore = true,
                    -- },
                    settings = {
                        FormattingOptions = {
                            OrganizeImports = true,
                        },
                        RoslynExtensionOptions = {
                            EnableAnalyzerSupport = true,
                            EnableImportCompletion = true,
                        },
                        Sdk = {
                            IncludePrereleases = false,
                        },
                    },
                },
                tsserver = {
                    settings = {
                        completions = {
                            completeFunctionCalls = true,
                        },
                    },
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                },

                -- https://github.com/joe-re/sql-language-server?tab=readme-ov-file#configuration
                sqlls = {},
                marksman = {},
                cssls = {},
                dockerls = {},
                docker_compose_language_service = {},
                jsonls = {},
                pylsp = {},
            }

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(servers),
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        inlay_hints = { enabled = true },
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                        diagnostics = {
                            underline = true,
                            update_in_insert = false,
                            virtual_text = {
                                spacing = 4,
                                source = "if_many",
                                prefix = "●",
                            },
                            severity_sort = true,
                            signs = {
                                text = {
                                    [vim.diagnostic.severity.ERROR] = require("config.util").icons.diagnostics.Error,
                                    [vim.diagnostic.severity.WARN] = require("config.util").icons.diagnostics.Warn,
                                    [vim.diagnostic.severity.HINT] = require("config.util").icons.diagnostics.Hint,
                                    [vim.diagnostic.severity.INFO] = require("config.util").icons.diagnostics.Info,
                                },
                            },
                        },
                    })
                end,
            })
        end,
    },

    {
        "j-hui/fidget.nvim",
        cond = require("config.util").is_not_vscode(),
        opts = {
            progress = {
                poll_rate = 1, -- How and when to poll for progress messages
                suppress_on_insert = true, -- Suppress new messages while in insert mode
                ignore_done_already = true, -- Ignore new tasks that are already complete
                ignore_empty_message = true, -- Ignore new tasks that don't contain a message
                ignore = {}, -- List of LSP servers to ignore

                display = {
                    render_limit = 1, -- How many LSP messages to show at once
                    -- skip_history = true, -- Whether progress notifications should be omitted from history
                },
            },

            notification = {
                poll_rate = 2, -- How often to udate and render notifications
                filter = vim.log.levels.WARN, -- Minimum notifications level
            },
        },
    },
}
