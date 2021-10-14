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

" set signcolumn=yes

" .------.
" | misc |
" `------`

" use mouse
set mouse=a

" have mksession save these things (see :help sessionoptions)
set sessionoptions=blank,buffers,folds,help,resize,sesdir,tabpages,winpos,winsize
" set sessionoptions+=terminal

" don't normalize window sizes when splitting/closing splits
set noea

" .---------.
" | plugins |
" `---------`

let s:plugins_dir = stdpath('data') . '/site/pack/amgg/start'
if !isdirectory(s:plugins_dir)
	echo 'making plugins dir at "' . s:plugins_dir . '"'
	call mkdir(s:plugins_dir, 'p')
endif

let s:plugin_postinits = []
function! s:plugin_postinit()
	if len(s:plugin_postinits) > 0
		echo 'plugin install post'
	endif
	for cmd in s:plugin_postinits
		execute cmd
	endfor
endfunction

" Plugin('slug', 'git', 'url of repository', {[shallow: 0|1], [branch: 'branch'], [common options]}
" Plugin('slug', 'github', 'user/repo', { same as for 'git' }
" common options - {[post: ':command']}
function! Plugin(slug, type, identifier, options)
	" 'github' -> 'git' helper
	if a:type == 'github'
		call Plugin(a:slug, 'git', 'git@github.com:' . a:identifier . '.git', a:options)
		return
	endif
	" do nothing if already installed
	if isdirectory(s:plugins_dir . '/' . a:slug)
		return
	endif
	" install
	echo 'installing plugin ' . a:identifier
	if a:type == 'git'
		if executable('git') != 1
			throw 'git not found or not supported, can''t install plugin'
		endif
		let l:gitcmd = 'git -C ' . shellescape(s:plugins_dir) . ' clone'
		if has_key(a:options, 'branch')
			let l:gitcmd .= ' --branch '. shellescape(get(a:options, 'branch'))
		endif
		if get(a:options, 'shallow', 1)
			let l:gitcmd .= ' --depth=1'
		endif
		let l:gitcmd .= ' ' . shellescape(a:identifier) . ' ' . shellescape(a:slug)
		echo system(l:gitcmd)
	else
		throw 'unknown plugin type "' . a:type . '"'
	endif
	" 
	if has_key(a:options, 'post')
		if v:vim_did_enter
			execute get(a:options, 'post')
		else
			let s:plugin_postinits += [get(a:options, 'post')]
		endif
	endif
endfunction

autocmd VimEnter * call s:plugin_postinit()

call Plugin('treesitter', 'github', 'nvim-treesitter/nvim-treesitter', {'post': ':TSUpdate'})
call Plugin('lspconfig', 'github', 'neovim/nvim-lspconfig', {})





" .------------------.
" | treesitter stuff |
" `------------------`

lua <<EOF
require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		custom_captures = {
			-- ["capture.group"] = "HighlightGroup",
		},
		-- can also be list of languages
		-- may be required for compatability with some stuff apparently
		additional_vim_regex_highlighting = false,
	}
}
EOF

" .-----------------------.
" | language server stuff |
" `-----------------------`

lua <<EOF
require'lspconfig'.clangd.setup{
	cmd = { "clangd", "--query-driver=/opt/rh/devtoolset-8/root/usr/bin/g++" }
}
EOF

" .-------.
" | TODOs |
" `-------`

" TODO 'move selected lines up and down' from vim8rc

" TODO is disabling bell necessary in nvim?

" TODO font stuff, has(gui_running) stuff from vim8rc

" TODO plugins from vim8rc

" TODO local vimrc settings from vim8rc if use that plugin

" TODO coc.nvim stuff from vim8rc if use that

" TODO show_documentation function from vim8rc

" TODO OverCommandLine











