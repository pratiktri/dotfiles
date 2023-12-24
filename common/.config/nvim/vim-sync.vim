""""""""""""""""""""""""""""""""""""""
"
" Source common configs from VIM
"
""""""""""""""""""""""""""""""""""""""
let $VIMDIR="$HOME/.vim"
let $NVIMDIR="$HOME/.config/nvim"

" Load VIM Configurations
source $VIMDIR/configs.vim

" Load Keybindings from VIM
source $VIMDIR/key_maps.vim

" Save session files to $HOME/.vim/session directory
let g:session_dir="$VIMDIR/session"

