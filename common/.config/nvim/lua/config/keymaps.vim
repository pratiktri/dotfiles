" Make space-bar the leader-key
let mapleader = " "
let maplocalleader = " "

" Don't do anything on pressing space itself
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>

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

" Ctrl+Backspace to add an undo-point and delete last word
imap <C-BS> <C-g>u<C-w>

" Unbind some useless/annoying default key bindings.
nmap Q <Nop>

" Center the cursor when moving through document
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap gv gvzz
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
nnoremap ]s ]szz
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap G Gzz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap * *zzv
nnoremap # #zzv

" Move visually selected lines around with J & K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Better indenting
vnoremap <  <gv
xnoremap <  <gv
vnoremap >  >gv
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
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>
nnoremap <leader>bx :bd<CR>

" Navigate Quickfix
nnoremap [q :cprev<CR>zz
nnoremap ]q :cnext<CR>zz

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

" <ctrl-q> Quit Vim (without saving)
" <ctrl-s> Save all buffers
nnoremap <C-q> :q<CR>
vnoremap <C-q> :q<CR>
nnoremap <C-s> :wa<CR>
vnoremap <C-s> :wa<CR>

" Paste over currently selected text without yanking it
vnoremap p "_dp
vnoremap P "_dP

" Copy everything between { & } including brackets
nnoremap YY va{Vy

" Move Lines with Alt+j,k
nnoremap <M-j> :m .+1<cr>==
nnoremap <M-k> :m .-2<cr>==
vnoremap <M-j> :m '>+1<cr>gv=gv
vnoremap <M-k> :m '<-2<cr>gv=gv

" Evaluate expression of the highlighted text and paste at the end
vnoremap <leader>= y`]a = <C-r>=<C-r>"<CR><Esc>

" Insert mode: add undo points on "," & "." & ";"
imap , ,<C-g>u
imap . .<C-g>u
imap ; ;<C-g>u

" Copy to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
" To paste from system clipboard "+p

" Clear search, diff update and redraw
nnoremap <Esc> :nohlsearch<CR>:diffupdate<CR>:normal! <C-L><CR>
