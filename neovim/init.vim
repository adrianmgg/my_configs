let mapleader = ' '

let s:block_arrow_keys = v:false
function s:toggle_block_arrows()
	let s:block_arrow_keys = !s:block_arrow_keys
	if s:block_arrow_keys
		noremap <Up> <Nop>
		noremap <Down> <Nop>
		noremap <Left> <Nop>
		noremap <Right> <Nop>
		" inoremap <Up> <Nop>
		" inoremap <Down> <Nop>
		" inoremap <Left> <Nop>
		" inoremap <Right> <Nop>
	else
		noremap <Up> k
		noremap <Down> j
		noremap <Left> h
		noremap <Right> l
		" inoremap <Up> <Up>
		" inoremap <Down> <Down>
		" inoremap <Left> <Left>
		" inoremap <Right> <Right>
	endif
endfunction
noremap <leader>v :call <SID>toggle_block_arrows()<CR>
call s:toggle_block_arrows()

" .-----------------.
" | cursor behavior |
" `-----------------`

" " make moving left/right wrap to other lines
" set whichwrap+=<,>,h,l,[,]

" " don't skip wrapped lines
" nnoremap <Up> gk
" nnoremap <Down> gj
" inoremap <Up> <C-O>gk
" inoremap <Down> <C-O>gj
" vnoremap <Up> gk
" vnoremap <Down> gj

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

" lua require'statusline'
" set statusline=        " clear statusline
" set statusline+=%t     " file name
" set statusline+=%m     " modified flag in brackets ([+] for modified, [-] for not modifiable)
" set statusline+=%r     " readonly flag in brackets ([RO])
" set statusline+=%y     " filetype in brackets (eg [vim])
" set statusline+=\      " a space
" set statusline+=%l,%c  " line,column


" always display statusline
set laststatus=2

" .---------.
" | tabline |
" `---------`

" always show tabline
set showtabline=2

" .---------------------.
" | sign/number columns |
" `---------------------`

" enable line numbers by default
set number
set relativenumber

" only show sign column when there are signs to display, auto resize to
" accomodate multiple signs up to the max (9)
set signcolumn=auto:9

" .------.
" | misc |
" `------`

" use forward slashes even on windows
" if exists('+shellslash')
" 	set shellslash
" endif

" use mouse
set mouse=a

" have mksession save these things (see :help sessionoptions)
set sessionoptions=blank,buffers,folds,help,resize,sesdir,tabpages,winpos,winsize
" set sessionoptions+=terminal

" don't normalize window sizes when splitting/closing splits
set noea

" 
set clipboard=unnamed

"
command! CopyBuffer %y+

" don't keep search highlight around after <CR>
set nohlsearch
" show search results while typing search
set incsearch
" re-enable hlsearch while typing search command, in order to show all matched strings with incsearch (since that's also controlled by hlsearch)
augroup vimrc-incsearch-highlight
	autocmd!
	autocmd CmdlineEnter * :set hlsearch
	autocmd CmdlineLeave * :set nohlsearch
augroup END

" don't unload buffers that aren't currently visible in any window
set hidden

" keep selection on visual mode indent change
vnoremap > >gv
exec 'vnoremap < <gv'
" TODO - the '<' confuses treesitter and fucks up the highlighting for the next line. should probably file a bug report about that

" cwd in title
set title
augroup dirchange
	autocmd!
	autocmd DirChanged * let &titlestring=v:event['cwd']
augroup END

" preserve initial root dir
cd %:p:h

" color scheme
colorscheme amgg

" highlight current line
set cursorline

" no timeout for leader combos etc.
set notimeout

" .---------.
" | plugins |
" `---------`

lua require'plugins'

" call Plugin('treesitter', 'github', 'nvim-treesitter/nvim-treesitter', {'postinstall': ':TSUpdateSync', 'loadat': 'now'})
" call Plugin('lspconfig', 'github', 'neovim/nvim-lspconfig', {'loadat': 'now'})
" call Plugin('airline', 'github', 'vim-airline/vim-airline', {'loadat': 'never'})
" call Plugin('bbye', 'github', 'moll/vim-bbye', {})
" call Plugin('fzf', 'github', 'junegunn/fzf', {'postinstall': 'call fzf#install()'})
" call Plugin('fzf-vim', 'github', 'junegunn/fzf.vim', {})
" call Plugin('plenary', 'github', 'nvim-lua/plenary.nvim', {}) " for gitsigns
" call Plugin('gitsigns', 'github', 'lewis6991/gitsigns.nvim', {'postinit': 'lua require(''gitsigns'').setup()'})

" .------------------.
" | treesitter stuff |
" `------------------`

" folding
set foldlevelstart=99
" set foldcolumn=auto:9
augroup TreesitterFold
	autocmd!
	" TODO these are window-local not buffer-local, should do a BufEnter
	" autocmd as well for this
	autocmd FileType vim setlocal foldmethod=expr | setlocal foldexpr=nvim_treesitter#foldexpr()
augroup end

" .-------------.
" | netrw stuff |
" `-------------`

let g:netrw_preview = 1      " preview in vertical split
let g:netrw_winsize = 30     " initial size (%) of netrw relative to created splits (from preview/open)
let g:netrw_liststyle = 3    " tree style listing
let g:netrw_browse_split = 4 " when browsing, <cr> will act like "P"
let g:netrw_keepdir = 1      " current dir != browsing dir
let g:netrw_banner = 0       " hide banner
let g:netrw_bufsettings = 'nomodifiable nomodified nowrap readonly nobuflisted number norelativenumber'
                           \ " same as netrw's default, but with number on

" " open netrw at pwd on startup if no files to edit specified
" augroup NetrwOnStartup
" 	autocmd!
" 	autocmd VimEnter * ++once if expand('%') == '' && argc() == 0 | :Lexplore . | wincmd p | endif
" augroup END

" .------------.
" | bbye stuff |
" `------------`

nnoremap <Leader>q :Bdelete<CR>

" .-------------.
" | shell stuff |
" `-------------`

if has('win32')
	let g:shell = 'pwsh'
else
	let g:shell = $SHELL
endif

function! s:shelltoggle()
	if exists('t:shell_winid')
		if win_id2win(t:shell_winid) == 0
			unlet t:shell_winid
		endif
	endif
	if !exists('t:shell_winid')
		exec 'split term://' . g:shell
		let t:shell_winid = win_getid()
		startinsert
	else
		if win_getid() == t:shell_winid
			" go to previous window
			call win_gotoid(win_getid(winnr('#')))
			stopinsert
		else
			" go back to shell window
			call win_gotoid(t:shell_winid)
			startinsert
		endif
	endif
endfunction

command! Shell call <SID>shelltoggle()
" switch to terminal from current window
nnoremap <C-`> :Shell<CR>
" switch back from terminal to previous window without exiting terminal mode
tnoremap <C-`> <C-\><C-n>:Shell<CR>

" | wmd |
command! -nargs=* -bang -range=% WMD call mkdir(expand('%:h'), 'p') | <line1>,<line2>w<bang> <args>

" | setup mappings |
lua require'keymap'


" .-------------------.
" | filetype specific |
" `-------------------`



