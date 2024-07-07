L = {
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

			filetypes = { "c", "c++", "cpp" },

			settings = {
				completions = {
					completeFunctionCalls = true,
				},
			},
		})
	end,
}

return L
