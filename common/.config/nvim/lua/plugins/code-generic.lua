return {
    { "tpope/vim-repeat" },

    -- Better surround than tpope/vim-surround
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },

    -- "gc" to comment visual regions/lines
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({
                pre_hook = function()
                    return vim.bo.commentstring
                end,
            })
        end,
    },

    -- Better code folding
    {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        dependencies = {
            "kevinhwang91/promise-async",
            {
                "luukvbaal/statuscol.nvim",
                config = function()
                    local builtin = require("statuscol.builtin")
                    require("statuscol").setup({
                        relculright = true,
                        segments = {
                            { text = { "%s" }, click = "v:lua.ScSa" },
                            { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                        },
                    })
                end,
            },
        },
        opts = {
            provider_selector = function()
                return { "treesitter", "indent" }
            end,
            open_fold_hl_timeout = 0,
            close_fold_kinds = { "imports", "comment" },
            fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local totalLines = vim.api.nvim_buf_line_count(0)
                local foldedLines = endLnum - lnum
                local suffix = (" 󰇘 󰁂 %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
                suffix = (" "):rep(rAlignAppndx) .. suffix
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end,
        },
        init = function()
            vim.opt.foldcolumn = "1"
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
            vim.opt.foldenable = true

            vim.opt.fillchars = {
                foldopen = "",
                foldclose = "",
                fold = " ",
                foldsep = " ",
                diff = "╱",
                eob = " ",
            }

            vim.keymap.set("n", "zR", require("ufo").openAllFolds)
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

            require("ufo").setup()
        end,
    },

    -- auto pairs
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        opts = {},
    },

    -- indent guides for Neovim
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            indent = { char = "│", tab_char = "│" },
            scope = { enabled = false },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        },
        main = "ibl",
    },

    -- Highlights the current level of indentation, and animates the highlighting.
    {
        "echasnovski/mini.indentscope",
        opts = { symbol = "│", options = { try_as_border = true } },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    -- Finds and lists all of the TODO, HACK, BUG, etc comment
    {
        "folke/todo-comments.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
        opts = {
            keywords = {
                HACK = { alt = { "TIP" } },
            },
        },
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next todo comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous todo comment",
            },

            { "<leader>dt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
            { "<leader>dT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
            -- TODO: Include hidden files
            { "<leader>lt", "<cmd>TodoTelescope<cr>", desc = "List Todo" },
            { "<leader>lT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "List Todo/Fix/Fixme" },
        },
    },

    -- better diagnostics list and others
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = {
            use_diagnostic_signs = true,
            severity = vim.diagnostic.severity.WARN,
        },
        keys = {
            { "<leader>dx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
            { "<leader>dw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
            { "<leader>dl", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
            { "<leader>dq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").previous({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous trouble/quickfix item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next trouble/quickfix item",
            },
        },
    },

    -- Inlay hints
    {
        "lvimuser/lsp-inlayhints.nvim",
        config = function()
            require("lsp-inlayhints").setup()

            -- Lazy load on LspAttach
            vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
            vim.api.nvim_create_autocmd("LspAttach", {
                group = "LspAttach_inlayhints",
                callback = function(args)
                    if not (args.data and args.data.client_id) then
                        return
                    end

                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    require("lsp-inlayhints").on_attach(client, bufnr)
                end,
            })
        end,
    },

    -- Lsp Breadcrumbs for lualine
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        init = function()
            vim.g.navic_silence = true
            require("config.util").on_lsp_attach(function(client, buffer)
                if client.supports_method("textDocument/documentSymbol") then
                    require("nvim-navic").attach(client, buffer)
                end
            end)
        end,
        opts = function()
            return {
                separator = " ",
                highlight = true,
                depth_limit = 5,
                icons = require("config.util").icons.kinds,
                lazy_update_context = true,
            }
        end,
    },

    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            lsp = { auto_attach = true },
            icons = require("config.util").icons.kinds,
        },
        keys = {
            {
                "<leader>v",
                function()
                    return require("nvim-navbuddy").open()
                end,
                desc = "Navigate through document symbols",
            },
        },
    },
}
