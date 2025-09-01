return {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "twig", "hbs" },
    settings = {
        html = {
            format = { wrapLineLength = 120 },
        },
    },
}
