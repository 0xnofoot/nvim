L = {
	lsp = {
		setup = function(lspconfig)
		end,
	},


	format = {
		setup = function()
		end,
	},

	lint = {
		setup = function()
		end,
	},

	dap = {
		setup = function(dap)
		end,
	},

	compile_run = {
		setup = function()
		end,

		run_action = function()
			vim.cmd('set splitbelow')
			vim.cmd('sp')
			vim.cmd('res -5')
			vim.cmd("term gcc % -o %< && ./%< && rm %<")
		end,
	}
}

return L
