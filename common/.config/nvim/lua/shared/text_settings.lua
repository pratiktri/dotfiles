local M = {}

function M.setup()
    vim.opt_local.spell = true

    vim.keymap.set("v", "<leader>ml", function()
        vim.cmd('normal! "vygvc ') -- Save selected text to register 'v' & delete the text

        -- Copy the system clipboard
        local clipboard_content = vim.fn.getreg("+")
        -- Insert the markdown link
        local link = string.format("[%s](%s)", vim.fn.getreg("v"), clipboard_content)

        vim.api.nvim_put({ link }, "c", false, true)
        vim.cmd("normal! T[vt]") -- Move cursor inside the square brackets & visually select text
    end, { desc = "Markdown: Create link from system clipboard" })
end

return M
