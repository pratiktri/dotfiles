return {
    -- Render Markdown on Neovim
    {
        "MeanderingProgrammer/render-markdown.nvim",
        cond = require("config.util").is_not_vscode(),
        init = function()
            -- Define color variables
            local color1_bg = "#295715"
            local color2_bg = "#8d8200"
            local color3_bg = "#a56106"
            local color4_bg = "#7e0000"
            local color5_bg = "#1e0b7b"
            local color6_bg = "#560b7b"
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
            code = {
                render_modes = true,
                sign = false,
                width = "block",
                border = "thick",
                position = "right",
                language_name = false,
                right_pad = 1,
            },
            heading = {
                sign = false,
                icons = {},
                backgrounds = {
                    "Headline1Bg",
                    "Headline2Bg",
                    "Headline3Bg",
                    "Headline4Bg",
                    "Headline5Bg",
                    "Headline6Bg",
                },
                foregrounds = {
                    "Headline1Fg",
                    "Headline2Fg",
                    "Headline3Fg",
                    "Headline4Fg",
                    "Headline5Fg",
                    "Headline6Fg",
                },
            },
            pipe_table = {
                preset = "round",
            },
            indent = {
                enabled = true,
                skip_heading = true,
            },
        },
        ft = { "markdown", "norg", "rmd", "org" },
        config = function(_, opts)
            require("render-markdown").setup(opts)
            Snacks.toggle({
                name = "Markdown Render",
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
        "bullets-vim/bullets.vim",
        cond = require("config.util").is_not_vscode(),
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

                dir_path = function()
                    -- TODO: Find a path consistent for both Obsidian and github
                    return vim.fn.expand("%:t:r") .. "-img"
                end,

                prompt_for_file_name = false, ---@type boolean
                file_name = "%y%m%d-%H%M%S", ---@type string

                -- Format of the image to be saved, must convert it as well
                -- https://stackoverflow.com/a/27269260
                extension = "webp", ---@type string
                process_cmd = "convert - -quality 75 webp:-", ---@type string
            },

            filetypes = {
                markdown = {
                    url_encode_path = true, ---@type boolean

                    -- The template is what specifies how the alternative text and path
                    -- of the image will appear in your file
                    -- I want to use blink.cmp to easily find images with the LSP, so adding ./
                    template = "![Image](./$FILE_PATH)",

                    -- template = "![$FILE_NAME]($FILE_PATH)", ---@type string
                },
            },
        },
        -- TIP: Use :PasteImage
    },

    -- View images in Neovim
    {
        "3rd/image.nvim",
        build = false,
        opts = {
            -- Use ImageMagick (Fedora) or imagemagick (Debian) installed
            processor = "magick_cli",
        },
    },
}
