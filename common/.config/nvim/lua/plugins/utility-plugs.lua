local M = {}
---@type table<string, table<string, string[]>>
M.dials_by_ft = {}

---@param increment boolean
---@param g? boolean
function M.dial(increment, g)
    local mode = vim.fn.mode(true)
    -- Use visual commands for VISUAL 'v', VISUAL LINE 'V' and VISUAL BLOCK '\22'
    local is_visual = mode == "v" or mode == "V" or mode == "\22"
    local func = (increment and "inc" or "dec") .. (g and "_g" or "_") .. (is_visual and "visual" or "normal")
    local group = M.dials_by_ft[vim.bo.filetype] or "default"
    return require("dial.map")[func](group)
end

return {
    -- Better increment/decrement with <Ctrl+a>
    {
        "monaqa/dial.nvim",
        -- stylua: ignore
        keys = {
            { "<C-a>",  function() return M.dial(true) end,        expr = true, desc = "Increment", mode = { "n", "v" } },
            { "<C-x>",  function() return M.dial(false) end,       expr = true, desc = "Decrement", mode = { "n", "v" } },
            { "g<C-a>", function() return M.dial(true, true) end,  expr = true, desc = "Increment", mode = { "n", "v" } },
            { "g<C-x>", function() return M.dial(false, true) end, expr = true, desc = "Decrement", mode = { "n", "v" } },
        },
        opts = function()
            local augend = require("dial.augend")

            local logical_alias = augend.constant.new({
                elements = { "&&", "||" },
                word = false,
                cyclic = true,
            })

            local ordinal_numbers = augend.constant.new({
                -- elements through which we cycle. When we increment, we go down
                -- On decrement we go up
                elements = {
                    "first",
                    "second",
                    "third",
                    "fourth",
                    "fifth",
                    "sixth",
                    "seventh",
                    "eighth",
                    "ninth",
                    "tenth",
                },
                -- if true, it only matches strings with word boundary. firstDate wouldn't work for example
                word = false,
                -- do we cycle back and forth (tenth to first on increment, first to tenth on decrement).
                -- Otherwise nothing will happen when there are no further values
                cyclic = true,
            })

            local weekdays = augend.constant.new({
                elements = {
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday",
                    "Saturday",
                    "Sunday",
                },
                word = true,
                cyclic = true,
            })

            local months = augend.constant.new({
                elements = {
                    "January",
                    "February",
                    "March",
                    "April",
                    "May",
                    "June",
                    "July",
                    "August",
                    "September",
                    "October",
                    "November",
                    "December",
                },
                word = true,
                cyclic = true,
            })

            local capitalized_boolean = augend.constant.new({
                elements = {
                    "True",
                    "False",
                },
                word = true,
                cyclic = true,
            })

            return {
                dials_by_ft = {
                    css = "css",
                    javascript = "typescript",
                    javascriptreact = "typescript",
                    json = "json",
                    lua = "lua",
                    markdown = "markdown",
                    python = "python",
                    sass = "css",
                    scss = "css",
                    typescript = "typescript",
                    typescriptreact = "typescript",
                    cs = "csharp",
                },
                groups = {
                    default = {
                        augend.integer.alias.decimal,  -- nonnegative decimal number (0, 1, 2, 3, ...)
                        augend.integer.alias.hex,      -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                        augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
                    },
                    typescript = {
                        augend.integer.alias.decimal, -- nonnegative and negative decimal number
                        augend.constant.alias.bool,   -- boolean value (true <-> false)
                        logical_alias,
                        augend.constant.new({ elements = { "let", "const" } }),
                        ordinal_numbers,
                        weekdays,
                        months,
                    },
                    css = {
                        augend.integer.alias.decimal, -- nonnegative and negative decimal number
                        augend.hexcolor.new({
                            case = "lower",
                        }),
                        augend.hexcolor.new({
                            case = "upper",
                        }),
                    },
                    markdown = {
                        augend.misc.alias.markdown_header,
                        ordinal_numbers,
                        weekdays,
                        months,
                    },
                    json = {
                        augend.integer.alias.decimal, -- nonnegative and negative decimal number
                        augend.semver.alias.semver,   -- versioning (v1.1.2)
                    },
                    lua = {
                        augend.integer.alias.decimal, -- nonnegative and negative decimal number
                        augend.constant.alias.bool,   -- boolean value (true <-> false)
                        augend.constant.new({
                            elements = { "and", "or" },
                            word = true,   -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                            cyclic = true, -- "or" is incremented into "and".
                        }),
                        ordinal_numbers,
                        weekdays,
                        months,
                    },
                    python = {
                        augend.integer.alias.decimal, -- nonnegative and negative decimal number
                        capitalized_boolean,
                        logical_alias,
                        ordinal_numbers,
                        weekdays,
                        months,
                    },
                },
            }
        end,
        config = function(_, opts)
            require("dial.config").augends:register_group(opts.groups)
            M.dials_by_ft = opts.dials_by_ft
        end,
    },

    -- Navigate between NVIM & Tmux splits seamlessly
    {
        "christoomey/vim-tmux-navigator",
        cond = require("config.util").is_not_vscode(),
    },

    -- Navigate between NVIM & kitty splits
    {
        "knubie/vim-kitty-navigator",
        cond = require("config.util").is_not_vscode(),
        build = "cp ./*.py ~/.config/kitty/",
        keys = {
            { "<C-S-h>", "<cmd>KittyNavigateLeft<cr>" },
            { "<C-S-j>", "<cmd>KittyNavigateDown<cr>" },
            { "<C-S-k>", "<cmd>KittyNavigateUp<cr>" },
            { "<C-S-l>", "<cmd>KittyNavigateRight<cr>" },
        },
    },

    -- Open Kitty terminal scrollback as buffer
    {
        "mikesmithgh/kitty-scrollback.nvim",
        lazy = true,
        cond = require("config.util").is_not_vscode(),
        cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
        event = { "User KittyScrollbackLaunch" },
        version = "^4.0.0",
        opts = {
            status_window = {
                icons = { nvim = "" },
            },
        },
        config = function()
            require("kitty-scrollback").setup()
        end,
    },

    -- Changes the Nvim root to git root
    {
        "airblade/vim-rooter",
        cond = require("config.util").is_not_vscode(),
        config = function()
            vim.g.rooter_cd_cmd = "tcd" -- Use tcd command to change the root
        end,
    },

    -- Display undotree
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree panel" },
        },
    },

    {
        "folke/which-key.nvim",
        dependencies = {
            "echasnovski/mini.icons",
        },
        opts = {
            defaults = {
                ["<leader>r"] = { name = "+refactor" },
            },
            icons = {
                -- set icon mappings to true if you have a Nerd Font
                mappings = vim.g.have_nerd_font,
                -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
                -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
                keys = vim.g.have_nerd_font and {} or {
                    Up = '<Up> ',
                    Down = '<Down> ',
                    Lefj = '<Left> ',
                    Right = '<Right> ',
                    C = '<C-…> ',
                    M = '<M-…> ',
                    D = '<D-…> ',
                    S = '<S-…> ',
                    CR = '<CR> ',
                    Esc = '<Esc> ',
                    ScrollWheelDown = '<ScrollWheelDown> ',
                    ScrollWheelUp = '<ScrollWheelUp> ',
                    NL = '<NL> ',
                    BS = '<BS> ',
                    Space = '<Space> ',
                    Tab = '<Tab> ',
                    F1 = '<F1>',
                    F2 = '<F2>',
                    F3 = '<F3>',
                    F4 = '<F4>',
                    F5 = '<F5>',
                    F6 = '<F6>',
                    F7 = '<F7>',
                    F8 = '<F8>',
                    F9 = '<F9>',
                    F10 = '<F10>',
                    F11 = '<F11>',
                    F12 = '<F12>',
                },
            },

            -- Document existing key chains
            spec = {
                { "<leader>c", group = "Code" },
                { "<leader>b", group = "Buffer Operations" },
                { "<leader>d", group = "Diagnostics" },
                { "<leader>f", group = "File Operations" },
                { "<leader>g", group = "Git" },
                { "<leader>f", group = "Find and List Things" },
                { "<leader>n", group = "NVIM Things" },
                { "<leader>q", group = "Database Query" },
                { "<leader>s", group = "Search/Grep Things" },
                { "<leader>t", group = "Unit Test Operations" },
                { "<leader>x", group = "Delete/Remove Something" },
            },
        },
    },

    -- Session management. Saves your session in the background
    -- TIP: autocmd to autoload sessions at: ../config/autocmd.lua
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            -- Session files stored at: ~/.config/nvim/sessions/
            dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
        },
    },

    -- Speedup loading large files by disabling some plugins
    {
        "LunarVim/bigfile.nvim",
        cond = require("config.util").is_not_vscode(),
        lazy = true,
        opts = {
            filesize = 2, --2MiB
            pattern = "*",
            features = {
                "indent_blankline",
                "lsp",
                "syntax",
                "treesitter",
            },
        },
    },
}
