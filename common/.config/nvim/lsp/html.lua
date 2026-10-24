return {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "twig", "hbs", "gohtmltmpl" },
    settings = {
        html = {
            format = { wrapLineLength = 120 },
        },
    },
}
