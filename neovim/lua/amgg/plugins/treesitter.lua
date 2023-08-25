return {
	-- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#lazynvim
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		opts = {
			highlight = {
				enable = true,
				custom_captures = {
				},
				indent = {
					enable = true,
				},
				-- can also be a list of languages
				-- may be required for compatability with some stuff apparently
				additional_vim_regex_highlighting = false,
			},
		},
	},
	{
		'nvim-treesitter/playground',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		name = 'treesitter-playground',
		cmd = 'TSPlaygroundToggle',
	},
}

