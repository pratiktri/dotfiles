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
        cond = require("config.util").is_not_vscode(),
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
        version = "v1.4.0",
        cond = require("config.util").is_not_vscode(),
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
            close_fold_kinds_for_ft = { "imports", "comment" },
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
        cond = require("config.util").is_not_vscode(),
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
        cond = require("config.util").is_not_vscode(),
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
        opts = {
            -- Default: Preview in a split
            preview = {
                type = "split",
                relative = "win",
                position = "right",
                size = 0.6,
            },
            modes = {

                -- Show only the most severe diagnostics; once resolved, less severe will be shown
                most_severe = {
                    mode = "diagnostics", -- inherit from diagnostics mode
                    filter = function(items)
                        local severity = vim.diagnostic.severity.HINT
                        for _, item in ipairs(items) do
                            severity = math.min(severity, item.severity)
                        end
                        return vim.tbl_filter(function(item)
                            return item.severity == severity
                        end, items)
                    end,
                },

                -- Diagnostics from buffer + Errors from current project
                project_errors = {
                    mode = "diagnostics", -- inherit from diagnostics mode
                    filter = {
                        any = {
                            buf = 0, -- current buffer
                            {
                                severity = vim.diagnostic.severity.ERROR,
                                -- limit to files in the current project
                                function(item)
                                    return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
                                end,
                            },
                        },
                    },
                },
            },
        },
        keys = {
            { "<leader>o", "<cmd>Trouble symbols toggle preview.type=main focus=true<cr>", desc = "Code: Toggle Symbol Outline" },

            { "<leader>dd", "<cmd>Trouble project_errors toggle focus=true<cr>", desc = "Trouble: Document Diagnostics" },
            { "<leader>dw", "<cmd>Trouble most_severe toggle focus=true<cr>", desc = "Trouble: List Project Diagnostics" },
            { "<leader>dl", "<cmd>Trouble loclist toggle focus=true<cr>", desc = "Trouble: Location List" },
            { "<leader>dq", "<cmd>Trouble quickfix toggle focus=true<cr>", desc = "Trouble: Quickfix List" },
            { "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>", desc = "Code: List References" },
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
        cond = require("config.util").is_not_vscode(),
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

    -- LspSaga
    {
        "nvimdev/lspsaga.nvim",
        cond = require("config.util").is_not_vscode(),
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lspsaga").setup({
                ui = {
                    kind = require("config.util").icons.kind_lspsaga,
                },
                symbol_in_winbar = {
                    enable = true,
                    hide_keyword = true,
                },
                lightbulb = {
                    enable = false,
                    sign = false,
                    virtual_text = false,
                },
                outline = { auto_preview = false },
            })

            vim.keymap.set("n", "<leader>cR", "<cmd>Lspsaga finder<cr>", { desc = "Code: Goto References" })
            vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga peek_definition<cr>", { desc = "Code: Peek definition: Function" })
            vim.keymap.set("n", "<leader>cD", "<cmd>Lspsaga peek_type_definition<cr>", { desc = "Code: Peek definition: Class" })

            vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", { desc = "Hover Documentation" })
        end,
    },

    -- Search and jump around symbols in the buffer
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
            -- Default Mappings on the popup
            -- ["<esc>"] = actions.close(), -- Close and cursor to original location
            -- ["q"] = actions.close(),
            --
            -- ["j"] = actions.next_sibling(), -- down
            -- ["k"] = actions.previous_sibling(), -- up
            --
            -- ["h"] = actions.parent(), -- Move to left panel
            -- ["l"] = actions.children(), -- Move to right panel
            -- ["0"] = actions.root(), -- Move to first panel
            --
            -- ["v"] = actions.visual_name(), -- Visual selection of name
            -- ["V"] = actions.visual_scope(), -- Visual selection of scope
            --
            -- ["y"] = actions.yank_name(), -- Yank the name to system clipboard "+
            -- ["Y"] = actions.yank_scope(), -- Yank the scope to system clipboard "+
            --
            -- ["i"] = actions.insert_name(), -- Insert at start of name
            -- ["I"] = actions.insert_scope(), -- Insert at start of scope
            --
            -- ["a"] = actions.append_name(), -- Insert at end of name
            -- ["A"] = actions.append_scope(), -- Insert at end of scope
            --
            -- ["r"] = actions.rename(), -- Rename currently focused symbol
            --
            -- ["d"] = actions.delete(), -- Delete scope
            --
            -- ["f"] = actions.fold_create(), -- Create fold of current scope
            -- ["F"] = actions.fold_delete(), -- Delete fold of current scope
            --
            -- ["c"] = actions.comment(), -- Comment out current scope
            --
            -- ["<enter>"] = actions.select(), -- Goto selected symbol
            -- ["o"] = actions.select(),
            --
            -- ["J"] = actions.move_down(), -- Move focused node down
            -- ["K"] = actions.move_up(), -- Move focused node up
            --
            -- ["s"] = actions.toggle_preview(), -- Show preview of current node
            --
            -- ["<C-v>"] = actions.vsplit(), -- Open selected node in a vertical split
            -- ["<C-s>"] = actions.hsplit(), -- Open selected node in a horizontal split
            --
            -- ["t"] = actions.telescope({ -- Fuzzy finder at current level.
            --     layout_config = { -- All options that can be
            --         height = 0.60, -- passed to telescope.nvim's
            --         width = 0.60, -- default can be passed here.
            --         prompt_position = "top",
            --         preview_width = 0.50,
            --     },
            --     layout_strategy = "horizontal",
            -- }),
            --
            -- ["g?"] = actions.help(), -- Open mappings help window
            {
                "<leader>v",
                function()
                    return require("nvim-navbuddy").open()
                end,
                desc = "Navigate through document symbols",
            },
        },
    },

    -- Refactor code: Refactoring book by Martin Fowler
    {
        "ThePrimeagen/refactoring.nvim",
        cond = require("config.util").is_not_vscode(),
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            {
                "<leader>rs",
                function()
                    require("telescope").extensions.refactoring.refactors()
                end,
                mode = "v",
                desc = "Refactor",
            },
            {
                "<leader>ri",
                function()
                    require("refactoring").refactor("Inline Variable")
                end,
                mode = { "n", "v" },
                desc = "Inline Variable",
            },
            {
                "<leader>rb",
                function()
                    require("refactoring").refactor("Extract Block")
                end,
                desc = "Extract Block",
            },
            {
                "<leader>rf",
                function()
                    require("refactoring").refactor("Extract Block To File")
                end,
                desc = "Extract Block To File",
            },
            {
                "<leader>rP",
                function()
                    require("refactoring").debug.printf({ below = false })
                end,
                desc = "Debug Print",
            },
            {
                "<leader>rp",
                function()
                    require("refactoring").debug.print_var({ normal = true })
                end,
                desc = "Debug Print Variable",
            },
            {
                "<leader>rc",
                function()
                    require("refactoring").debug.cleanup({})
                end,
                desc = "Debug Cleanup",
            },
            {
                "<leader>rf",
                function()
                    require("refactoring").refactor("Extract Function")
                end,
                mode = "v",
                desc = "Extract Function",
            },
            {
                "<leader>rF",
                function()
                    require("refactoring").refactor("Extract Function To File")
                end,
                mode = "v",
                desc = "Extract Function To File",
            },
            {
                "<leader>rx",
                function()
                    require("refactoring").refactor("Extract Variable")
                end,
                mode = "v",
                desc = "Extract Variable",
            },
            {
                "<leader>rp",
                function()
                    require("refactoring").debug.print_var()
                end,
                mode = "v",
                desc = "Debug Print Variable",
            },
        },
        opts = {
            prompt_func_return_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            prompt_func_param_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            printf_statements = {},
            print_var_statements = {},
        },
        config = function(_, opts)
            require("refactoring").setup(opts)
            pcall(require("telescope").load_extension, "refactoring")
        end,
    },

    -- which key integration
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<leader>r"] = { name = "+refactor" },
            },
        },
    },
}
