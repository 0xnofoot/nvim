L = {
	run_action = function()
		vim.cmd('set splitbelow')
		vim.cmd('sp')
		vim.cmd('res -5')
		vim.cmd("term gcc % -o %< && ./%< && rm %<")
	end,
}

return L
