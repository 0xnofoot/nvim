local ls = {
	sh = {
		require('efmls-configs.formatters.beautysh'),
	},

	zsh = {
		require('efmls-configs.formatters.beautysh'),
	},

	swift = {
		require('config.lang.swift').format.setup(),
		-- require('config.lang.swift').lint.setup(),
	},
}

L = {
	lsp = {
		setup = function(lspconfig)
			lspconfig.efm.setup({

				command = "efm-langserver",
				args = {
					'-c',
					vim.g.efm_config_path,
				},

				filetypes = vim.tbl_keys(ls),
				init_options = {
					documentFormatting = true,
					documentRangeFormatting = true,
					-- hover = true,
					-- documentSymbol = true,
					-- codeAction = true,
					-- completion = true
				},

				settings = {
					languages = ls,
				},

				root_dir = function(filename, _)
					local util = require("lspconfig.util")
					return util.find_git_ancestor(filename)
						or vim.fn.getcwd()
				end,
			})
		end,
	},
}

return L
