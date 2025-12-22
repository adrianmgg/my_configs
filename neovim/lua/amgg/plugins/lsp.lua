return {
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter', -- TODO - ideally this wouldn't be triggered by pulling up telescope
		dependencies = {
			'L3MON4D3/LuaSnip',
			'hrsh7th/cmp-nvim-lsp',
		},
		config = function()
			local cmp = require 'cmp'
			local function toggle_docs() if cmp.visible_docs() then cmp.close_docs() else cmp.open_docs() end end
			cmp.setup {
				sources = {
					{ name = 'nvim_lsp' },
				},
				-- mapping = cmp.mapping.preset.insert {
				mapping = {
					-- ['<C-Space>'] = cmp.mapping.complete(),
					-- ['<CR>'] = cmp.mapping.confirm({ select = false }),
					-- ['<C-y>'] = cmp.mapping.confirm({ select = true }),
					-- navigation
					['<C-j>']     = { i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }) },
					['<C-Down>']  = { i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }) },
					['<C-k>']     = { i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }) },
					['<C-Up>']    = { i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }) },
					-- docs
					['<C-_>']     = { i = toggle_docs }, -- ctrl + /  (b/c its the ? key)
					['<C-i>']     = { i = toggle_docs },
					-- docs navigation
					['<C-h>']     = { i = cmp.mapping.scroll_docs(-4) },
					['<C-Left>']  = { i = cmp.mapping.scroll_docs(-4) },
					['<C-l>']     = { i = cmp.mapping.scroll_docs(4) },
					['<C-Right>'] = { i = cmp.mapping.scroll_docs(4) },
					-- accept
					-- FIXME should maaaaaybe unbind default insert mode <C-u> mapping to avoid mistyping that
					['<C-y>']     = { i = cmp.mapping.confirm({ select = true }) },
				},
			}
			-- require'lsp-zero.cmp'.extend()
			-- ... further configure cmp ...
		end,
	},

	{
		'mason-org/mason-lspconfig.nvim',
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			'neovim/nvim-lspconfig',
		}
	},

	{
		'neovim/nvim-lspconfig',
		cmd = 'LspInfo',
		-- event = 'VeryLazy',
		lazy = false,
		-- TODO - make sure load order will always be as described in https://github.com/williamboman/mason-lspconfig.nvim#setup
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
		},
		config = function()
			-- local lspzero = require'lsp-zero'
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local bufnr = args.buf
					local which_key = require 'which-key'
					which_key.add {
						{
							mode = 'n',
							buffer = bufnr,
							{ 'K',          vim.lsp.buf.hover,                                                  desc = 'display hover info' },
							{ 'gd',         function() require 'telescope.builtin'.lsp_definitions() end,       desc = 'jump to definition' },
							{ 'gD',         vim.lsp.buf.declaration,                                            desc = 'jump to declaration' },
							{ 'gi',         function() require 'telescope.builtin'.lsp_implementations() end,   desc = 'jump to implementation' },
							{ 'go',         vim.lsp.buf.type_definition,                                        desc = 'jump to type definition' },
							{ 'gr',         function() require 'telescope.builtin'.lsp_references() end,        desc = 'list references' },
							{ 'gs',         vim.lsp.buf.signature_help,                                         desc = 'show signature info' },
							{ 'gl',         vim.diagnostic.open_float,                                          desc = 'show diagnostics' },
							{ '<leader>fs', function() require 'telescope.builtin'.lsp_document_symbols() end,  desc = 'symbols (document)' },
							{ '<leader>fS', function() require 'telescope.builtin'.lsp_workspace_symbols() end, desc = 'symbols (workspace)' },
							{ '<F2>',       vim.lsp.buf.rename,                                                 desc = 'rename' },
							{ '<F3>',       function() vim.lsp.buf.format { async = true } end,                 desc = 'format' },
							{ '<F4>',       vim.lsp.buf.code_action,                                            desc = 'format' },
							{ '[d',         vim.diagnostic.goto_prev,                                           desc = 'previous diagnostic' },
							{ ']d',         vim.diagnostic.goto_next,                                           desc = 'next diagnostic' },
						},
						{
							mode = 'x',
							buffer = bufnr,
							{ '<F3>', function() vim.lsp.buf.format { async = true } end,       desc = 'format' },
							{ '<F4>', vim.lsp.buf.range_code_action or vim.lsp.buf.code_action, desc = 'code action' },
						}
					}
				end,
			})

			-- "configure lua language server for neovim"
			-- vim.lsp.config('lua_ls', lspzero.nvim_lua_ls())
			-- TODO ^ replacement for above

			-- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
			vim.lsp.config('rust_analyzer', {
				settings = {
					['rust-analyzer'] = {
						checkOnSave = {
							command = 'clippy',
						},
						rustfmt = {
						},
					},
				},
			})
			vim.lsp.enable('rust_analyzer')

			-- vim.lsp.config('pyright', {
			-- 	settings = {
			-- 		python = {
			-- 			analysis = {
			-- 				extraPaths = {
			-- 					-- use stubs generated by https://github.com/strycore/fakegir for PyGObject if they're present
			-- 					vim.fn.expand('~/.cache/fakegir'),
			-- 				},
			-- 			},
			-- 		},
			-- 	},
			-- })
			-- vim.lsp.enable('pyright')
			-- vim.lsp.enable('basedpyright')
			-- vim.lsp.enable('pyright')

			-- (disabled for now in favor of below)
			-- vim.lsp.enable('ty')
			vim.lsp.enable('ruff')
			-- auto attach ty with single-file script handling
			-- via https://github.com/astral-sh/ty/issues/691#issuecomment-3598922969
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "python",
				callback = function(_)
					local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
					local has_inline_metadata = first_line:match("^# /// script")

					local cmd, name, root_dir
					if has_inline_metadata then
						local filepath = vim.fn.expand("%:p")
						local filename = vim.fn.fnamemodify(filepath, ":t")

						-- Set a unique name for the server instance based on the filename
						-- so we get a new client for new scripts
						name = "ty-" .. filename

						local relpath = vim.fn.fnamemodify(filepath, ":.")

						cmd = { "uvx", "--with-requirements", relpath, "ty", "server" }
						root_dir = vim.fn.fnamemodify(filepath, ":h")
					else
						name = "ty"
						cmd = { "uvx", "ty", "server" }
						root_dir = vim.fs.root(0,
							{ 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' })
					end

					vim.lsp.start({
						name = name,
						cmd = cmd,
						root_dir = root_dir,
					})
				end,
			})

			-- via https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jsonls
			local capabilities_jsonls = vim.lsp.protocol.make_client_capabilities()
			capabilities_jsonls.textDocument.completion.completionItem.snippetSupport = true
			vim.lsp.config('jsonls', {
				capabilities = capabilities_jsonls,
			})

			vim.lsp.enable('gopls')

			vim.lsp.enable('csharp-language-server')
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
