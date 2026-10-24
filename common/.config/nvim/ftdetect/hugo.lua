-- Hugo layouts are plain .html files with Go template syntax
vim.filetype.add({
    pattern = {
        [".*/layouts/.*%.html"] = "gohtmltmpl",
    },
})
