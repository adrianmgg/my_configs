local cmp = require'cmp'

cmp.setup {
	sources = {
		{ name = 'nvim_lsp' },
		-- { name = 'buffer' }
	},
	mapping = {
		['<C-Space>'] = cmp.mapping(cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}), { 'i' }),
		['<Tab>'] = cmp.mapping(cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = false,
		}), { 'i' }),
		['<CR>'] = cmp.mapping(cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = false,
		}), { 'i' }),
	}
}

