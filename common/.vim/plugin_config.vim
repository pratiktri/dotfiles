" NERDTree Plugin configurations
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 25

" Map easymotion Plugin to <Leader>j
nnoremap <leader>j <Plug>(easymotion-s)

" Show the undo tree
nnoremap <leader>u :UndotreeToggle<CR>

" Fugitive
nnoremap <leader>gg :0G<cr>

" Quickscope
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Quickscope in VSCode
" https://github.com/vscode-neovim/vscode-neovim/wiki/Plugins#quick-scope
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
