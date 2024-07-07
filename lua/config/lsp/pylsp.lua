L = {
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

			filetypes = { "py", "python" },

			settings = {
				completions = {
					completeFunctionCalls = true,
				},
			},
		})
	end,
}

return L
