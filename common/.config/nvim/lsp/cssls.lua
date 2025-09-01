return {
    cmd = { "vscode-css-language-server", "--studio" },
    filetypes = { "css", "scss", "less" },
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
}
