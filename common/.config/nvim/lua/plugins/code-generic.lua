return {
    { "tpope/vim-repeat" },

    { "arnamak/stay-centered.nvim" },

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

    -- Tpope's surround but faster and in lua
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            -- Configuration here, or leave empty to use defaults
            require("nvim-surround").setup({})
        end,
    },

    -- mini.nvim: Collection of various small independent plugins/modules
    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            -- Better Around/Inside textobjects
            --
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
            --  - ci'  - [C]hange [I]nside [']quote
            --  TODO: Learn about the other mini textobjects
            require("mini.ai").setup({ n_lines = 500 })

            -- gc
            require("mini.comment").setup()

            require("mini.pairs").setup()

            -- Configure mini.indentscope
            if require("config.util").is_not_vscode() then
                require("mini.indentscope").setup({
                    delay = 100,
                    symbol = "│",
                    options = { try_as_border = true },
                })

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
            end
        end,
    },

    -- Finds and lists all of the TODO, HACK, BUG, etc comment
    {
        "folke/todo-comments.nvim",
        cond = require("config.util").is_not_vscode(),
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
        opts = {
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--hidden", -- include hidden files
                    "--glob=!.git", -- exclude .git directory
                },
            },
            signs = false,
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

            { "<leader>df", "<cmd>TodoTelescope keywords=FIX,FIXME<cr>", desc = "FIXME: Tags" },
            { "<leader>dt", "<cmd>TodoTelescope keywords=TODO<cr>", desc = "Project TODOs" },
            { "<leader>dT", "<cmd>TodoTelescope<cr>", desc = "All tags: FIX, NOTE, TIP, TODO, WARN" },
        },
    },

    -- better diagnostics list and others
    {
        "folke/trouble.nvim",
        lazy = false,
        cmd = "Trouble",
        cond = require("config.util").is_not_vscode(),
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
                project_warnings = {
                    mode = "diagnostics", -- inherit from diagnostics mode
                    filter = function(items)
                        local severity = vim.diagnostic.severity.WARN
                        for _, item in ipairs(items) do
                            severity = math.min(severity, item.severity)
                        end
                        return vim.tbl_filter(function(item)
                            return item.severity == severity
                        end, items)
                    end,
                },

                -- Diagnostics from buffer + Errors from current project
                file_hints = {
                    mode = "diagnostics", -- inherit from diagnostics mode
                    filter = {
                        any = {
                            buf = 0, -- current buffer
                            {
                                severity = vim.diagnostic.severity.INFO,
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
            { "<leader>dd", "<cmd>Trouble file_hints toggle focus=true<cr>", desc = "Trouble: File Diagnostics" },
            { "<leader>dw", "<cmd>Trouble project_warnings toggle focus=true<cr>", desc = "Trouble: List Project Diagnostics" },
            { "<leader>dq", "<cmd>Trouble quickfix toggle focus=true<cr>", desc = "Trouble: Quickfix List" },
            { "gr", "<cmd>Trouble lsp_references toggle focus=true<cr>", desc = "Goto References" },
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
                        ---@diagnostic disable-next-line: missing-parameter, missing-fields
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
                    -- kind = require("config.util").icons.kind_lspsaga,
                    kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
                },
                symbol_in_winbar = {
                    enable = true,
                    hide_keyword = true,
                },
                lightbulb = {
                    virtual_text = false,
                },
                outline = { auto_preview = false },
            })

            -- Keymaps in code-lsp.lua
        end,
    },

    -- Search and jump around symbols in the buffer
    {
        "SmiteshP/nvim-navbuddy",
        cond = require("config.util").is_not_vscode(),
        dependencies = {
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            local actions = require("nvim-navbuddy.actions")
            local navbuddy = require("nvim-navbuddy")

            navbuddy.setup({
                lsp = { auto_attach = true },
                icons = require("config.util").icons.kinds,
                window = {
                    border = "rounded",
                    size = "80%",
                },
                mappings = {
                    -- Fuzzy finder at current level.
                    ["f"] = actions.telescope({
                        layout_config = {
                            height = 0.8,
                            width = 0.8,
                        },
                    }),
                    -- Show preview of current node
                    ["o"] = actions.toggle_preview(),

                    -- Default Mappings on the popup
                    --
                    -- ["J"] = actions.move_down(), -- Move focused node down
                    -- ["K"] = actions.move_up(), -- Move focused node up
                    --
                    -- ["r"] = actions.rename(), -- Rename currently focused symbol
                    --
                    -- ["<C-v>"] = actions.vsplit(), -- Open selected node in a vertical split
                    -- ["<C-s>"] = actions.hsplit(), -- Open selected node in a horizontal split
                    --
                    -- ["0"] = actions.root(), -- Move to first panel
                    --
                    -- ["g?"] = actions.help(), -- Open mappings help window
                },
            })
        end,
        keys = {
            {
                "<leader>o",
                function()
                    return require("nvim-navbuddy").open()
                end,
                desc = "Navigate through document symbols",
            },
        },
    },

    -- Treesitter
    {
        -- nvim-treesitter provides parsers for individual languages
        -- Output of these parses are fed to the NVIM's native treesitter(vim.treesitter)
        -- What is fed to the native treesitter is essentially the AST
        -- This AST is then used for syntax-highlighting and many other operations on the code
        -- Hence, this plugin is only to make installing parsers easier

        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treeitter** module to be loaded in time.
            -- Luckily, the only thing that those plugins need are the custom queries, which we make available
            -- during startup.
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            config = function()
                -- When in diff mode, we want to use the default
                -- vim text objects c & C instead of the treesitter ones.
                local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
                local configs = require("nvim-treesitter.configs")
                for name, fn in pairs(move) do
                    if name:find("goto") == 1 then
                        move[name] = function(q, ...)
                            if vim.wo.diff then
                                local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                                for key, query in pairs(config or {}) do
                                    if q == query and key:find("[%]%[][cC]") then
                                        vim.cmd("normal! " .. key)
                                        return
                                    end
                                end
                            end
                            return fn(q, ...)
                        end
                    end
                end
            end,
        },

        config = function()
            -- See `:help nvim-treesitter`
            -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
            vim.defer_fn(function()
                ---@diagnostic disable-next-line: missing-fields
                require("nvim-treesitter.configs").setup({
                    ensure_installed = {
                        "regex",
                        "markdown",
                        "markdown_inline",
                        "lua",
                        "rust",
                        "typescript",
                        "javascript",
                        "bash",
                        "html",
                        "css",
                        "json5",
                        "yaml",
                        "sql",
                        "bash",
                        "jsonc",
                        "python",
                        "dockerfile",
                    },

                    auto_install = true,
                    highlight = { enable = true },
                    indent = { enable = true },

                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = "<C-space>",
                            node_incremental = "<C-space>",
                            scope_incremental = "<C-CR>",
                            node_decremental = "<bs>",
                        },
                    },

                    textobjects = {
                        select = {
                            enable = true,
                            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                            keymaps = {
                                -- You can use the capture groups defined in textobjects.scm (:TSEditQuery textobjects)
                                ["aa"] = { query = "@parameter.outer", desc = "Select around the parameter" },
                                ["ia"] = { query = "@parameter.inner", desc = "Select inside the parameter" },
                                ["af"] = { query = "@function.outer", desc = "Select around the function" },
                                ["if"] = { query = "@function.inner", desc = "Select inside of the function" },
                                ["ac"] = { query = "@class.outer", desc = "Select around the class" },
                                ["ic"] = { query = "@class.inner", desc = "Select inside of the class" },

                                ["al"] = { query = "@loop.outer", desc = "Select around the loop" },
                                ["il"] = { query = "@loop.inner", desc = "Select inside of the loop" },
                                ["as"] = { query = "@scope", query_group = "locals", desc = "Select around the scope" },
                            },
                        },

                        move = {
                            -- Jump to next and previous text objects
                            enable = true,
                            goto_next_start = {
                                ["]f"] = { query = "@function.outer", desc = "Goto next inner function start" },
                                ["]c"] = { query = "@class.outer", desc = "Goto next inner class start" },
                            },
                            goto_next_end = {
                                ["]F"] = { query = "@function.outer", desc = "Goto next outer function end" },
                                ["]C"] = { query = "@class.outer", desc = "Goto next outer class end" },
                            },
                            goto_previous_start = {
                                ["[f"] = { query = "@function.outer", desc = "Goto goto previous inner function start" },
                                ["[c"] = { query = "@class.outer", desc = "Previous inner class start" },
                            },
                            goto_previous_end = {
                                ["[F"] = { query = "@function.outer", desc = "Goto goto previous outer function start" },
                                ["[C"] = { query = "@class.outer", desc = "Goto previous outer class start" },
                            },
                        },

                        lsp_interop = {
                            enable = true,
                            border = "none",
                            floating_preview_opts = {},
                        },
                    },
                })
            end, 0)
        end,
    },
}
