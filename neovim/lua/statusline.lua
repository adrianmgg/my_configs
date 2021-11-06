-- based on https://elianiva.my.id/post/neovim-lua-statusline


local M = {}

local _modes = {
	['n']    = {colorid='N', name='Normal'}; -- normal
	['v']    = {colorid='V', name='Visual'}; -- visual
	['V']    = {colorid='V', name='V-Line'}; -- visual line
	['\022'] = {colorid='V', name='V-Block'}; -- visual block
	['s']    = {colorid='S', name='Select'}; -- select
	['S']    = {colorid='S', name='S-Line'}; -- select line
	['\019'] = {colorid='S', name='S-Block'}; -- select block
	['i']    = {colorid='I', name='Insert'}; -- insert
	['R']    = {colorid='R', name='Replace'}; -- replace
	['c']    = {colorid='C', name='Command Line'}; -- command line
	['r']    = {colorid='P', name='Prompt'}; -- prompt
	['!']    = {colorid='S', name='Shell'}; -- shell
	['t']    = {colorid='T', name='Terminal'}; -- terminal
}

local mode_hues = {
	['N'] = -0.00001081,
	['V'] =  0.11631201,
	['S'] =  0.16668302,
	['I'] =  0.33334066,
	['R'] =  0.50000169,
	['C'] =  0.55028286,
	['P'] =  0.66669723,
	['S'] =  0.75903782,
	['T'] =  0.83334508,
}

local function hi_group_name(state, is_inverted)
	return 'statusline_mode_'..state.mode.colorid..(state.isactive and '_active' or '_inactive')..(is_inverted and '_inv' or '')
end
local function hi_group(state, is_inverted)
	return '%#'..hi_group_name(state, is_inverted)..'#'
end

for mode, hue in pairs(mode_hues) do
	local fghue = hue
	local bgcolor = '#000000'
	local fgactive   = hsv_to_rgb(hue, .8, 1)
	local fginactive = hsv_to_rgb(hue, 0, 0.8) -- hsv_to_rgb(hue, .6, 1)
	vim.api.nvim_command('hi '..hi_group_name({mode={colorid=mode}, isactive=true},  false)..' guifg='..fgactive  ..' guibg='..bgcolor   )
	vim.api.nvim_command('hi '..hi_group_name({mode={colorid=mode}, isactive=true},  true).. ' guifg='..bgcolor   ..' guibg='..fgactive  )
	vim.api.nvim_command('hi '..hi_group_name({mode={colorid=mode}, isactive=false}, false)..' guifg='..fginactive..' guibg='..bgcolor   )
	vim.api.nvim_command('hi '..hi_group_name({mode={colorid=mode}, isactive=false}, true).. ' guifg='..bgcolor   ..' guibg='..fginactive)
end

local modes = setmetatable({}, {
	__index = function(table, key)
		local firstchar = string.sub(key, 0, 1)
		if _modes[firstchar] == nil then
			return {'Unknown'}
		else
			return _modes[firstchar]
		end
	end
})

local function join_parts(state, part_funcs)
	local ret = ''
	local everyother = true
	for _, func in ipairs(part_funcs) do
		local part = func(state)
		if part ~= nil then
			ret = ret..hi_group(state, everyother)..' '..part..' '..hi_group(state, not everyother)..'\u{E0B0}'
			everyother = not everyother
		end
	end
	return ret
end

function mode_part(state)
	if state.isactive then return state.mode.name
	else return nil
	end
end
function line_col_part(state)
	return '%l:%c'
end
function filename_part(state)
	return '%<%F'
end

-- M.do_numbers_color = function(self, mode, isactive)
-- 	local groupname = hi_group_name(mode[1], isactive, false)
-- 	local newwinhl = {}
-- 	if isactive then
-- 		table.insert(newwinhl, 'LineNr:'..groupname)
-- 		table.insert(newwinhl, 'CursorLineNr:'..groupname)
-- 	end
-- 	for group,mapto in string.gmatch(vim.opt.winhighlight:get(), '([^,:]*):([^,:]*),?') do
-- 		if group ~= 'LineNr' and group ~= 'CursorLineNr' then
-- 			table.insert(newwinhl, group..':'..mapto)
-- 		end
-- 	end
-- 	vim.wo.winhighlight = table.concat(newwinhl, ',')
-- end

Statusline = setmetatable(M, {
	__call = function(statusline) --, isactive)

		local mode = modes[vim.api.nvim_get_mode().mode]
		return join_parts({mode=mode, isactive=isactive}, {mode_part, line_col_part, filename_part})
	end
})

vim.opt.statusline = '%{lua.Statusline()}'

-- vim.api.nvim_exec([[
-- 	augroup Statusline
-- 		autocmd!
-- 		autocmd WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline(v:true)
-- 		autocmd WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline(v:false)
-- 		" reload statusline on CmdLineLeave, since otherwise it isn't redrwn for inactive windows
-- 		autocmd CmdLineLeave      * let &statusline=&statusline
-- 	augroup END
-- ]], false)


