L = {
	lsp = {
		setup = function(lspconfig)
			lspconfig.pylsp.setup({

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
			dap.configurations.python = {
				{
					type = 'python',
					request = 'launch',
					name = 'Launch file',
					program = '${file}',
					pythonPath = function()
						return vim.g.python3_host_prog
					end,
				},
			}

			dap.adapters.python = {
				type = 'executable',
				command = os.getenv('HOME') .. '/.virtualenvs/debugpy/bin/python',
				args = { '-m', 'debugpy.adapter' },
			}
		end,
	},

	compile_run = {
		setup = function()
		end,

		run_action = function()
			vim.cmd('set splitbelow')
			vim.cmd('sp')
			vim.cmd('res -5')
			vim.cmd('term python3 %')
		end,
	}

}

return L
