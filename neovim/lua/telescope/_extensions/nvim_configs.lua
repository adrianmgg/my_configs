return require'telescope'.register_extension {
	setup = function(ext_config, config) end,
	exports = {
		nvim_configs = function()
			require'telescope.builtin'.find_files {
				prompt_title = 'Nvim Configs',
				cwd = vim.fn.stdpath('config'),
			}
		end,
	}
}

