return {
    -- Render Markdown on Neovim
    {
        "MeanderingProgrammer/render-markdown.nvim",
        init = function()
            -- Define color variables
            local color1_bg = "#295715"
            local color2_bg = "#295477"
            local color3_bg = "#395499"
            local color4_bg = "#495477"
            local color5_bg = "#595477"
            local color6_bg = "#695477"
            local color_fg = "white"

            -- Heading colors (when not hovered over), extends through the entire line
            vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s]], color_fg, color1_bg))
            vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s]], color_fg, color2_bg))
            vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s]], color_fg, color3_bg))
            vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s]], color_fg, color4_bg))
            vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s]], color_fg, color5_bg))
            vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s]], color_fg, color6_bg))

            -- Highlight for the heading and sign icons (symbol on the left)
            vim.cmd(string.format([[highlight Headline1Fg cterm=bold gui=bold guifg=%s]], color1_bg))
            vim.cmd(string.format([[highlight Headline2Fg cterm=bold gui=bold guifg=%s]], color2_bg))
            vim.cmd(string.format([[highlight Headline3Fg cterm=bold gui=bold guifg=%s]], color3_bg))
            vim.cmd(string.format([[highlight Headline4Fg cterm=bold gui=bold guifg=%s]], color4_bg))
            vim.cmd(string.format([[highlight Headline5Fg cterm=bold gui=bold guifg=%s]], color5_bg))
            vim.cmd(string.format([[highlight Headline6Fg cterm=bold gui=bold guifg=%s]], color6_bg))
        end,
        opts = {
            latex = { enabled = false },
            preset = "obsidian",
            code = {
                sign = false,
                width = "block",
                border = "thin",
                position = "right",
                language_name = false,
                right_pad = 1,
                left_pad = 1,
            },
            heading = {
                icons = { "󰼏 ", "󰼐 ", "󰼑 ", "󰼒 ", "󰼓 ", "󰼔 " },
                sign = false,
                width = "block",
                right_pad = 1,
            },
            indent = { enabled = false, skip_heading = true, icon = "" },
            completions = { blink = { enabled = true } },
        },
        ft = { "markdown", "text", "gitcommit", "scratch" },
        config = function(_, opts)
            require("render-markdown").setup(opts)
            Snacks.toggle({
                name = "Markdown Rendering",
                get = function()
                    return require("render-markdown.state").enabled
                end,
                set = function(enabled)
                    local m = require("render-markdown")
                    if enabled then
                        m.enable()
                    else
                        m.disable()
                    end
                end,
            }):map("<leader>cM")
        end,
    },

    {
        "obsidian-nvim/obsidian.nvim",
        version = "*",
        enabled = true,
        opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "~/Code/Notes",
                },
            },
            completions = {
                blink = true,
                nvim_cmp = false,
            },
            comment = { enabled = true },
            attachments = { img_folder = ".artifacts/img" },
            footer = { format = "{{backlinks}} backlinks" },
            legacy_commands = false,
            ui = { enable = false },
            frontmatter = { enabled = false },
        },
    },

    {
        "bullets-vim/bullets.vim",
        ft = { "markdown", "text", "gitcommit", "scratch" },
        config = function()
            vim.g.bullets_enabled_file_types = {
                "markdown",
                "text",
                "gitcommit",
                "scratch",
            }
            vim.g.bullets_enable_in_empty_buffers = 0
            vim.g.bullets_set_mappings = 1
            vim.g.bullets_delete_last_bullet_if_empty = 1
            vim.g.bullets_line_spacing = 1
            vim.g.bullets_pad_right = 1
            vim.g.bullets_auto_indent_after_colon = 1
        end,
    },

    -- Paste clipboard image to markdown files
    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            default = {
                use_absolute_path = false, ---@type boolean
                relative_to_current_file = false, ---@type boolean
                use_cursor_in_template = true,

                -- Generic config, specifies inside `filetypes` section below
                dir_path = function()
                    local root = vim.fn.FindRootDirectory()
                    if root ~= "" then
                        return root .. "/.artifacts/img"
                    else
                        return vim.fn.expand("%:p:h") .. "/.artifacts/img"
                    end
                end,

                prompt_for_file_name = true, ---@type boolean
                file_name = "%y%m%d-%H%M%S", ---@type string

                extension = "webp", ---@type string
                process_cmd = "convert - -quality 75 webp:-", ---@type string
            },

            filetypes = {
                markdown = {
                    url_encode_path = true, ---@type boolean

                    template = "![$CURSOR](./$FILE_PATH)",

                    dir_path = function()
                        local root = vim.fn.FindRootDirectory()
                        if root ~= "" then
                            return root .. "/.artifacts/img"
                        else
                            return vim.fn.expand("%:p:h") .. "/.artifacts/img"
                        end
                    end,

                    file_name = "%y%m%d-%H%M%S",
                    extension = "webp", ---@type string
                    process_cmd = "convert - -resize 800x -quality 85 webp:-", ---@type string
                },
                -- TODO: Adapt for HTMLs
                -- html = {},
            },
        },
        -- TIP: Use :PasteImage
    },
}
