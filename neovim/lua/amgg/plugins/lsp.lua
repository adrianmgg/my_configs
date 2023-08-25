return {
	-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/guides/lazy-loading-with-lazy-nvim.md
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		lazy = true,
		config = function()
			require'lsp-zero.settings'.preset {
				name = 'minimal', -- which base preset to use
				set_lsp_keymaps = false, -- TODO
				manage_nvim_cmp = {
					set_sources = 'recommended', -- TODO
					-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/f084f4a6a716f55bf9c4026e73027bb24a0325a3/lua/lsp-zero/cmp.lua#L209-L232
					set_basic_mappings = true, -- create keybindings that emulate Neovim's default completion
					set_extra_mappings = false, -- TODO
					use_luasnip = true,
					set_format = true,
					documentation_window = true,
				},
				setup_servers_on_start = true, -- all servers installed with mason.nvim will be initialized on startup
				call_servers = 'local', -- "use mason.nvim whenever possible"
				configure_diagnostics = true, -- "adds borders and sorts 'severity' of diagnostics"
				float_border = 'rounded', -- TODO
			}
		end,
	},
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter', -- TODO - ideally this wouldn't be triggered by pulling up telescope
		dependencies = { 'L3MON4D3/LuaSnip' },
		config = function()
			require'lsp-zero.cmp'.extend()
			-- ... further configure cmp ...
		end,
	},
	{
		'neovim/nvim-lspconfig',
		cmd = 'LspInfo',
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'williamboman/mason-lspconfig.nvim',
			'williamboman/mason.nvim',
		},
		config = function()
			local lspzero = require'lsp-zero'
			lspzero.on_attach(function(_, bufnr)
				lspzero.default_keymaps{buffer = bufnr}
			end)

			-- "configure lua language server for neovim"
			require'lspconfig'.lua_ls.setup(lspzero.nvim_lua_ls())

			lspzero.setup()
		end,
	},

	{
		'j-hui/fidget.nvim',
		tag = 'legacy',
		event = 'LspAttach',
		opts = {
			-- ...
		},
	},
}

