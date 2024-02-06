" Enable spell check for markdown, gitcommit & text files
augroup spell_check_text_files
    autocmd!
    autocmd FileType markdown setlocal spell
    autocmd FileType gitcommit setlocal spell
    autocmd FileType text setlocal spell
augroup END
