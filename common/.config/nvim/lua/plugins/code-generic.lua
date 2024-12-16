return {

    -- TODO:
    -- Reduce noice timeout
    { "tpope/vim-repeat" },

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
            require("mini.ai").setup({ n_lines = 500 })

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require("mini.surround").setup()

            -- gc
            require("mini.comment").setup()

            require("mini.pairs").setup()
            -- require("mini.completion").setup()
        end,
    },

    -- Automatically highlights other instances of the word under cursor
    {
        "RRethy/vim-illuminate",
        lazy = false,
        opts = {
            delay = 200,
            large_file_cutoff = 2000,
            large_file_override = {
                providers = { "lsp" },
            },
        },
        config = function(_, opts)
            -- Copied from LazyNvim
            require("illuminate").configure(opts)

            local function map(key, dir, buffer)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. dir .. "_reference"](false)
                end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
            end

            map("]]", "next")
            map("[[", "prev")

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map("]]", "next", buffer)
                    map("[[", "prev", buffer)
                end,
            })
        end,
        keys = {
            { "]]", desc = "Next Reference" },
            { "[[", desc = "Prev Reference" },
        },
    },

    -- Finds and lists all of the TODO, HACK, BUG, etc comment
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
        opts = {
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

            -- TODO: Include hidden files
            { "<leader>fT", "<cmd>TodoTelescope<cr>", desc = "List Todo/Fix/Fixme" },
            { "<leader>ft", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "List Todo" },
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
                "<leader>O",
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
                require("nvim-treesitter.configs").setup({
                    ensure_installed = {
                        -- These 2 are required for cmdline
                        "regex",
                        "markdown",
                        "markdown_inline",
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
                            -- peek_definition_code = {
                            --     ["<leader>cd"] = { query = "@function.outer", desc = "Peek function definition on a popup" },
                            --     ["<leader>cD"] = { query = "@class.outer", desc = "Peek class definition on a popup" },
                            -- },
                        },
                    },
                })
            end, 0)
        end,
    },
}
