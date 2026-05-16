return {
    cmd = { "markdown-oxide" },
    filetypes = { "markdown" },
    root_markers = { ".obsidian" },
    workspace_required = true,
    get_language_id = function(bufnr, filetype)
        if vim.bo[bufnr].buftype ~= "" then
            return nil -- signals: don't attach
        end
        return filetype
    end,
    settings = {
        markdown_oxide = {
            hover = true,
        },
        markdown = {
            workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            },
        },
    },
}
