
local function telescope_builtin(picker, opts)
	if opts == nil then opts = {} end
	return function()
		require('telescope.builtin')[picker](opts)
	end
end

local function telescope_extension(extension, picker, opts)
	if picker == nil then picker = extension end
	if opts == nil then opts = {} end
	return function ()
		require'telescope'.extensions[extension][picker](opts)
	end
end

return {
	{
		'folke/which-key.nvim',
		event = 'VeryLazy', -- via https://github.com/folke/which-key.nvim#lazynvim
		dependencies = { 'nvim-mini/mini.icons', 'nvim-tree/nvim-web-devicons' },
		opts = {},
		keys = {
			-- NOTE: see :help mode() for mode shortcodes list

			{ '<leader>?', function() require('which-key').show({ global = false }) end, desc = 'Buffer Local Keymaps (which-key)' },
			-- { '?', function() require('which-key').show({ global = false }) end, desc = 'Buffer Local Keymaps (which-key)', cond = function() return vim.fn.mode() == 'niI' end },  -- 'niI', 'niR', 'niV', 'ntT'

			{ '<leader>f', group = 'find' },
			{ '<leader>ft', '<cmd>Telescope<cr>', desc = 'telescope commands' },
			{ '<leader>ff', telescope_builtin'find_files', desc = 'local files' },
			{ '<leader>fb', telescope_builtin'buffers', desc = 'buffers' },
			{ '<leader>fc', telescope_builtin'colorscheme', desc = 'color schemes' },
			{ '<leader>fF', telescope_builtin'live_grep', desc = 'grep in files' },
			{ '<leader>fg', telescope_builtin'git_files', desc = 'git files' },
			{ '<leader>fh', telescope_builtin('find_files', { hidden = true }), desc = 'local files (include hidden)' },
			-- via https://github.com/nvim-telescope/telescope.nvim/issues/855#issuecomment-1032325327
			{ '<leader>fH', telescope_builtin('live_grep', { additional_args = function(opts) return {'--hidden'} end }), desc = 'grep in files (include hidden)' },
			{ '<leader>fN', telescope_extension'nvim_configs', desc = 'nvim config files' },
			-- TODO should only actually register these if we end up loading telescope-everything
			{ '<leader>fE', telescope_extension('everything', 'everything', {}), desc = 'everything' },

			{ 'gp', '`[v`]', desc = 'switch to VISUAL using last pasted text' },
			{ 'gP', '`[V`]', desc = 'switch to VISUAL LINE using last pasted text' },
		},
	}
}

