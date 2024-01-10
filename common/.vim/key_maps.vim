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

" Don't do anything on pressing space itself
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>

" Make space-bar the leader-key
let mapleader = " "
let maplocalleader = " "

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

" Move visually selected lines around with J & K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Better indenting
vnoremap <  <gv
vnoremap >  >gv
xnoremap <  <gv
xnoremap >  >gv

" Keeps the cursor at the same place when doing J
" And not move to end of the line
nnoremap J mzJ`z:delmarks z<CR>

" Better Up/Down
nnoremap j gj
xnoremap j gj
nnoremap k gk
xnoremap k gk

" Better window/split navigation
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

" Navigate buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Resize window using <ctrl> arrow keys
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Saner search n & N
nnoremap <expr> n  'Nn'[v:searchforward]
xnoremap <expr> n  'Nn'[v:searchforward]
onoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]
xnoremap <expr> N  'nN'[v:searchforward]
onoremap <expr> N  'nN'[v:searchforward]

" Clear search highlights
nnoremap <esc> :nohlsearch<CR><esc>
inoremap <esc> :nohlsearch<CR><esc>

" <ctrl-q> to save everything and quit Neovim
nnoremap <C-q> :wqa<CR>
vnoremap <C-q> :wqa<CR>
nnoremap <C-s> :wa<CR>
vnoremap <C-s> :wa<CR>

" Move cursor in insert mode
inoremap <C-b> <ESC>^i
inoremap <C-e> <END>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <Down>
inoremap <C-k> <Up>

" Copy entire content of the current buffer
nnoremap <C-c> :%y+<CR>

" Clear search, diff update and redraw
nnoremap <leader>/ :nohlsearch<CR>:diffupdate<CR>:normal! <C-L><CR>

" Changes the pwd to the opened file's directory
nnoremap <leader>cd :lcd %:h<CR>

map <leader>j <Plug>(easymotion-s)
