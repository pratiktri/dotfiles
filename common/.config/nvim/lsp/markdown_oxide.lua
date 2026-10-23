return {
    cmd = { "markdown-oxide" },
    filetypes = { "markdown" },
    root_markers = { ".obsidian" },
    workspace_required = true,
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
    settings = {
        markdown_oxide = {
            hover = true,
        },
    },
}
