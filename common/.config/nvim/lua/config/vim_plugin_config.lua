-- Load Plugin configs from VIM
local vim_plugin_config = os.getenv("HOME") .. "/.vim/plugin_config.vim"
if vim.loop.fs_stat(vim_plugin_config) then
    vim.cmd("source " .. vim_plugin_config)
end
