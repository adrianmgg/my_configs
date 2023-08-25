scriptencoding utf-8

let mapleader = ' '

set tabstop=4 shiftwidth=4

" set list
" " set listchars=tab:-->,lead:.
" set listchars=tab:\ \ \ ,lead:.
set list listchars=tab:\ \ 

" always display statusline
set laststatus=2

" show tabline when there's multiple tabs
set showtabline=1

" show line numbers, numbered relative to current line
set number relativenumber

" only show sign column when there are signs to display, auto resize to
" accomodate multiple signs up to the max (9)
set signcolumn=auto:9

" TODO - from old config - mouse, sessionoptions, clipboard, CopyBuffer

" don't normalize window sizes when splitting/closing splits
set noequalalways


" show search results while typing search
set incsearch
" disable search highlighting initially
set nohlsearch
" re-enable search highlighting while you're (possibly) typing out a search
augroup vimrc-incsearch-highlight
	autocmd!
	autocmd CmdlineEnter * :set hlsearch
	autocmd CmdlineLeave * :set nohlsearch
augroup END

" don't unload buffers that aren't currently visible in any window
set hidden

" keep selection on visual mode insert change
vnoremap > >gv
vnoremap < <gv

" cwd in title
set title
augroup dirchange
	autocmd!
	autocmd DirChanged * let &titlestring=v:event['cwd']
augroup END

" " preserve initial root dir
" cd %:p:h

" colorscheme amgg
" colorscheme desert
colorscheme slate

" highlight cursor line
set cursorline
" TODO why is this also highlighting my current inserts in insert mode?

" " no timeout for leader combos etc.
" set notimeout
set timeout timeoutlen=1000

" Write and Make Directories - like :write, but it creates parent directories
" as necessary
command! -nargs=* -bang -range=% WMD call mkdir(expand('%:h'), 'p') | <line1>,<line2>w<bang> <args>
" plus explicitly make a one-character version of it so that :W will still
" work even if there are other user commands with that prefix
command! -nargs=* -bang -range=% W <line1>,<line2>WMD<bang> <args>

" " load plugins
" lua require'amgg.plugins'

" TODO maybe just port this over to all be in lua
lua require'amgg.init'






