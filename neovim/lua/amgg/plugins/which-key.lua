
local function telescope_builtin(picker, opts)
	if opts == nil then opts = {} end
	return function()
		require('telescope.builtin')[picker](opts)
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
				F = { telescope_builtin'live_grep', 'grep in files' },
				g = { telescope_builtin'git_files', 'git files' },
				h = { telescope_builtin('find_files', { hidden = true }), 'local files (include hidden)' },
				-- via https://github.com/nvim-telescope/telescope.nvim/issues/855#issuecomment-1032325327
				H = { telescope_builtin('live_grep', { additional_args = function(opts) return {'--hidden'} end }), 'grep in files (include hidden)' },
				N = { '<cmd>Telescope nvim_configs<cr>', 'nvim config files' },
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

