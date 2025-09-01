call plug#begin('~/.vim/plugged')
    Plug 'tpope/vim-fugitive'               "Fugitive Vim GitHub Wrapper
    Plug 'tpope/vim-surround'               "Surround Plugin
    Plug 'tpope/vim-repeat'                 "Repeat for the surround plugin
    Plug 'tpope/vim-commentary'             "Comments Plugin
    Plug 'tpope/vim-sensible'               "Sensible options
    Plug 'rstacruz/vim-closer'              "Auto-close brackets
    Plug 'machakann/vim-highlightedyank'    "Highlight Yank
    Plug 'dbakker/vim-paragraph-motion'     "Paragraph Motion
    Plug 'airblade/vim-gitgutter'           "Git in the left-side gutter
    Plug 'junegunn/rainbow_parentheses.vim' "Rainbow parenthesis
    Plug 'easymotion/vim-easymotion'        "Easy Motion to quickly jump across the buffer
    Plug 'preservim/nerdtree'               "Nerd Tree
    Plug 'tpope/vim-obsession'              "Obsessions -> saves sessions
    Plug 'christoomey/vim-tmux-navigator'   "Syncs with Tmux pane navigation keymaps
    Plug 'mbbill/undotree'                  "Show the undo tree
    Plug 'tommcdo/vim-exchange'             " cx{motion} 2 times. cxc <- cancel exchange
    Plug 'michaeljsmith/vim-indent-object'  " ai, ii, aI, iI <- select indent
    Plug 'unblevable/quick-scope'           " f, t <- Highlight unique letter on the line
    Plug 'mg979/vim-visual-multi'           " <Ctrl+n>
    Plug 'sheerun/vim-polyglot'              " Syntanx highlighting for many languages

    "------------Style Plugins------------"
    " Status Styles
    Plug 'itchyny/lightline.vim'
    Plug 'joshdick/onedark.vim'
call plug#end()
