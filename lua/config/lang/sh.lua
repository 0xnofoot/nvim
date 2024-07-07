L = {
	plugins = {

	},

	lsp = {
		setup = function(lspconfig)
			lspconfig.bashls.setup({

				init_options = {
					documentFormatting = true,
					documentRangeFormatting = true,
					hover = true,
					documentSymbol = true,
					codeAction = true,
					completion = true
				},

				filetypes = { "sh", "zsh"},

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
		end
	},

	lint = {
		setup = function()
		end
	},

	compile_run = {
		setup = function()
		end,

		run_action = function()
			vim.cmd('set splitbelow')
			vim.cmd('sp')
			vim.cmd('res -5')
			vim.cmd('term sh %')
		end,
	},

	dap = {
		setup = function()
		end
	},
}

return L
