return {
    cmd = { "prettier", "--lsp" },
    filetypes = {
        "javascript",
        "typescript",
        "css",
        "scss",
        "html",
        "json",
        "yaml",
    },
    root_markers = { ".prettierrc", "package.json" },
}
