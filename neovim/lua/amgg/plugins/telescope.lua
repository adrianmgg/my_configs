return {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.2',
		dependencies = { 'nvim-lua/plenary.nvim' },
		cmd = 'Telescope',
		opts = {
			pickers = {
				colorscheme = {
					enable_preview = true,
				},
			},
		},
		config = function(lazyplugin, opts)
			local telescope = require'telescope'
			telescope.setup(opts)
			telescope.load_extension'nvim_configs'
		end,
	},
}


-- telescope.load_extension'nvim_configs'

