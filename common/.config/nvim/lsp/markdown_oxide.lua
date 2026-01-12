return {
    cmd = { "markdown-oxide" },
    filetypes = { "markdown" },
    root_markers = { ".obsidian" },
    workspace_required = true,
    settings = {
        markdown_oxide = {
            hover = false,
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
