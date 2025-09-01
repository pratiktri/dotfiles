return {
    cmd = { "markdown-oxide" },
    filetypes = { "markdown" },
    root_dir = function()
        return vim.fn.getcwd()
    end,
    settings = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
}
