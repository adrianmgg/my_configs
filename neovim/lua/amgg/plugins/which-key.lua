
local function telescope_builtin(picker)
	return function()
		require('telescope.builtin')[picker]()
	end
end

local whichkey_keymaps = {
	{
		opts = { prefix = '<leader>' },
		mappings = {
			f = {
				name = 'find',
				t = { '<cmd>Telescope<cr>', 'telescope commands' },
				f = { telescope_builtin'find_files', 'local files' },
				b = { telescope_builtin'buffers', 'buffers' },
				c = { telescope_builtin'colorscheme', 'color schemes' },
				g = { telescope_builtin'live_grep', 'grep' },
			},
		},
	},
	{
		opts = { prefix = 'g' },
		mappings = {
			p = { '`[v`]', 'switch to VISUAL using last pasted text' },
			P = { '`[V`]', 'switch to VISUAL LINE using last pasted text' },
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
			for _, register_args in ipairs(whichkey_keymaps) do
				which_key.register(register_args.mappings, register_args.opts)
			end
		end,
	}
}

