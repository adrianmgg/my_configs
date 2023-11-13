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
		-- TODO - make sure load order will always be as described in https://github.com/williamboman/mason-lspconfig.nvim#setup
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'williamboman/mason-lspconfig.nvim',
			'williamboman/mason.nvim',
		},
		config = function()
			local lspzero = require'lsp-zero'
			lspzero.on_attach(function(_, bufnr)
				-- lspzero.default_keymaps{buffer = bufnr}
				local which_key = require'which-key'
				which_key.register({
					K = { vim.lsp.buf.hover, 'display hover info' },
					g = {
						d = { function() require'telescope.builtin'.lsp_definitions() end, 'jump to definition' },
						D = { vim.lsp.buf.declaration, 'jump to declaration' },
						i = { vim.lsp.buf.implementation, 'jump to implementation' },
						o = { vim.lsp.buf.type_definition, 'jump to type definition' },
						r = { vim.lsp.buf.references, 'list references' },
						s = { vim.lsp.buf.signature_help, 'show signature info' },
						l = { vim.diagnostic.open_float(), 'show diagnostics' },
					},
					['<leader>fs'] = { function() require'telescope.builtin'.lsp_document_symbols() end, 'symbols (document)' },
					['<leader>fS'] = { function() require'telescope.builtin'.lsp_workspace_symbols() end, 'symbols (workspace)' },
					['<F2>'] = { vim.lsp.buf.rename, 'rename' },
					['<F3>'] = { function() vim.lsp.buf.format{ async = true } end, 'format' },
					['<F4>'] = { vim.lsp.buf.code_action, 'format' },
					['[d'] = { vim.diagnostic.goto_prev, 'previous diagnostic' },
					[']d'] = { vim.diagnostic.goto_next, 'next diagnostic' },
				}, { mode = 'n', buffer = bufnr })
				which_key.register({
					['<F3>'] = { function() vim.lsp.buf.format{ async = true } end, 'format' },
					['<F4>'] = { vim.lsp.buf.range_code_action or vim.lsp.buf.code_action, 'code action' },
				}, { mode = 'x', buffer = bufnr })
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

