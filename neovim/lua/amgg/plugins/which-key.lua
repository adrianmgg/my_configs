
local function telescope_builtin(picker)
	return function()
		require('telescope.builtin')[picker]()
	end
end

local whichkey_keymap = {
	['<leader>'] = {
		f = {
			name = 'find',
			t = { '<cmd>Telescope<cr>', 'telescope commands' },
			f = { telescope_builtin'find_files', 'local files' },
			b = { telescope_builtin'buffers', 'buffers' },
			c = { telescope_builtin'colorscheme', 'color schemes' },
			g = { telescope_builtin'live_grep', 'grep' },
		},
	},
}

return {
	{
		'folke/which-key.nvim',
		event = 'VeryLazy', -- via https://github.com/folke/which-key.nvim#lazynvim
		config = function()
			local which_key = require'which-key'
			which_key.setup({})
			which_key.register(whichkey_keymap)
		end,
	}
}

