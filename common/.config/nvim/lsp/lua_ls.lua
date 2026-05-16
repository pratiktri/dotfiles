return {
    cmd = { "lua-language-server" },
    filetype = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
                pathStrict = true,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
            telemetry = { enable = false },
        },
    },
}
