L = {
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

			filetypes = { "sh", "zsh" },

			settings = {
				completions = {
					completeFunctionCalls = true,
				},
			},
		})
	end,
}

return L
