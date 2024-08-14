L = {
	setup = function(lspconfig)
		require('neodev').setup({
			lspconfig = true,
			override = function()
			end
		})

		lspconfig.lua_ls.setup({

		})
	end,
}

return L
