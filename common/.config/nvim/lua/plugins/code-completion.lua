return {

    -- TODO: Figureout how to add custom snippets

    {
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",

            -- Adds LSP completion capabilities
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",

            -- Adds a number of user-friendly snippets
            "rafamadriz/friendly-snippets",
        },
        config = function()
            -- See `:help cmp`
            local cmp = require("cmp")
            local defaults = require("cmp.config.default")()
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()
            luasnip.config.setup({})

            -- vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
            cmp.setup({
                -- experimental = {
                --     ghost_text = {
                --         hl_group = "CmpGhostText",
                --     },
                -- },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),

                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(4),

                    ["<C-Space>"] = cmp.mapping.complete({}),
                    ["<C-x>"] = cmp.mapping.abort(),

                    -- Enter to perform the completion
                    ["<CR>"] = cmp.mapping.confirm({
                        select = true,
                    }),
                    ["<S-CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                    { { name = "buffer" } },
                },
                sorting = defaults.sorting,
            })
        end,
    },

    {
        "L3MON4D3/LuaSnip",
        keys = {
            -- TODO: Verify if this fixed the tab-going-crazy-sometimes issue
            -- {
            --     "<tab>",
            --     function()
            --         return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
            --     end,
            --     expr = true,
            --     silent = true,
            --     mode = "i",
            -- },
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
