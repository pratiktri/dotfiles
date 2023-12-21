" Better autocompletes
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete
set complete+=kspell

" Make sure tabs are 4 character wide
set shiftwidth=4 tabstop=4 softtabstop=4 expandtab
set autoindent smartindent

syntax on " syntax highlighting.
set showmatch " Highlight matching braces
set ls=2 " Show a status line
set wrap " Wrap text
set wildmenu " Makes the ex command mode autocomplete paths with Tab
set number " Show line numbers
set relativenumber " Relative line numbers
set shortmess+=I " Disable the default Vim startup message.
set noerrorbells visualbell t_vb= " Disable audible bell because it's annoying.
set mouse+=a " Enable mouse support
set encoding=utf-8 " Encoding

" Vim, by default, won't let you jump to a different file without saving the
" current one. With the below, unsaved files are just hidden.
set hidden

" Enable searching as you type, rather than waiting till you press enter.
" Highlight search pattern
" Intelligently handle cases in search
set incsearch hlsearch ignorecase smartcase

" Comments in Grey color and italic
hi Comment guifg=#5C6370 ctermfg=50 cterm=italic

" Highlight and remove trailing blank spaces on save
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWritePre * %s/\s\+$//e

" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Normally, backspace works only if you have made an edit. This fixes that.
set backspace=indent,eol,start

" Sync vim clipboard with system clipboard
" Works across Linux, MacOS & Windows
if has("mac")
    set clipboard+=unnamed
else
    set clipboard^=unnamed,unnamedplus
endif

" Set color
if !has('gui_running')
  set t_Co=256
  set termguicolors
  hi LineNr ctermbg=NONE guibg=NONE
endif

