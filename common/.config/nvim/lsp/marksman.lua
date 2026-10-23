return {
    cmd = { "marksman", "server" },
    filetypes = { "markdown", "markdown.mdx" },
    -- Obsidian vaults are handled by markdown_oxide
    root_dir = function(bufnr, on_dir)
        if vim.fs.root(bufnr, ".obsidian") then
            return
        end
        on_dir(vim.fs.root(bufnr, { ".marksman.toml", ".git" }))
    end,
}
