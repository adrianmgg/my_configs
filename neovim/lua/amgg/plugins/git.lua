return {
	{
		'lewis6991/gitsigns.nvim',
		-- "tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)"
		tag = 'release',
		opts = {
			signs = {
				add          = { text = '+' },
				change       = { text = '~' },
				delete       = { text = '-' },
				topdelete    = { text = '^' },
				changedelete = { text = '%' },
				untracked    = { text = '.' },
			},
			current_line_blame = true,
			current_line_blame_opts = {
				-- TODO should add virt_text_priority, but that was added more recently & still need to try running newer ver than release tag
				virt_text = true,
				virt_text_pos = 'right_align',
				delay = 0,
			},
		},
	},
}

