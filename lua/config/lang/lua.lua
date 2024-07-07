L = {
	lsp = {
		setup = function(lspconfig)
			require('neodev').setup({
				lspconfig = true,
				override = function()
				end
			})

			lspconfig.lua_ls.setup({

				init_options = {
					documentFormatting = true,
					documentRangeFormatting = true,
					hover = true,
					documentSymbol = true,
					codeAction = true,
					completion = true
				},

				filetypes = { "lua" },

				settings = {
					completions = {
						completeFunctionCalls = true,
					},
				}

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
			vim.cmd('term luajit %')
		end,

	},

	dap = {
		setup = function()
		end
	},
}

return L
