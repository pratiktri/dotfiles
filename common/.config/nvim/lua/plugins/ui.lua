return {
    -- icons
    "nvim-tree/nvim-web-devicons",

    -- ui components
    "MunifTanjim/nui.nvim",

    -- Better vim.ui
    "stevearc/dressing.nvim",

    {
        "projekt0n/github-nvim-theme",
        priority = 1000,
        config = function()
            require("github-theme").setup({
                options = {
                    terminal_colors = false,
                    styles = {
                        comments = "italic",
                        constants = "bold",
                    },
                },
            })
            vim.cmd("colorscheme github_dark")
        end,
    },

    -- Show buffers like VS Code tabs
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                close_command = function(n)
                    Snacks.bufdelete.delete(n, false)
                end,
                right_mouse_command = function(n)
                    Snacks.bufdelete.delete(n, false)
                end,
                diagnostics = "nvim_lsp",
                always_show_bufferline = false,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                    },
                },
            },
        },
        config = function(_, opts)
            local buf_line = require("bufferline")
            buf_line.setup(opts)

            -- <alt+1> ... <alt+9> to switch to a buffer
            for i = 1, 9 do
                vim.keymap.set(
                    { "n", "v" },
                    string.format("<A-%s>", i),
                    string.format("<cmd>BufferLineGoToBuffer %s<CR>", i),
                    { noremap = true, silent = true }
                )
            end

            -- Fix bufferline when restoring a session
            vim.api.nvim_create_autocmd("BufAdd", {
                callback = function()
                    vim.schedule(function()
                        pcall(buf_line)
                    end)
                end,
            })
        end,
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle buffer-pin" },
            { "<leader>bX", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
            { "<leader>xo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
            { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
            { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
        },
    },

    -- Completely replaces the UI for messages, cmdline and the popupmenu.
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            views = {
                cmdline_popup = {
                    position = {
                        row = "98%", -- Above statusline
                        col = "0%",
                    },
                },
            },
            lsp = {
                progress = {
                    throttle = 1000 / 100,
                },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                hover = {
                    silent = true,
                },
            },
            routes = {
                {
                    -- Show popup message when @recording macros
                    view = "notify",
                    filter = { event = "msg_showmode" },
                },
                {
                    filter = { event = "notify", find = "No information available" },
                    opts = { skin = true },
                },
                {
                    -- Direct some messages to bottom - obove statusline
                    view = "mini",
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },

                            -- When message contains following
                            { find = "yanked" },
                            { find = "fewer lines" },
                            { find = "more lines" },
                            { find = "EasyMotion" },
                            { find = "Target key" },
                            { find = "search hit BOTTOM" },
                            { find = "lines to indent" },
                            { find = "lines indented" },
                            { find = "lines changed" },
                            { find = ">ed" },
                            { find = "<ed" },
                            { find = "The only match" },
                            { find = "DB:" },
                            { find = "cwd:" },
                        },
                    },
                },
            },
            presets = {
                lsp_doc_border = true,
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
            },
        },
    },

    -- Indent guides for Neovim
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

    -- Better folds
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
            close_fold_kinds_for_ft = { default = { "imports", "comment" } },
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
        end,
    },
}
