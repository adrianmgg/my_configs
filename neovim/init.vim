" .-----------------.
" | cursor behavior |
" `-----------------`

" make moving left/right wrap to other lines
set whichwrap+=<,>,h,l,[,]

" don't skip wrapped lines
nnoremap <Up> gk
nnoremap <Down> gj
inoremap <Up> <C-O>gk
inoremap <Down> <C-O>gj
vnoremap <Up> gk
vnoremap <Down> gj

" position cursor at start of tab character instead of end
set listchars=tab:\ \  list

" .-------------.
" | indentation |
" `-------------`

set tabstop=4
set shiftwidth=4

" .------------.
" | statusline |
" `------------`

set statusline=        " clear statusline
set statusline+=%t     " file name
set statusline+=%m     " modified flag in brackets ([+] for modified, [-] for not modifiable)
set statusline+=%r     " readonly flag in brackets ([RO])
set statusline+=%y     " filetype in brackets (eg [vim])
set statusline+=\      " a space
set statusline+=%l,%c  " line,column

" always display statusline
set laststatus=2

" .---------------------.
" | sign/number columns |
" `---------------------`

" enable line numbers by default
set number

" set signcolumn=yes

" .------.
" | misc |
" `------`

" use mouse
set mouse=a

" have mksession save these things (see :help sessionoptions)
set sessionoptions=blank,buffers,folds,help,resize,sesdir,tabpages,terminal,winpos,winsize

" don't normalize window sizes when splitting/closing splits
set noea
