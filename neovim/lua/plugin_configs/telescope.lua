local telescope = require'telescope'

telescope.setup {
	defaults = {
		mappings = {
			i = {
				["<C-h>"] = "which_key",
			}
		}
	},
	pickers = {
	},
	extensions = {
	}
}

telescope.load_extension'nvim_configs'

