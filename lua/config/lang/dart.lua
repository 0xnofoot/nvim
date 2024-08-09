L = {
	plugins = {
		{
			'dart-lang/dart-vim-plugin'
		},
	},

	run_action = function()
		vim.cmd('set splitbelow')
		vim.cmd('sp')
		vim.cmd('res -5')
		vim.cmd('term dart %')
	end,
}

return L
