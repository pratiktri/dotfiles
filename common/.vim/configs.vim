syntax on                   " Syntax highlighting.
set nocompatible            " Do not worry about backward compatibility with VI
set cursorline              " Hightlight cursor line
set showmatch               " Highlight matching braces
set noshowmode              " Donot write "--INSERT--" etc.
set showcmd                 " Write out commands on status line
set laststatus=2            " Show a status line
set wrap                    " Wrap text
set number                  " Show line numbers
set relativenumber          " Relative line numbers
set ruler                   " Show the line & column number of the cursor
set shortmess+=I            " Disable the default Vim startup message.
set shortmess+=s            " Less verbose search messages
set mouse+=a                " Enable mouse support
set encoding=utf-8          " Encoding
set autowrite               " Enable auto write
set autoread                " Auto reload file if externally changed
set nrformats-=octal        " Do not let Ctrl-a + Ctrl-x work on octal format numbers
set formatoptions=jcroqlnt  " When joining lines with J, delete comment characters
set display+=truncate       " @@@ is displayed in the 1st column of the last screen line
set tabpagemax=50           " Max number of tabs
set viminfo^=!
set viewoptions-=options
set nolangremap             " Do not use non-English keyboards to define keymaps
set list                    " Show tabs as >, trailing spaces as -, non-breakable space as +
set signcolumn=yes          " Always show the signs column (before line number column)
set scrolloff=10            " Cursor always at middle of the screen
set sidescrolloff=10
set updatetime=200          " No typing for this millisec -> write to swap file
set timeoutlen=500          " Multiple keys in keymaps must be pressed in these millisecs
set noswapfile              " Turn off swapfiles
set history=10000           " Number of : commands to save
set undofile                " Turn on undofiles (files not compatible across Vim & Nvim
set undolevels=10000        " Number of undos per file (will be stored in memory)
set undoreload=100000       " Amount of memory to use when reloading the buffer with :e!
set sessionoptions-=options " Do NOT save options and mappings in session
set splitbelow              " Split new windows at bottom instead of top
set splitright              " New vertical windows on right instead of left
set hidden                  " Allows to change buffer without saving it 1st
set virtualedit=block       " Makes visual block better when selecting different line sizes
set ignorecase              " When trying to autocomplete commands or searching, ignore case
set noerrorbells novisualbell t_vb= " Disable all bells

" Make sure tabs are 4 character wide
set shiftwidth=4 tabstop=4 softtabstop=4 expandtab smarttab
set autoindent smartindent breakindent  " Proper indentation

" Enable searching as you type, rather than waiting till you press enter. Highlight search pattern. Intelligently handle cases in search.
set incsearch hlsearch ignorecase smartcase
" Comments in Grey color and italic
hi Comment guifg=#5C6370 ctermfg=50 cterm=italic

" Better autocompletes
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete
set complete+=kspell
set complete-=i
set completeopt="menuone,noselect"  " Better completion experience
set wildmenu                        " List and cycle through autocomplete on <Tab>
set wildignorecase                  " Case insensitive path completion
set wildmode="longest:full,full"    " Command-line completion mode

" Remove trailing blank spaces on save
autocmd BufWritePre * %s/\s\+$//e

" Normally, backspace works only if you have made an edit. This fixes that.
set backspace=indent,eol,start

" Sync vim clipboard with system clipboard. Works across Linux, MacOS & Windows.
set clipboard^=unnamed

" Set color
if !has('gui_running')
  set t_Co=256
  set termguicolors
  hi LineNr ctermbg=NONE guibg=NONE
endif
