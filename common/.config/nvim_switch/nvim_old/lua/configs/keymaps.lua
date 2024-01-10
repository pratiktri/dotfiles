-- Load Keybindings from VIM
local vim_mappings = os.getenv("HOME") .. "/.vim/key_maps.vim"
if vim.loop.fs_stat(vim_mappings) then
    vim.cmd("source " .. vim_mappings)
end

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- map <leader>j <Plug>(easymotion-s)
