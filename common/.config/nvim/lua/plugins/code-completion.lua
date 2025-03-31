return {
    {
        "saghen/blink.cmp",
        cond = require("config.util").is_not_vscode(),
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "L3MON4D3/LuaSnip",
            "Exafunction/codeium.nvim",
            "kristijanhusak/vim-dadbod-completion",
            "moyiz/blink-emoji.nvim",
            "disrupted/blink-cmp-conventional-commits",
        },

        -- use a release tag to download pre-built binaries
        version = "1.*",

        opts_extend = {
            "sources.completion.enabled_providers",
            "sources.compat",
            "sources.default",
        },

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- 'none' - create all the mappings yourself
            keymap = {
                preset = "none",
                ["<C-CR>"] = { "accept", "fallback" }, -- Ctrl + Enter to accept
                ["<C-x>"] = { "hide", "fallback" }, -- Ctrl + x to reject

                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },

                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },

                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },

                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },

            completion = {
                keyword = { range = "full" },
                accept = { auto_brackets = { enabled = false } },
                menu = {
                    border = "rounded",
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                },
                ghost_text = {
                    enabled = false,
                },
            },

            signature = { enabled = true },

            -- This comes from the luasnip extra, if you don't add it, won't be able to
            -- jump forward or backward in luasnip snippets
            snippets = { preset = "luasnip" },

            cmdline = {
                enabled = true,
                -- use 'inherit' to inherit mappings from top level `keymap` config
                keymap = { preset = "inherit" },
                sources = function()
                    local type = vim.fn.getcmdtype()
                    -- Search forward and backward
                    if type == "/" or type == "?" then
                        return { "buffer" }
                    end
                    -- Commands
                    if type == ":" or type == "@" then
                        return { "cmdline" }
                    end
                    return {}
                end,
                completion = {
                    trigger = {
                        show_on_blocked_trigger_characters = {},
                        show_on_x_blocked_trigger_characters = {},
                    },
                    list = {
                        selection = {
                            -- When `true`, will automatically select the first item in the completion list
                            preselect = true,
                            -- When `true`, inserts the completion item automatically when selecting it
                            auto_insert = true,
                        },
                    },
                    -- Whether to automatically show the window when new completion items are available
                    menu = { auto_show = true },
                    -- Displays a preview of the selected item on the current line
                    ghost_text = { enabled = false },
                },
            },

            sources = {
                default = {
                    "lsp",
                    "buffer",
                    "path",
                    "snippets",
                    "codeium",
                },
                per_filetype = {
                    sql = { "snippets", "dadbod", "buffer" },
                    markdown = { "markdown", "snippets", "buffer", "path", "emoji" },
                    gitcommit = { "conventional_commits", "emoji", "buffer", "snippets" },
                },

                providers = {
                    codeium = {
                        name = "codeium", -- Cause it's registered on nvim-cmp as "codeium"
                        module = "blink.compat.source",
                        score_offset = 600,
                    },
                    conventional_commits = {
                        name = "Conventional Commits",
                        module = "blink-cmp-conventional-commits",
                        should_show_items = function()
                            return vim.tbl_contains({ "gitcommit" }, vim.o.filetype)
                        end,
                        ---@module 'blink-cmp-conventional-commits'
                        ---@type blink-cmp-conventional-commits.Options
                        opts = {},
                        score_offset = 700,
                    },
                    emoji = {
                        module = "blink-emoji",
                        name = "Emoji",
                        score_offset = 700,
                        opts = { insert = true },
                        should_show_items = function()
                            return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
                        end,
                    },
                    lsp = {
                        score_offset = 1000,
                    },
                    buffer = {
                        score_offset = 950,
                    },
                    dadbod = {
                        name = "Dadbod",
                        module = "vim_dadbod_completion.blink",
                        score_offset = 900,
                    },
                    snippets = {
                        score_offset = 1150,
                    },
                    path = {
                        score_offset = 750,
                    },
                    markdown = {
                        name = "RenderMarkdown",
                        module = "render-markdown.integ.blink",
                        score_offset = 900,
                    },
                },
            },
        },
    },

    {
        "L3MON4D3/LuaSnip",
        cond = require("config.util").is_not_vscode(),
        version = "v2.*",
        keys = {
            {
                "<tab>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true,
                silent = true,
                mode = "i",
            },
            {
                "<tab>",
                function()
                    require("luasnip").jump(1)
                end,
                mode = "s",
            },
            {
                "<s-tab>",
                function()
                    require("luasnip").jump(-1)
                end,
                mode = { "i", "s" },
            },
        },
    },
}
