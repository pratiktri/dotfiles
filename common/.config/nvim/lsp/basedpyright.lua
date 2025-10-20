return {
    cmd = { "basedpyright" },
    filetypes = { "python" },
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "basic",
                diagnosticMode = "openFilesOnly",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
            disableOrganizeImports = true, -- let ruff do it
        },
        python = { analysis = { ignore = { "*" } } }, -- let ruff do it
    },
}
