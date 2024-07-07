L = {
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
}

return L
