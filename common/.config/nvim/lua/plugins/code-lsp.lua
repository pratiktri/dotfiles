return {
    {
        -- TODO: Disable it for VSCode
        --
        -- Main LSP Configuration
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { "j-hui/fidget.nvim", opts = {} },

            -- Allows extra capabilities provided by nvim-cmp
            "hrsh7th/cmp-nvim-lsp",
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
                    -- e to jump to the symbol under cursor; q to quit
                    map("<leader>o", "<cmd>Lspsaga outline<cr>", "Outline Panel on Left")
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
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map("<leader>cs", require("telescope.builtin").lsp_document_symbols, "Search Document Symbols")
                    map("<leader>cS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Search Workspace Symbols")
                    map("<leader>ci", require("telescope.builtin").lsp_implementations, "Goto Implementation")
                    map("<leader>ct", require("telescope.builtin").lsp_type_definitions, "Goto Type Definition")

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

                    -- TODO: Make inlay_hint enabled by default
                    -- Change this keymap
                    --
                    -- The following code creates a keymap to toggle inlay hints
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map("<leader>ni", function()
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

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  Here, we broadcast the new capabilities to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            -- Enable the following language servers
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                html = { filetypes = { "html", "twig", "hbs" } },
                cssls = {},
                jsonls = {},

                bashls = { filetypes = { "sh", "bash", "zsh" } },
                pylsp = {},
                ts_ls = {},
                lua_ls = {
                    -- cmd = { ... },
                    -- filetypes = { ... },
                    -- capabilities = {},
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
                    settings = {
                        DotNet = {
                            enablePackageRestore = true,
                            FormattingOptions = { OrganizeImports = true },
                            RoslynExtensionOptions = {
                                EnableAnalyzerSupport = true,
                                EnableImportCompletion = true,
                            },
                            Sdk = { IncludePrereleases = false },
                        },
                    },
                },

                sqlls = {},
                dockerls = {},
                docker_compose_language_service = {},

                marksman = {},
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
            }

            -- Ensure the servers and tools above are installed
            require("mason").setup()

            -- Add other tools here that you want Mason to install for you
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua",
                "codespell",
                "bash-language-server",
                "marksman",
                "html-lsp",
                "css-lsp",
                "dockerfile-language-server",
                "python-lsp-server",
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

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
            },
        },
    },
}
