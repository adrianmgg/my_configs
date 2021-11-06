require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		custom_captures = {
			-- ["capture.group"] = "HighlightGroup",
		},
		indent = {
			enable = true,
		},
		-- can also be list of languages
		-- may be required for compatability with some stuff apparently
		additional_vim_regex_highlighting = false,
	}
}

