return {

    -- mini.nvim: Collection of various small independent plugins/modules
    {
        "echasnovski/mini.nvim",
        version = false,
        config = function()
            require("mini.comment").setup()
            require("mini.pairs").setup({
                modes = { insert = true, command = false, terminal = false },
            })
            -- Fixes auto-expand into newline with indent; adds an undo breakpoint before the newline
            vim.keymap.set("i", "<CR>", function()
                return vim.keycode("<C-g>u") .. MiniPairs.cr()
            end, { expr = true, replace_keycodes = false })

            -- mini.surround
            -- functionality similar to tpope's vim-surround
            require("mini.surround").setup({
                mappings = {
                    add = "ys",          -- add surrounding in normal and visual modes
                    delete = "ds",       -- delete surrounding
                    -- Off: `y` prefixed maps shadow `yf<char>`, `yF<char>` & `yh` yanks
                    find = "",           -- find surrounding (to the right)
                    find_left = "",      -- find surrounding (to the left)
                    highlight = "",      -- highlight surrounding
                    replace = "cs",      -- replace surrounding
                    update_n_lines = "", -- update `n_lines`
                },
                silent = true,
            })

            local statusline = require("mini.statusline")
            statusline.setup({
                use_icons = vim.g.have_nerd_font,
                content = {
                    active = function()
                        local config = require("config.util")

                        -- Helper functions for reading stats
                        local function is_prose_file()
                            local ft = vim.bo.filetype
                            return ft == "markdown" or ft == "text" or ft == "asciidoc"
                        end

                        local function reading_stats()
                            if not is_prose_file() then
                                return ""
                            end

                            -- recount only when the text changed and never while typing in insert mode
                            local typing = vim.api.nvim_get_mode().mode:find("^i") ~= nil
                            if (not typing or vim.b.word_count == nil) and vim.b.word_count_tick ~= vim.b.changedtick then
                                vim.b.word_count_tick = vim.b.changedtick
                                vim.b.word_count = vim.fn.wordcount().words or 0
                            end

                            local reading_time = math.ceil((vim.b.word_count or 0) / 100.0) -- I'm slow reader

                            return string.format("%dm %s |", reading_time, config.icons.misc.timer)
                        end

                        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                        local git = MiniStatusline.section_git({ trunc_width = 40 })
                        local diff = MiniStatusline.section_diff({
                            trunc_width = 75,
                            icon = config.icons.git.modified,
                        })
                        local diagnostics = MiniStatusline.section_diagnostics({
                            trunc_width = 75,
                            signs = config.icons.diagnostics,
                        })
                        local filename = MiniStatusline.section_filename({ trunc_width = 140 })
                        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120, show_encoding = false })
                        local search = MiniStatusline.section_searchcount({ trunc_width = 40 })
                        local location = MiniStatusline.section_location({ trunc_width = 75 })
                        local stats = reading_stats()

                        -- Mode | Branch, diff | Diagnostics | ... | FileName | FileType | Rows/Columns
                        return MiniStatusline.combine_groups({
                            { hl = mode_hl,                 strings = { mode } },
                            { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
                            { hl = mode_hl,                 strings = { diagnostics } },
                            "%<", -- Mark general truncate point
                            "%=", -- End left alignment
                            { hl = "MiniStatuslineFilename", strings = { filename } },
                            { hl = "MiniStatuslineFileinfo", strings = { stats, fileinfo } },
                            { hl = mode_hl,                  strings = { search, location } },
                        })
                    end,
                },
            })
        end,
    },

    -- Various Quality of Life plugins into one
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            layout = { enabled = false },
            statuscolumn = { enabled = false },

            -- `Whitespace`: default `NonText` guides are too bright
            indent = { enabled = true, indent = { hl = "Whitespace" } },
            -- `ii`/`ai` text objects & `[i`/`]i` jumps
            scope = { enabled = true },

            bufdelete = { enabled = true },
            git = { enabled = true },
            gitbrowse = {
                enabled = true,
                notify = true,
                url_patterns = {
                    ["git%.pratik%.live"] = {
                        branch = "/src/branch/{branch}",
                        file = "/src/branch/{branch}/{file}#L{line_start}-L{line_end}",
                        permalink = "/src/commit/{commit}/{file}#L{line_start}-L{line_end}",
                        commit = "/commit/{commit}",
                    },
                },
            },
            input = { enabled = true },
            image = {
                -- NOTE: Requires: ImageMagick & mermaid-cli installed
                enabled = true,
                doc = {
                    max_width = 80,
                    max_height = 68,
                    float = false,
                },
                img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments", ".artifacts/img", ".artifacts", ".assets" },
            },
            notifier = {
                enabled = true,
                timeout = 2000,
                style = "fancy",
            },
            explorer = { enabled = true, replace_netrw = true },
            terminal = { enabled = true, win = { position = "float", height = 0.6, width = 0.6 } },
            picker = { enabled = true, hidden = true },
            quickfile = { enabled = true },
            scratch = {
                enabled = true,
                ft = "markdown",
                root = vim.loop.os_homedir() .. "/Code/journal/scratch",
            },
            words = { enabled = true },
            zen = {
                enabled = true,
                toggles = { dim = false, git_signs = true },
                show = { tabline = true },
            },

            animate = {
                fps = 90,
                duration = { step = 10, total = 200 },
            },
            styles = {
                scratch = { width = 0.6, height = 0.6 },
                notification = { wo = { wrap = true } },
                notification_history = { width = 0.6, height = 0.6 },
            },
        },
        keys = {
            {
                "<leader>//",
                function()
                    Snacks.scratch()
                end,
                desc = "Toggle Scratch Buffer",
            },
            {
                "<leader><tab>",
                function()
                    Snacks.explorer()
                end,
                desc = "File Explorer",
            },
            {
                "<C-`>",
                function()
                    Snacks.terminal()
                end,
                desc = "Toggle Floating Terminal",
                mode = { "n", "t" },
            },
            {
                "<leader>/s",
                function()
                    Snacks.scratch.select()
                end,
                desc = "Select Scratch Buffer",
            },
            {
                "]]",
                function()
                    Snacks.words.jump(vim.v.count1)
                    vim.cmd("normal! zz")
                end,
                desc = "Next Reference",
                mode = { "n" },
            },
            {
                "[[",
                function()
                    Snacks.words.jump(-vim.v.count1)
                    vim.cmd("normal! zz")
                end,
                desc = "Prev Reference",
                mode = { "n" },
            },
            {
                "<leader>xx",
                function()
                    Snacks.notifier.hide()
                end,
                desc = "Hide Notifications",
            },
            {
                "<leader>nn",
                function()
                    Snacks.notifier.show_history()
                end,
                desc = "Notification History",
            },
            {
                "<C-Esc>",
                function()
                    Snacks.zen()
                end,
                desc = "Toggle Zen Mode",
            },

            -- Picker Keymaps
            -- Buffer
            {
                "<leader>bl",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "List Buffers",
            },

            -- Search
            {
                "<C-S-f>",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Search/LiveGrep the Project",
            },
            {
                "<C-p>",
                function()
                    Snacks.picker.files({ hidden = true })
                end,
                desc = "Search Files",
            },

            -- Git
            {
                "<leader>gL",
                function()
                    Snacks.git.blame_line()
                end,
                desc = "Git: Line Log",
            },
            {
                "<leader>gO",
                function()
                    Snacks.gitbrowse.open()
                end,
                desc = "Git: Open the file on Browser",
            },
            {
                "<leader>gf",
                function()
                    Snacks.picker.git_log_file()
                end,
                desc = "Git: File Log",
            },
            {
                "<leader>gc",
                function()
                    Snacks.picker.git_log()
                end,
                desc = "Git: Commits",
            },
            {
                "<leader>gb",
                function()
                    Snacks.picker.git_branches()
                end,
                desc = "Git: Branches",
            },
            {
                "<leader>gS",
                function()
                    Snacks.picker.git_stash()
                end,
                desc = "Git: List Stash",
            },

            -- Neovim Things
            {
                "<leader>nh",
                function()
                    Snacks.picker.help()
                end,
                desc = "Search NeoVIM Help",
            },
            {
                "<leader>np",
                function()
                    Snacks.picker.projects({
                        confirm = function(picker, item)
                            picker:close()
                            if not item then
                                return
                            end

                            -- Save the current session before leaving the project
                            if package.loaded.persistence then
                                require("persistence").save()
                            end

                            -- Asks to save modified buffers
                            Snacks.bufdelete.all()
                            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                                if vim.bo[buf].buflisted and vim.bo[buf].modified then
                                    Snacks.notify.warn("Unsaved buffers, project not switched")
                                    return
                                end
                            end

                            -- LSP clients are rooted in the old project
                            vim.lsp.stop_client(vim.lsp.get_clients())
                            Snacks.picker.actions.load_session(picker, item)
                        end,
                    })
                end,
                desc = "Search Recent Projects",
            },
            {
                "<leader>nm",
                function()
                    Snacks.picker.man()
                end,
                desc = "Help: System Man Pages",
            },
            {
                "<leader>nk",
                function()
                    Snacks.picker.keymaps()
                end,
                desc = "Help: NeoVIM Keymaps",
            },
            {
                "<leader>ns",
                function()
                    Snacks.picker.search_history()
                end,
                desc = "Search History",
            },
            {
                "<leader>nH",
                function()
                    Snacks.picker.command_history()
                end,
                desc = "Command History",
            },
            {
                "<leader>nc",
                function()
                    Snacks.picker.colorschemes()
                end,
                desc = "Colorschemes (with preview)",
            },
        },
    },

    -- Navigate between NVIM & kitty splits
    {
        "knubie/vim-kitty-navigator",
        enabled = function()
            -- Kitty isn't available on Windows
            return vim.loop.os_uname().sysname ~= "Windows_NT"
        end,
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
        config = function()
            require("kitty-scrollback").setup({
                -- Global options: first element, no key
                {
                    status_window = {
                        icons = { nvim = "" },
                    },
                },
            })
        end,
    },

    -- Changes the Nvim root to git root
    {
        "airblade/vim-rooter",
        config = function()
            vim.g.rooter_cd_cmd = "tcd" -- Use tcd command to change the root
            vim.g.rooter_patterns = { ".git" }
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
        opts = {
            delay = 450,
            preset = "helix",
            warning = true,
            -- Document existing key chains
            spec = {
                { "<leader>u", desc = "Undo History", icon = { icon = "󰁯", color = "orange" } },
                { "<leader>Q", desc = "Execute DB query under cursor", icon = { icon = "", color = "orange" } },
                { "<leader>o", desc = "Hierarchical Document Symbols", icon = { icon = "", color = "orange" } },
                { "<leader>s", desc = "Search Document Symbols", icon = { icon = "", color = "orange" } },
                { "<leader>S", desc = "Search Workspace Symbols", icon = { icon = "", color = "orange" } },
                { "<leader>y", desc = "Copy to system clipboard", icon = { icon = "", color = "orange" } },
                { "<leader>p", desc = "Paste system clipboard", icon = { icon = "󰆏", color = "orange" } },
                { "<leader><tab>", desc = "File Explorer", icon = { icon = "", color = "orange" } },

                { "<leader>a", group = "AI", icon = { icon = "", color = "orange" } },
                { "<leader>b", group = "Buffer Operations", icon = { icon = "", color = "orange" } },
                { "<leader>c", group = "Code", icon = { icon = "󰗀", color = "orange" } },
                { "<leader>d", group = "Diagnostics", icon = { icon = "󰓙", color = "orange" } },
                { "<leader>D", group = "Debug", icon = { icon = "", color = "orange" } },
                { "<leader>g", group = "Git", icon = { icon = "", color = "orange" } },
                { "<leader>n", group = "Neovim Things", icon = { icon = "", color = "orange" } },
                { "<leader>q", group = "Database", icon = { icon = "", color = "orange" } },
                { "<leader>t", group = "Unit Test", icon = { icon = "", color = "orange" } },
                { "<leader>x", group = "Delete/Disable/Remove", icon = { icon = "󰆴", color = "orange" } },
                { "<leader>/", group = "Quick Project Notes", icon = { icon = "󰠮", color = "orange" } },
            },
        },
    },

    -- Session management. Saves your session in the background
    -- TIP: autocmd to autoload sessions at: ../config/autocmd.lua
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {
            -- ~/.config/nvim/sessions/
            dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"),
        },
    },
}
