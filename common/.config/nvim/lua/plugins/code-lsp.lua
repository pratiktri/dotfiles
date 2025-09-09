return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "williamboman/mason.nvim",
                config = true,
                opts = { PATH = "append" },
            },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            local servers = {}
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- TIP: `nvim-lspconfig` has default LSP configs in its DB which saves time
            -- Useful even after NeoVim 0.11, which made LSP setup much easier
            -- Configs in ../../lsp/* are APPENDED to each LSP setup here
            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        server.inlay_hints = { enabled = true }
                        server.diagnostics = {
                            underline = true,
                            update_in_insert = false,
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

    -- NeoVim
    { "folke/lazydev.nvim", ft = "lua" },

    -- Rust
    {
        "mrcjkb/rustaceanvim",
        version = "^6",
        lazy = false,
        init = function()
            vim.g.rustaceanvim = {
                server = {
                    -- Keymaps in ../../after/ftplugin/rust.lua

                    -- LSP configuration
                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                buildScripts = { enabled = true },
                            },
                            checkOnSave = true,
                            diagnostics = {
                                enable = true,
                                enableExperimental = true,
                            },
                            completion = {
                                addCallArgumentSnippets = true,
                                addCallParenthesis = true,
                                postfix = { enable = true },
                                autoimport = { enable = true },
                            },
                            lens = {
                                enable = true,
                                implementations = { enable = true },
                                run = { enable = false },
                            },
                            inlayHints = {
                                bindingModeHints = { enable = false },
                                chainingHints = { enable = true },
                                closingBraceHints = { enable = true, minLines = 25 },
                                closureReturnTypeHints = { enable = "never" },
                                lifetimeElisionHints = { enable = "never", useParameterNames = false },
                                maxLength = 25,
                                parameterHints = { enable = true },
                                reborrowHints = { enable = "never" },
                                renderColons = true,
                                typeHints = {
                                    enable = true,
                                    hideClosureInitialization = false,
                                    hideNamedConstructor = false,
                                },
                            },
                            procMacro = {
                                enable = true,
                                ignored = {
                                    ["async-trait"] = { "async_trait" },
                                    ["napi-derive"] = { "napi" },
                                    ["async-recursion"] = { "async_recursion" },
                                },
                            },
                            files = {
                                excludeDirs = { ".direnv", ".git", ".github", ".gitlab", "bin", "node_modules", "target", "venv", ".venv" },
                            },
                        },
                    },
                },
                dap = {
                    adapter = {
                        type = "executable",
                        command = "codelldb",
                        name = "codelldb",
                    },
                },
            }
        end,
    },
    {
        "saecki/crates.nvim",
        tag = "stable",
        opts = {
            completion = {
                crates = {
                    enabled = true,
                },
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
        },
        config = function()
            require("crates").setup()
        end,
    },

    -- Javascript/Typescript/React/Vue
    --
    -- Automatically add closing tags for HTML and JSX
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },

    -- Intelligent commenting on JSX
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
            options = {
                enable_autocmd = false,
            },
        },
        config = function()
            vim.g.skip_ts_context_commentstring_module = true
        end,
    },

    -- Highlight colors
    {
        "brenoprata10/nvim-highlight-colors",
        setup = { enable_tailwind = true },
        config = function()
            require("nvim-highlight-colors").setup({
                render = "virtual",
                virtual_symbol_position = "eow",
                virtual_symbol_prefix = " ",
                virtual_symbol_suffix = "",
            })
        end,
    },
}
