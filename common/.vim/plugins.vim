call plug#begin('~/.vim/plugged')
    Plug 'tpope/vim-fugitive' "Fugitive Vim GitHub Wrapper
    Plug 'tpope/vim-surround' "Surround Plugin
    Plug 'tpope/vim-repeat' "Repeat for the surround plugin
    Plug 'tpope/vim-commentary' "Comments Plugin
    Plug 'tpope/vim-sensible' "Sensible options
    Plug 'rstacruz/vim-closer' "Auto-close brackets
    Plug 'machakann/vim-highlightedyank' "Highlight Yank
    Plug 'dbakker/vim-paragraph-motion' "Paragraph Motion
    Plug 'airblade/vim-gitgutter' "Git in the left-side gutter
    Plug 'junegunn/rainbow_parentheses.vim' "Rainbow parenthesis
    Plug 'easymotion/vim-easymotion' "Easy Motion to quickly jump across the buffer
    Plug 'preservim/nerdtree' "Nerd Tree
    Plug 'tpope/vim-obsession' "Obsessions -> saves sessions
    Plug 'christoomey/vim-tmux-navigator' "Syncs with Tmux pane navigation keymaps
    Plug 'mbbill/undotree' "Show the undo tree
    "------------Style Plugins------------"
    " Status Styles
    Plug 'itchyny/lightline.vim'
    Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' } "ColorScheme - Challenger-deep
    Plug 'cocopon/iceberg.vim' "Color Scheme - Iceberg
    Plug 'tyrannicaltoucan/vim-deep-space' "Color Scheme - Deep-space
call plug#end()

