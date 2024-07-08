local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local moveCursorBeforeComma = function()
	vim.defer_fn(function()
		local line = vim.api.nvim_get_current_line()
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local char = line:sub(col - 2, col)
		if char == ': ,' then
			vim.api.nvim_win_set_cursor(0, { row, col - 1 })
		end
	end, 100)
end

local setCompHL = function()
	local fgdark = '#2E3440'

	vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = '#82AAFF', bg = 'NONE', bold = true })
	vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { fg = '#82AAFF', bg = 'NONE', bold = true })
	vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { fg = '#7E8294', bg = 'NONE', strikethrough = true })

	vim.api.nvim_set_hl(0, 'CmpItemMenu', { fg = '#808080', bg = 'NONE', italic = true })
	vim.api.nvim_set_hl(0, 'CmpItemKindField', { fg = fgdark, bg = '#B5585F' })
	vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { fg = fgdark, bg = '#B5585F' })
	vim.api.nvim_set_hl(0, 'CmpItemKindEvent', { fg = fgdark, bg = '#B5585F' })

	vim.api.nvim_set_hl(0, 'CmpItemKindText', { fg = fgdark, bg = '#9FBD73' })
	vim.api.nvim_set_hl(0, 'CmpItemKindEnum', { fg = fgdark, bg = '#9FBD73' })
	vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { fg = fgdark, bg = '#9FBD73' })

	vim.api.nvim_set_hl(0, 'CmpItemKindConstant', { fg = fgdark, bg = '#D4BB6C' })
	vim.api.nvim_set_hl(0, 'CmpItemKindConstructor', { fg = fgdark, bg = '#D4BB6C' })
	vim.api.nvim_set_hl(0, 'CmpItemKindReference', { fg = fgdark, bg = '#D4BB6C' })

	vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { fg = fgdark, bg = '#A377BF' })
	vim.api.nvim_set_hl(0, 'CmpItemKindStruct', { fg = fgdark, bg = '#A377BF' })
	vim.api.nvim_set_hl(0, 'CmpItemKindClass', { fg = fgdark, bg = '#A377BF' })
	vim.api.nvim_set_hl(0, 'CmpItemKindModule', { fg = fgdark, bg = '#A377BF' })
	vim.api.nvim_set_hl(0, 'CmpItemKindOperator', { fg = fgdark, bg = '#A377BF' })

	vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { fg = fgdark, bg = '#cccccc' })
	vim.api.nvim_set_hl(0, 'CmpItemKindFile', { fg = fgdark, bg = '#7E8294' })

	vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { fg = fgdark, bg = '#D4A959' })
	vim.api.nvim_set_hl(0, 'CmpItemKindSnippet', { fg = fgdark, bg = '#D4A959' })
	vim.api.nvim_set_hl(0, 'CmpItemKindFolder', { fg = fgdark, bg = '#D4A959' })

	vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { fg = fgdark, bg = '#6C8ED4' })
	vim.api.nvim_set_hl(0, 'CmpItemKindValue', { fg = fgdark, bg = '#6C8ED4' })
	vim.api.nvim_set_hl(0, 'CmpItemKindEnumMember', { fg = fgdark, bg = '#6C8ED4' })

	vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { fg = fgdark, bg = '#58B5A8' })
	vim.api.nvim_set_hl(0, 'CmpItemKindColor', { fg = fgdark, bg = '#58B5A8' })
	vim.api.nvim_set_hl(0, 'CmpItemKindTypeParameter', { fg = fgdark, bg = '#58B5A8' })
end

local M = {
	'hrsh7th/nvim-cmp',

	after = { 'SirVer/ultisnips' },

	dependencies = {
		{ 'hrsh7th/cmp-nvim-lsp' },
		{ 'hrsh7th/cmp-buffer' },
		{ 'hrsh7th/cmp-path' },
		{ 'hrsh7th/cmp-cmdline' },

		{
			'onsails/lspkind.nvim',
			lazy = false,
			config = function()
				require('lspkind').init({
					mode = 'symbol',
					preset = 'codicons',

					symbol_map = {
						Text = " 󰉿 ",
						Method = " 󰆧 ",
						-- Function = " 󰊕 ",
						Function = " 󰡱 ",
						Constructor = "  ",
						Field = " 󰜢 ",
						Variable = " 󰀫 ",
						Class = " 󰠱 ",
						Interface = "  ",
						Module = "  ",
						Property = " 󰜢 ",
						Unit = " 󰑭 ",
						Value = " 󰎠 ",
						Enum = "  ",
						Keyword = " 󰌋 ",
						Snippet = "  ",
						Color = " 󰏘 ",
						File = " 󰈙 ",
						Reference = " 󰈇 ",
						Folder = " 󰉋 ",
						EnumMember = "  ",
						Constant = " 󰏿 ",
						Struct = " 󰙅 ",
						Event = "  ",
						Operator = " 󰆕 ",
						TypeParameter = "",
					},
				})
			end
		},

		{
			'SirVer/ultisnips',
			dependencies = {
				'honza/vim-snippets',
				'quangnguyen30192/cmp-nvim-ultisnips',
			},
			config = function()
				vim.g.UltiSnipsSnippetDirectories = { "~/.config/nvim/Ultisnips" }
				-- vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
				-- vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
				-- vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
				-- vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
				-- vim.g.UltiSnipsRemoveSelectModeMappings = 0
			end
		},
	},

	config = function()
		local cmp = require('cmp')
		local lspkind = require('lspkind')
		local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

		setCompHL()

		cmp.setup({

			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'ultisnips' }, -- For ultisnips users.
			}, {
				{ name = 'buffer' },
				{ name = 'path' },
			}),

			completion = {
				completeopt = 'menu,menuone,noinsert'
			},

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			formatting = {
				expandable_indicator = true,
				fields = { 'kind', 'abbr' },

				format = lspkind.cmp_format({
					mode = 'symbol',
					expandable_indicator = true,
					maxwidth = 60,
					maxheight = 10,
					ellipsis_char = '..',
					menu = '',
				})
			},

			snippet = {
				expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end
			},


			mapping = cmp.mapping.preset.insert({
				['<C-j>'] = cmp.mapping.scroll_docs(4),
				['<C-k>'] = cmp.mapping.scroll_docs(-4),

				['<C-c>'] = cmp.mapping({
					i = function(fallback)
						cmp.close()
						fallback()
					end
				}),

				['<CR>'] = cmp.mapping({
					i = function(fallback)
						if cmp.visible() then
							cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
						else
							fallback()
						end
					end
				}),

				['<C-a>'] = cmp.mapping({
					i = function(fallback)
						if not cmp.visible() and has_words_before() then
							cmp.complete()
						elseif cmp.visible() then
							cmp.close()
						end
					end,
				}),

				['<Tab>'] = cmp.mapping({
					i = function(fallback)
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
							moveCursorBeforeComma()
							-- elseif has_words_before() then
							-- 	cmp.complete()
							-- 	moveCursorBeforeComma()
						elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
							cmp_ultisnips_mappings.jump_forwards(fallback)
						else
							fallback()
						end
					end,

					c = function(fallback)
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
						elseif cmp.visible() and cmp.get_active_entry() then
							cmp.complete()
						else
							fallback()
						end
					end,

					s = function(fallback)
						if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
							cmp_ultisnips_mappings.jump_forwards(fallback)
						else
							fallback()
						end
					end,
				}),

				['<S-Tab>'] = cmp.mapping({
					i = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
							moveCursorBeforeComma()
						elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
							cmp_ultisnips_mappings.jump_backwards(fallback)
						else
							fallback()
						end
					end,

					c = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
						elseif cmp.visible() and cmp.get_active_entry() then
							cmp.complete()
						else
							fallback()
						end
					end,

					s = function(fallback)
						if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
							cmp_ultisnips_mappings.jump_backwards(fallback)
						else
							fallback()
						end
					end,
				}),
			}),

			experimental = {
				ghost_text = true,
			},
		})

		-- Set configuration for specific filetype.
		cmp.setup.filetype('gitcommit', {
			sources = cmp.config.sources({
				{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
			}, {
				{ name = 'buffer' },
			})
		})

		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline({ '/', '?' }, {
			mapping = cmp.mapping.preset.cmdline({}),
			sources = {
				{ name = 'buffer' }
			},
		})

		cmp.event:on(
			'confirm_done',
			require('nvim-autopairs.completion.cmp').on_confirm_done()
		)
	end
}

return M
