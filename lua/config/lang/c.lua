L = {
	lsp = {
		setup = function(lspconfig)
			lspconfig.clangd.setup({

				init_options = {
					documentFormatting = true,
					documentRangeFormatting = true,
					hover = true,
					documentSymbol = true,
					codeAction = true,
					completion = true
				},

				settings = {
					completions = {
						completeFunctionCalls = true,
					},
				},
			})
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
