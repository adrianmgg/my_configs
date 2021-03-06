
-- install packer.nvim if not already installed
local packer_did_bootstrap = false
local packer_install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.isdirectory(packer_install_path) == 0 then
	vim.fn.system({'git', 'clone', '--depth', '1', 'git@github.com:wbthomason/packer.nvim.git', packer_install_path})
	packer_did_bootstrap = vim.v.shell_error ~= 0
end

require'packer'.init {
	git = {
		subcommands = {
			-- TODO make these machine-specific
			-- for old git version on uni timeshare (default has '--progress' which isn't supported and causes error)
			submodules = 'submodule update --init --recursive',
			diff = 'log --color=never --pretty=format:FMT HEAD@{1}...HEAD', -- (--no-show-signature not supported)
			get_msg = 'log --color=never --pretty=format:FMT HEAD -n 1',
			get_header = 'log --color=never --pretty=format:FMT HEAD -n 1',
			get_bodies = 'log --color=never --pretty=format:"===COMMIT_START===%h%n%s===BODY_START===%b" HEAD@{1}...HEAD',
			-- (--rebase=false not supported)
			update = 'pull --ff-only --progress',
		},
	},
}

require('packer').startup (function(use)
	use 'wbthomason/packer.nvim'
	-- plugins here --
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		requires = {
			-- 'nvim-treesitter/nvim-treesitter-textobjects',
			'nvim-treesitter/playground'
		},
		config = function() require'plugin_configs.treesitter' end
	}
	use 'neovim/nvim-lspconfig'
	use {
		'adrianmgg/nvim-lspconfig-local-config',
		-- 'D:/git/nvim-lspconfig-local-config',
		requires = { 'neovim/nvim-lspconfig' },
		config = function() require'plugin_configs.lsp' end
	}
	use 'moll/vim-bbye'
	-- use {
	-- 	'junegunn/fzf.vim',
	-- 	requires = {{'junegunn/fzf', run = function() vim.fn['fzf#install']() end}}
	-- }
	use {
		'lewis6991/gitsigns.nvim',
		requires = {'nvim-lua/plenary.nvim'},
		config = function() require('plugin_configs.gitsigns') end
	}
	use {
		'nvim-telescope/telescope.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		config = function() require'plugin_configs.telescope' end
	}
	use {
		'hrsh7th/nvim-cmp',
		requires = { 'neovim/nvim-lspconfig', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer' },
		config = function() require'plugin_configs.cmp' end
	}
	use {
		'hoob3rt/lualine.nvim',
		requires = {'kyazdani42/nvim-web-devicons', opt=true},
		config = function() require'plugin_configs.lualine' end
	}
	use 'tpope/vim-fugitive'
	use {
		'dhruvasagar/vim-table-mode',
		ft = { 'rst' },
		config = function()
			-- rst compatable table
			vim.g.table_mode_corner_corner = '+'
			vim.g.table_mode_header_fillchar = '='
		end,
	}
	-- use {
	-- 	'stsewd/sphinx.nvim',
	-- 	run = ':UpdateRemotePlugins',
	-- }
	-- use {
	-- 	'chrisbra/DynamicSigns',
	-- 	config = function() vim.g.Signs_Alternate = 1 end,
	-- }

	-- do setup stuff if had to install packer
	if packer_did_bootstrap then
		require('packer').sync()
	end
end)
