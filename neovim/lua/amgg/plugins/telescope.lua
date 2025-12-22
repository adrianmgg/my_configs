return {
	-- NOTE: keybinds for telescope are set in `which-key.lua`,
	--       not in this file.
	--       that way telescope only has to lazy load once it's actually called.
	{
		'nvim-telescope/telescope.nvim',
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


