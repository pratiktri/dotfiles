return {
    -- Render Markdown on Neovim
    {
        "MeanderingProgrammer/render-markdown.nvim",
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
                drag_and_drop = { enabled = false },
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
