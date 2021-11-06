
-- The name for a highlight or syntax group must consist of ASCII letters, digits
-- and the underscore.  As a regexp: "[a-zA-Z0-9_]*".  However, Vim does not give
-- an error when using other characters.
--   (:h group-name)

-- When Vim knows the normal foreground and background colors, "fg" and
-- "bg" can be used as color names.  This only works after setting the
-- colors for the Normal group and for the MS-Windows console.
--   (:h e419)

-- TODO features:
-- 	- validate group names
-- 	    - names with illegal characters (see naming conventions in :h group-name, "vim does not give an error when using [illegal] characters")
-- 	    - empty/zero-length names
-- 	- validate colors
-- 	    - wcag contrast ratio checks for guifg/guibg
-- 	    - optionally have user specify term palette, then can wcag validate ctermfg/bg

-- TODO  - special name - NONE = no color (transparent) (see :h highlight-guisp)

local function _iterlines(state, var)
	local _f, _s = unpack(state)
	local full_line, content = _f(_s, var)
	if string.len(full_line) < 1 then
		return nil
	else
		return content
	end
end
-- iterate over all lines in string, including empty lines and including possible empty line at end
local function iterlines(s)
	local _f, _s, _v = string.gmatch(s, '(\r?\n?([^\r\n]*))')
	return _iterlines, {_f, _s}, _v
end




-- local function wcag_relative_luminance




local function get_color_name_list()
	local colors = {}
	for line in io.lines(vim.fn.expand('$VIMRUNTIME/rgb.txt')) do
		local r, g, b, name = string.match(line, '^(%d+)%s+(%d+)%s+(%d+)%s+(.*)$')
		if r ~= nil then
			colors[name] = {tonumber(r), tonumber(g), tonumber(b)}
		end
	end
	return colors
end




local function parse_highlight_group(content)
	if content == 'cleared' then  -- TODO probably won't work if non-english
		return {link='Normal'}
	end
	do
		local group_link = string.match(content, '^links to ([a-zA-Z0-9_]*)')
		if group_link ~= nil then
			return {link=group_link}
		end
	end
	do
		local group_params = {}
		for param_name, param_val in string.gmatch(content, '([a-z]+)=([^ ]*)') do
			group_params[param_name] = param_val
		end
		return {params=group_params}
	end
end

-- returns something like this
-- {
--   'group 1 name' = {
--     link = 'group 2 name',
--     blame = '...'
--   },
--   'group 2 name' = {
--     params = { 'param_name'='param_value' },
--     blame = '...'
--   }
-- }
local function parse_highlight_groups()
	local groups = {}
	local prev_group = nil
	for line in iterlines(vim.api.nvim_exec('verbose highlight', true)) do
		local group_name, content = string.match(line, '^([a-zA-Z0-9_]*) +xxx (.*)$')
		if group_name ~= nil then
			local group = parse_highlight_group(content)
			groups[group_name] = group
			prev_group = group
		end
		local blame = string.match(line, '^\tLast set from (.*)$')  -- TODO probably wont work if non-english
		if blame ~= nil and prev_group ~= nil then
			prev_group['blame'] = blame
		end
	end
	return groups
end

local function parse_gui_color(c, colors)
	if colors[c] ~= nil then return colors[c] end
	local rr, gg, bb = string.match(c, '^#([0-9a-fA-F][0-9a-fA-F])([0-9a-fA-F][0-9a-fA-F])([0-9a-fA-F][0-9a-fA-F])$')
	if rrggbb ~= nil then
		return { tonumber(rr, 16), tonumber(rr, 16), tonumber(rr, 16) }
	end
	return nil
end

local function get_highlight_groups()
	local parsed_groups = parse_highlight_groups()
	local groups = {}
	-- color names
	local gui_color_names = get_color_name_list()
	if parsed_groups.Normal ~= nil and parsed_groups.Normal.params ~= nil then
		for k, mapto in ipairs({guifg={'fg','foreground'}, guibg={'bg','background'}}) do
			local v = parsed_groups.Normal.params['gui'..x]
			if v ~= nil then gui_color_names[x] = parse_gui_color(v, gui_color_names) end
		end
	end
	-- go over parsed groups, resolving links and parsing direct colors
	for group_name, group_info in pairs(parsed_groups) do
		if group_info.link ~= nil then
			if groups[group_info.link] == nil then groups[group_info.link] = {links={}} end
			table.insert(groups[group_info.link].links, {name=group_name, blame=group_info.blame})
		elseif group_info.params ~= nil then
			if groups[group_name] == nil then groups[group_name] = {links={}} end
			local group = groups[group_name]
			for param_name, param_val in pairs(group_info.params) do
				-- group[param_name] = param_val
				if param_name == 'guifg' or param_name == 'guibg' then
					parsed_color = parse_gui_color(param_val, gui_color_names)
					if parsed_color ~= nil then group[param_name] = parsed_color end
				end
			end
		end
	end
	return groups
end



print(vim.inspect(get_highlight_groups()))

-- print(vim.inspect(get_color_name_list()))

