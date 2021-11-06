local mappings = {
	n = {
		['<leader>'] = { subgroups = {
			f = { subgroups = { -- (f)ind
				b = { subgroups = { -- (b)uffer
					l = {  -- (l)sp
						maps = {
							s = { cmd = 'Telescope lsp_document_symbols' }, -- (s)ymbols
							['?'] = { cmd = 'Telescope lsp_document_diagnostics' }, -- (?)diagnostics
					}},
					g = {  -- (g)it
						maps = {
							c = { cmd = 'Telescope git_buffer_commits' }, -- (c)ommits
					}},
				}},
				f = {  -- (f)iles
					maps = {
						n = { cmd = 'Telescope find_files' }, -- (n)ames
						c = { cmd = 'Telescope live_grep' }, -- (c)ontent
						t = { cmd = 'Telescope file_browser' }, -- (t)ree
				}},
				h = {  -- (h)int
					maps = {
						m = { cmd = 'Telescope man_pages' }, -- (m)anpage
						t = { cmd = 'Telescope help_tags' }, -- (t)ags
				}},
				l = {  -- (l)sp
					maps = {
						a = { cmd = 'Telescope lsp_code_actions' }, -- (a)ctions
						s = { cmd = 'Telescope lsp_workspace_symbols' }, -- (s)ymbols
						['?'] = { cmd = 'Telescope lsp_workspace_diagnostics' }, -- (?)diagnostics
				}},
				g = {  -- (g)it
					maps = {
						c = { cmd = 'Telescope git_commits' }, -- (c)ommits
						['?'] = { cmd = 'Telescope git_status' }, -- (?)status
				}},
			}},
			l = {  -- (l)sp
				maps = {
					h = { lua = 'vim.lsp.buf.hover()' }, -- (h)over
					d = { lua = 'vim.lsp.buf.type_definition()' }, -- (d)efinition
					['?'] = { cmd = 'LspInfo' }, -- (?)info
				},
				subgroups = {
					w = { maps = { -- (w)orkspace
						a = { lua = 'vim.lsp.buf.add_workspace_folder()' }, -- (a)dd folder
						r = { lua = 'vim.lsp.buf.remove_workspace_folder()' }, -- (r)emove folder
						l = { lua = 'print(vim.inspect(vim.lsp.buf.list_workspace_folders()))' }, -- (l)ist folders
					}},
				}
			},
		}},
		g = { maps = {
			i = { cmd = 'Telescope lsp_implementations' },
			d = { cmd = 'Telescope lsp_declarations' },
			D = { cmd = 'Telescope lsp_definitions' },
			r = { cmd = 'Telescope lsp_references' },
		}},
	}
}

local function maphelper(mode, maps, prefix)
	if maps.subgroups ~= nil then
		for k, v in pairs(maps.subgroups) do
			maphelper(mode, v, prefix..k)
		end
	end
	if maps.maps ~= nil then
		for k, v in pairs(maps.maps) do
			local maprhs = nil
			if v.cmd ~= nil then maprhs = '<cmd>'..v.cmd..'<cr>'
			elseif v.lua ~= nil then maprhs = '<cmd>lua '..v.lua..'<cr>'
			end
			if maprhs then
				vim.api.nvim_set_keymap(mode, prefix..k, maprhs, {noremap=true})
			end
		end
	end
end

for mode, x in pairs(mappings) do
	maphelper(mode, {subgroups=x}, '')
end


-- for _,mapping in ipairs({
-- 	{'n', 'fn',  'find_files'},                -- (f)ile (n)ames
-- 	{'n', 'fc',  'live_grep'},                 -- (f)ile (c)ontents
-- 	{'n', 'ft',  'file_browser'},              -- (f)ile (t)ree
-- 	{'n', 'hm',  'man_pages'},                 -- (h)elp (m)an pages
-- 	{'n', 'ht',  'help_tags'},                 -- (h)elp (t)ags
-- 	{'n', 'lr',  'lsp_references'},            -- (l)sp (r)eferences
-- 	{'n', 'la',  'lsp_code_actions'},          -- (l)sp (a)ctions -- TODO lsp_range_code_actions
-- 	{'n', 'ls',  'lsp_workspace_symbols'},     -- (l)sp (s)ymbols
-- 	{'n', 'lsb', 'lsp_document_symbols'},      -- (l)sp (s)ymbols for current (b)uffer
-- 	{'n', 'l?',  'lsp_workspace_diagnostics'}, -- (l)sp (?)diagnostics
-- 	{'n', 'lb?', 'lsp_document_diagnostics'},  -- (l)sp (?)diagnostics for current (b)uffer
-- 	{'n', 'gc',  'git_commits'},               -- (g)it (c)ommits
-- 	{'n', 'gbc', 'git_buffer_commits'},        -- (g)it (c)ommits for current (b)uffer
-- 	{'n', 'g?',  'git_status'},                -- (g)it (?)status
-- }) do
-- 	local mode, suffix, teleargs = unpack(mapping)
-- 	vim.api.nvim_set_keymap(mode, '<leader>t'..suffix, '<cmd>Telescope '..teleargs..'<cr>', {noremap=true})
-- end

