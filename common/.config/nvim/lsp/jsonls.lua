return {
    cmd = { "vscode-json-languageserver", "--stdio" },
    settings = {
        json = {
            format = { enable = true },
            validate = { enable = true },
        },
    },
}
