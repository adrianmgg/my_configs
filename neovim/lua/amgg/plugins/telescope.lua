return {
	{
		'nvim-telescope/telescope.nvim',
		-- tag = '0.1.2',
		dependencies = { 'nvim-lua/plenary.nvim' },
		cmd = 'Telescope',
		config = function(lazyplugin, opts)
			local telescope = require'telescope'
			local actions = require'telescope.actions'
			telescope.setup {
				pickers = {
					colorscheme = {
						enable_preview = true,
					},
					buffers = {
						mappings = {
							i = {
								-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#mapping-c-d-to-delete-buffer
								['<c-d>'] = actions.delete_buffer + actions.move_to_top,
							},
						},
					},
				},
			}
			telescope.load_extension'nvim_configs'
			if vim.fn.executable'es' == 1 then
				telescope.load_extension'everything'
			end
		end,
	},

	{
		'Verf/telescope-everything.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim' },
		lazy = true,
	},
}


