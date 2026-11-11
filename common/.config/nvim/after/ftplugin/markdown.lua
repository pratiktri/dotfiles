require("shared.text_settings").setup()

-- Hugo: bump front-matter lastmod
vim.keymap.set("n", "<leader>hl", function()
    local ts = os.date("!%Y-%m-%dT%H:%M:%SZ")
    vim.cmd([[keeppatterns 1,/^---$/+1s/^lastmod:.*/lastmod: ']] .. ts .. [['/e]])
end, { buffer = true, desc = "Hugo: Bump lastmod" })
