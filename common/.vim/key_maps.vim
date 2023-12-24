" Disable left, right, up and down keys
" In normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

" Unbind some useless/annoying default key bindings.
nmap Q <Nop>

" Center the cursor when moving through document
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
nnoremap ]s ]szz
nnoremap n nzzzv
nnoremap N Nzzzv

" Better window/split navigation
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

" Clear searches
nnoremap <Leader>/ :call clearmatches()<CR>:noh<CR>

" Make space-bar the leader-key
let mapleader = " "

" Changes the pwd to the opened file's directory
nnoremap <leader>cd :lcd %:h<CR>

" Map easymotion Plugin to <Leader>j
map <leader>j <Plug>(easymotion-s)

" Map nerdtree to <Leader>e
" Changes the pwd and opens the VCS root
nnoremap <leader>e :lcd %:h<CR> :NERDTreeToggleVCS<CR>
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 20

