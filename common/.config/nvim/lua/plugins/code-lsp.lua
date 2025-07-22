return {
    {
        -- Main LSP Configuration
        "neovim/nvim-lspconfig",
        cond = require("config.util").is_not_vscode(),
        dependencies = {
            { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { "j-hui/fidget.nvim", opts = {} },

            "saghen/blink.cmp",
        },
        config = function()
            -- Every time a new file is opened that is associated with
            --    an lsp this function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    -- Lspsaga Keymaps
                    -- Hover Documentation
                    --  Press K 2 times to jump into the hover window
                    --  Place cursor on "View Documentation" gx -> Open the docs on browser
                    map("K", "<cmd>Lspsaga hover_doc<cr>", "Hover Documentation")
                    map("<F2>", vim.lsp.buf.rename, "Rename Symbol")

                    map("<C-.>", "<cmd>Lspsaga code_action<cr>", "Code Actions")
                    map("<leader>ca", "<cmd>Lspsaga code_action<cr>", "Code Actions")

                    map("<leader>cr", "<cmd>Lspsaga finder<cr>", "Goto References")

                    map("<leader>cpf", "<cmd>Lspsaga peek_definition<cr>", "Peek definition: Function")
                    map("<leader>cpt", "<cmd>Lspsaga peek_type_definition<cr>", "Peek definition: Class")
                    map("<leader>cpi", "<cmd>Lspsaga finder imp<cr>", "Peek: Implementations")

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("<F12>", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                    map("<leader>ci", require("telescope.builtin").lsp_implementations, "Goto Implementation")

                    map("<leader>cs", require("telescope.builtin").lsp_document_symbols, "Search Document Symbols")
                    map("<leader>cS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Search Workspace Symbols")

                    map("<leader>ct", require("telescope.builtin").lsp_type_definitions, "Goto Type Definition")
                    -- e to jump to the symbol under cursor; q to quit
                    map("<leader>co", "<cmd>Lspsaga outline<cr>", "Outline Panel on Left")

                    map("<leader>cd", require("telescope.builtin").diagnostics, "List Diagnostics")

                    map("<leader>nf", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, "Workspace Folders on Notification")

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    -- When you move your cursor, the highlights will be cleared
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
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
                local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
                local diagnostic_signs = {}
                for type, icon in pairs(signs) do
                    diagnostic_signs[vim.diagnostic.severity[type]] = icon
                end
                vim.diagnostic.config({ signs = { text = diagnostic_signs } })
            end

            -- Enable the following language servers
            --  Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            local servers = {
                html = {
                    -- cmd = { ... },
                    -- filetypes = { ... },
                    -- capabilities = {},
                    filetypes = { "html", "twig", "hbs" },
                },
                cssls = {},
                jsonls = {
                    -- lazy-load schemastore when needed
                    on_new_config = function(new_config)
                        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                        vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
                    end,
                    settings = {
                        json = {
                            format = {
                                enable = true,
                            },
                            validate = { enable = true },
                        },
                    },
                },

                bashls = { filetypes = { "sh", "bash", "zsh" } },
                pylsp = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                            completion = { callSnippet = "Replace" },
                            hint = { enable = true },
                            diagnostics = { disable = { "missing-fields" } },
                        },
                    },
                },
                omnisharp = {
                    cmd = { "omnisharp" },
                    handlers = {
                        ["textDocument/definition"] = function(...)
                            return require("omnisharp_extended").handler(...)
                        end,
                    },
                    enable_roslyn_analyzers = true,
                    organize_imports_on_format = true,
                    enable_import_completion = true,
                    enable_editorconfig_support = true,
                    enable_ms_build_load_projects_on_demand = false,
                    analyze_open_documents_only = false,
                    settings = {
                        dotnet = {
                            server = {
                                useOmnisharpServer = true,
                                useModernNet = true,
                            },
                        },
                        csharp = {
                            inlayHints = {
                                parameters = {
                                    enabled = true,
                                },
                                types = {
                                    enabled = true,
                                },
                            },
                        },
                    },
                },
                ts_ls = {
                    settings = {
                        typescript = {
                            updateImportOnFileMove = { enabled = "always" },
                            suggest = { completeFunctionCalls = true },
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
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
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                    },
                },

                sqlls = {},
                dockerls = {},
                docker_compose_language_service = {},
            }

            -- Ensure the servers and tools above are installed
            require("mason").setup()

            -- Add completion capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- TODO: Remove this when we get neovim 0.11
            capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

            -- Add other (other than LSP servers) tools here that you want Mason to install for you
            -- Which means: formatters and debuggers
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "black", -- Python formatter
                "csharpier", -- C# formatter
                "djlint", -- Handlebar Formatter
                "markdown-toc",
                "markdownlint",
                "netcoredbg", -- C# Debugger
                "prettier",
                "prettierd",
                "shellharden",
                "shfmt",
                "stylua",
                "trivy", -- Vulnerability Linter
                "yamlfmt",
            })

            -- TODO: Remove all installations through Mason
            -- i.e. Remove mason.nvim, mason-lspconfig and mason-tool-installer
            -- We should install those globally on the system
            -- That would make it easier to work with on FreeBSD
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            ---@diagnostic disable-next-line: missing-fields
            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for ts_ls)
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        server.inlay_hints = { enabled = true }
                        server.diagnostics = {
                            underline = true,
                            update_in_insert = false,
                            virtual_text = {
                                spacing = 4,
                                source = "if_many",
                                prefix = "●",
                            },
                            severity_sort = true,
                        }
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
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
                window = { winblend = 0 },
            },
        },
    },
}
