return {
    {
        "saghen/blink.cmp",
        cond = require("config.util").is_not_vscode(),
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "L3MON4D3/LuaSnip",
            "Exafunction/codeium.nvim",
            {
                "saghen/blink.compat",
                optional = true,
            },
            {
                "saghen/blink.compat",
                opts = {
                    enable_events = true,
                },
            },
        },

        -- use a release tag to download pre-built binaries
        version = "*",

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
            -- See the full "keymap" documentation for information on defining your own keymap.
            keymap = {
                preset = "enter",
                ["<C-y>"] = { "select_and_accept" },

                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },

                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },

                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },

                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide", "fallback" },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },

            signature = { enabled = true },

            -- This comes from the luasnip extra, if you don't add it, won't be able to
            -- jump forward or backward in luasnip snippets
            snippets = {
                expand = function(snippet)
                    require("luasnip").lsp_expand(snippet)
                end,
                active = function(filter)
                    if filter and filter.direction then
                        return require("luasnip").jumpable(filter.direction)
                    end
                    return require("luasnip").in_snippet()
                end,
                jump = function(direction)
                    require("luasnip").jump(direction)
                end,
            },

            sources = {
                default = {
                    "lsp",
                    "buffer",
                    "dadbod",
                    "snippets",
                    "luasnip",
                    "path",
                    "codeium",
                },
                cmdline = {},

                providers = {
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
                    luasnip = {
                        score_offset = 1100,
                    },
                    path = {
                        score_offset = 750,
                    },
                    codeium = {
                        name = "codeium",
                        module = "blink.compat.source",
                        score_offset = 1200,
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
