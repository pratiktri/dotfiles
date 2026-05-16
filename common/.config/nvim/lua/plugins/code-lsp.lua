return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "mason-org/mason.nvim",
                config = true,
                opts = { PATH = "append" },
            },
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            vim.lsp.config("*", {
                capabilities = vim.tbl_deep_extend(
                    "force",
                    vim.lsp.protocol.make_client_capabilities(),
                    require("lsp-file-operations").default_capabilities(),
                    require("blink.cmp").get_lsp_capabilities()
                ),
            })
        end,
    },

    -- Rust
    {
        "mrcjkb/rustaceanvim",
        ft = { "toml", "rust" },
        version = "^8",
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
                                buildScripts = { enabled = false },
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
                                -- WARN: This a major attack surface. But, what can you do...
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
        event = { "BufRead Cargo.toml" },
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
