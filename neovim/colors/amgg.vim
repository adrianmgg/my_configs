" based on default theme

" helper to dump all set default highlight groups to end of current buffer
" lua <<EOF
" local higroups = {'ColorColumn','Conceal','Cursor','lCursor','CursorIM','CursorColumn','CursorLine','Directory','DiffAdd','DiffChange','DiffDelete','DiffText','EndOfBuffer','TermCursor','TermCursorNC','ErrorMsg','VertSplit','Folded','FoldColumn','SignColumn','IncSearch','Substitute','LineNr','LineNrAbove','LineNrBelow','CursorLineNr','MatchParen','ModeMsg','MsgArea','MsgSeparator','MoreMsg','NonText','Normal','NormalFloat','NormalNC','Pmenu','PmenuSel','PmenuSbar','PmenuThumb','Question','QuickFixLine','Search','SpecialKey','SpellBad','SpellCap','SpellLocal','SpellRare','StatusLine','StatusLineNC','TabLine','TabLineFill','TabLineSel','Title','Visual','VisualNOS','WarningMsg','Whitespace','WildMenu','Menu','Scrollbar','Tooltip'}
" for _,group in ipairs(higroups) do
" 	local status, currenthi = pcall(vim.api.nvim_exec, 'hi '..group, true)
" 	if status then
" 		vim.fn.append(vim.fn.line('$'), currenthi)
" 	end
" end
" EOF

set background=dark
hi clear
if exists('syntax_on')
	syntax reset
endif

let colors_name = 'amgg'

hi Normal guibg=#000000 guifg=#ffffff

" default colorscheme
hi ColorColumn ctermbg=1 guibg=DarkRed
hi Conceal ctermfg=7 ctermbg=242 guifg=LightGrey guibg=DarkGrey
hi Cursor guifg=bg guibg=fg
hi lCursor guifg=bg guibg=fg
hi CursorColumn ctermbg=242 guibg=Grey40
" hi CursorLine cterm=underline guibg=Grey40
hi Directory ctermfg=159 guifg=Cyan
hi DiffAdd ctermbg=4 guibg=DarkBlue
hi DiffChange ctermbg=5 guibg=DarkMagenta
hi DiffDelete ctermfg=12 ctermbg=6 gui=bold guifg=Blue guibg=DarkCyan
hi DiffText cterm=bold ctermbg=9 gui=bold guibg=Red
hi link EndOfBuffer NonText
hi TermCursor cterm=reverse gui=reverse
hi ErrorMsg ctermfg=15 ctermbg=1 guifg=White guibg=Red
hi VertSplit cterm=reverse gui=reverse
hi Folded ctermfg=14 ctermbg=242 guifg=Cyan guibg=DarkGrey
hi FoldColumn ctermfg=14 ctermbg=242 guifg=Cyan guibg=Grey
hi SignColumn ctermfg=14 ctermbg=242 guifg=Cyan guibg=Grey
hi IncSearch cterm=reverse gui=reverse
hi link Substitute Search
hi LineNr ctermfg=11 guifg=Yellow
hi CursorLineNr ctermfg=11 gui=bold guifg=Yellow
hi MatchParen ctermbg=6 guibg=DarkCyan
hi ModeMsg cterm=bold gui=bold
hi link MsgSeparator StatusLine
hi MoreMsg ctermfg=121 gui=bold guifg=SeaGreen
hi NonText ctermfg=12 gui=bold guifg=Blue
hi link NormalFloat Pmenu
" hi Pmenu ctermfg=0 ctermbg=13 guibg=Magenta
hi Pmenu guibg=#404040 ctermbg=8
hi PmenuSel ctermfg=242 ctermbg=0 guibg=DarkGrey
hi PmenuSbar ctermbg=248 guibg=Grey
hi PmenuThumb ctermbg=15 guibg=White
hi Question ctermfg=121 gui=bold guifg=Green
hi link QuickFixLine Search
hi Search ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow
hi SpecialKey ctermfg=81 guifg=Cyan
hi SpellBad ctermbg=9 gui=undercurl guisp=Red
hi SpellCap ctermbg=12 gui=undercurl guisp=Blue
hi SpellLocal ctermbg=14 gui=undercurl guisp=Cyan
hi SpellRare ctermbg=13 gui=undercurl guisp=Magenta
hi StatusLine cterm=bold,reverse gui=bold,reverse
hi StatusLineNC cterm=reverse gui=reverse
hi TabLine cterm=underline ctermfg=15 ctermbg=242 gui=underline guibg=DarkGrey
hi TabLineFill cterm=reverse gui=reverse
hi TabLineSel cterm=bold gui=bold
hi Title ctermfg=225 gui=bold guifg=Magenta
" hi Visual ctermbg=242 guibg=DarkGrey
hi WarningMsg ctermfg=224 guifg=Red
hi link Whitespace NonText
hi WildMenu ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow

hi Visual ctermbg=242 guibg=#404040
hi clear CursorLine
hi link CursorLine Visual



