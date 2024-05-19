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
            { "<C-a>", function() return M.dial(true) end, expr = true, desc = "Increment", mode = {"n", "v"} },
            { "<C-x>", function() return M.dial(false) end, expr = true, desc = "Decrement", mode = {"n", "v"} },
            { "g<C-a>", function() return M.dial(true, true) end, expr = true, desc = "Increment", mode = {"n", "v"} },
            { "g<C-x>", function() return M.dial(false, true) end, expr = true, desc = "Decrement", mode = {"n", "v"} },
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
                        augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
                        augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                        augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
                    },
                    typescript = {
                        augend.integer.alias.decimal, -- nonnegative and negative decimal number
                        augend.constant.alias.bool, -- boolean value (true <-> false)
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
                        augend.semver.alias.semver, -- versioning (v1.1.2)
                    },
                    lua = {
                        augend.integer.alias.decimal, -- nonnegative and negative decimal number
                        augend.constant.alias.bool, -- boolean value (true <-> false)
                        augend.constant.new({
                            elements = { "and", "or" },
                            word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
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
    { "christoomey/vim-tmux-navigator" },

    -- Navigate between NVIM & kitty splits
    {
        "knubie/vim-kitty-navigator",
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
        config = function()
            -- document existing key chains
            require("which-key").register({
                ["<leader>c"] = { name = "Code", _ = "which_key_ignore" },
                ["<leader>b"] = { name = "Buffer Operations", _ = "which_key_ignore" },
                ["<leader>d"] = { name = "Diagnostics", _ = "which_key_ignore" },
                ["<leader>f"] = { name = "File Operations", _ = "which_key_ignore" },
                ["<leader>g"] = { name = "Git", _ = "which_key_ignore" },
                ["<leader>h"] = { name = "Harpoon", _ = "which_key_ignore" },
                ["<leader>l"] = { name = "List Things", _ = "which_key_ignore" },
                ["<leader>n"] = { name = "NVIM Things", _ = "which_key_ignore" },
                ["<leader>q"] = { name = "Database Query", _ = "which_key_ignore" },
                ["<leader>r"] = { name = "Refactor Code", _ = "which_key_ignore" },
                ["<leader>s"] = { name = "Search/Grep Things", _ = "which_key_ignore" },
                ["<leader>t"] = { name = "Unit Test Operations", _ = "which_key_ignore" },
                ["<leader>x"] = { name = "Delete/Remove Something", _ = "which_key_ignore" },
            })
            -- register which-key VISUAL mode
            -- required for visual <leader>hs (hunk stage) to work
            require("which-key").register({
                ["<leader>"] = { name = "VISUAL <leader>" },
                ["<leader>h"] = { "Git Hunk" },
            }, { mode = "v" })
        end,
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
