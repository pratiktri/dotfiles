return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl", "gohtmltmpl" },
    root_markers = { "go.mod", "go.work", "hugo.toml", "hugo.yaml", "config.toml", ".git" },
    settings = {
        gopls = {
            templateExtensions = { "html" },
        },
    },
}
