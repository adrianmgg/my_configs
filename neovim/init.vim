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

" 
set clipboard=unnamed

" .---------.
" | plugins |
" `---------`

let s:plugins_dir = stdpath('data') . '/site/pack/amgg/opt'
if !isdirectory(s:plugins_dir)
	call mkdir(s:plugins_dir, 'p')
endif

let s:plugin_postinstalls = []
let s:plugin_postinits = []
function! s:plugin_postinit()
	for cmd in s:plugin_postinstalls
		execute cmd
	endfor
	for cmd in s:plugin_postinits
		execute cmd
	endfor
endfunction

" remove all plugins which are in plugin directory but weren't added via
" Plugin() this session
function! PluginCleanup()
	" TODO
endfunction

" Plugin('slug', 'git', 'url of repository', {shallow?: 0|1, branch?: 'branch', ...common options}
" Plugin('slug', 'github', 'user/repo', { same as for 'git' }
" common options - {
"   postinit?: ':command'|[commands],
"   postinstall?: 'command'|[commands],
"   disable?: bool,
"   loadat?: 'now'|'init'|'never' = 'init'
" }
function! Plugin(slug, type, identifier, options)
	" 'github' -> 'git' helper
	if a:type == 'github'
		call Plugin(a:slug, 'git', 'git@github.com:' . a:identifier . '.git', a:options)
		return
	endif
	" 
	let l:did_install = v:false
	" options defaults/normalizing
	let l:disabled = get(a:options, 'disable', v:false)
	let l:loadat = get(a:options, 'loadat', 'init')
	if l:loadat != 'init' && l:loadat != 'now' && l:loadat != 'never'
		throw 'invalid loadat value "' . l:loadat . '"'
	endif
	let l:postinit = get(a:options, 'postinit', [])
	if type(l:postinit) != v:t_list
		let l:postinit = [l:postinit]
	endif
	let l:postinstall = get(a:options, 'postinstall', [])
	if type(l:postinstall) != v:t_list
		let l:postinstall = [l:postinstall]
	endif
	" if enabled and not installed yet, install it
	if !(isdirectory(s:plugins_dir . '/' . a:slug) || l:disabled)
		let l:did_install = v:true
		if a:type == 'git'
			if executable('git') != 1
				throw 'git not found or not supported, can''t install plugin'
			endif
			let l:gitcmd = 'git clone'
			if has_key(a:options, 'branch')
				let l:gitcmd .= ' --branch '. shellescape(get(a:options, 'branch'))
			endif
			if get(a:options, 'shallow', 1)
				let l:gitcmd .= ' --depth=1'
			endif
			let l:gitcmd .= ' ' . shellescape(a:identifier) . ' ' . shellescape(s:plugins_dir . '/' . a:slug)
			call system(l:gitcmd)
		else
			throw 'unknown plugin type "' . a:type . '"'
		endif
	endif
	" 
	if !l:disabled
		" when the optional ! is added no plugin files or ftdetect scripts are
		" loaded, only the matching directories are added to 'runtimepath'.
		" this is useful in your .vimrc. the plugins will then be loaded
		" during initialization (:help packadd)
		if v:vim_did_enter || l:loadat == 'now'
			execute 'packadd ' . a:slug
		elseif l:loadat == 'init'
			execute 'packadd! ' . a:slug
		endif
		" TODO "Note that for ftdetect scripts to be loaded you will need to
		" write 'filetype plugin indent on' AFTER all packadd! commands"
	endif
	" run (or set up for later) post-install commands
	if l:did_install
		if v:vim_did_enter || (l:loadat == 'now')
			for p in l:postinstall
				execute p
			endfor
		elseif l:loadat == 'init'
			let s:plugin_postinstalls += l:postinstall
		endif
	endif
	" run (or set up for later) post-init commands
	if v:vim_did_enter || (l:loadat == 'now')
		for p in l:postinit
			execute p
		endfor
	elseif l:loadat == 'init'
		let s:plugin_postinits += l:postinit
	endif
	" TODO any good way to do post for loadat='never'? (ie can be manually
	" loaded with packadd)
endfunction

autocmd VimEnter * ++once call s:plugin_postinit()

call Plugin('treesitter', 'github', 'nvim-treesitter/nvim-treesitter', {'postinstall': ':TSUpdateSync', 'loadat': 'now'})
call Plugin('lspconfig', 'github', 'neovim/nvim-lspconfig', {'loadat': 'now'})

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

" TODO move this to local configs instead - maybe with a helper function?
lua <<EOF
require'lspconfig'.clangd.setup{
	cmd = { "clangd", "--query-driver=/opt/rh/devtoolset-8/root/usr/bin/g++" }
}
require'lspconfig'.pyright.setup{
	settings = {
		python = {
			analysis = {
				typeCheckingMode = 'basic', -- basic, strict
			}
		}
	}
}
EOF

