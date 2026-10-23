return {
    cmd = { "vscode-json-language-server", "--stdio" },
    settings = {
        json = {
            format = { enable = true },
            validate = { enable = true },
        },
    },
}
