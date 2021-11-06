
-- local theme = {}
-- do
-- 	local hsv_to_rgb = require'amgg_util'.hsv_to_rgb
-- 	local _mode_hues = {
-- 		normal   = 0,
-- 		insert   = 0.11631201,
-- 		visual   = 0.438889,
-- 		replace  = 0.666667,
-- 		command  = 0.780556,
-- 		inactive = 0.905556,
-- 	}
-- 	for k, v in pairs(_mode_hues) do
-- 		local accent_bg = hsv_to_rgb(v, 0.8, 1)
-- 		local accent_fg = hsv_to_rgb(0, 0, 0)
-- 		local main_bg   = hsv_to_rgb(v, 0.6, 1)
-- 		local main_fg   = hsv_to_rgb(0, 0, 0)
-- 		theme[k] = {
-- 			a = { fg = accent_fg, bg = accent_bg },
-- 			b = { fg = main_fg, bg = main_bg },
-- 			c = { fg = main_fg, bg = main_bg },
-- 		}
-- 	end
-- end

-- local theme = {}
-- for k, v in pairs(require'lualine.themes.16color') do
-- 	theme[k] = {
-- 		a = v.a,
-- 		b = v.c,
-- 		c = v.b,
-- 	}
-- end
-- theme.inactive.c = theme.normal.c

local hsv_to_rgb = require'amgg_util'.hsv_to_rgb

local _theme = {
	modes = {
		inactive = {
			accent = '#ffffff',
		},
		normal = {
			-- accent = hsv_to_rgb(-0.0225, 0.8, 1)
			accent = hsv_to_rgb(0, 0.8, 1),
			accent_text = '#ffffff',
		},
		insert = {
			accent = hsv_to_rgb(0.438889, 0.8, 1)
		},
		visual = {
			accent = hsv_to_rgb(0.11631201, 0.8, 1)
		},
		command = {
			accent = hsv_to_rgb(0.905556, 0.8, 1),
			accent_text = '#ffffff',
		},
	},
	black = '#000000',
	gray = '#808080',
}

local theme = {}
for k, v in pairs(_theme.modes) do
	local accent_text = '#000000'
	if v.accent_text ~= nil then accent_text = v.accent_text end
	theme[k] = {
		a = { fg=accent_text, bg=v.accent },
		b = { fg=v.accent, bg='#000000' },
		c = { fg=_theme.black, bg=_theme.gray },
	}
end

require'lualine'.setup {
	icons_enabled = false,
	options = {
		theme = theme,
		section_separators = { '\u{E0B0}', '\u{E0B2}' },
		-- component_separators = { '', '' },
	},
	sections = {
		lualine_a = { {'mode'} },
		lualine_b = { {'filename'} },
		lualine_c = { {'location'} },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = { {'filename'} },
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	}
}

