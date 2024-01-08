M = {
	'nvim-treesitter/nvim-treesitter',

	dependencies = {
	},

	config = function()
		require('nvim-treesitter.configs').setup({
			sync_install = false,
			auto_install = true,

			modules = {
			},

			ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'python', 'bash', 'swift', 'objc' },

			indent = {
				enable = true
			},

			ignore_install = {
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<CR>',
					node_incremental = '<CR>',
					node_decremental = '<BS>',
					scope_incremental = '<TAB>',
				}
			},

			highlight = {
				enable = true,

				disable = {
				},

				additional_vim_regex_highlighting = true,
			},

			rainbow = {
				enable = true,
				disable = {},
				extended_mode = true,
				max_file_lines = nil,
			}
		})
	end,
}

return M
