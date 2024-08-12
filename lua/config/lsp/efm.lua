local ls = {
	sh = {
		require('efmls-configs.formatters.beautysh'),
	},

	zsh = {
		require('efmls-configs.formatters.beautysh'),
	},

	c = {
		{
			formatCommand = string.format('%s -', require('efmls-configs.fs').executable('clang-format')),
			formatStdin = true,
		},
		-- require('efmls-configs.formatters.clang_format'),
	},

	cpp = {
		{
			formatCommand = string.format('%s -', require('efmls-configs.fs').executable('clang-format')),
			formatStdin = true,
		},
		-- require('efmls-configs.formatters.clang_format'),
	},

	objc = {
		{
			formatCommand = string.format('%s -', require('efmls-configs.fs').executable('clang-format')),
			formatStdin = true,
		},
		-- require('efmls-configs.formatters.clang_format'),
	},

	swift = {
		require('efmls-configs.formatters.swiftformat'),
		-- require('efmls-configs.linters.swiftlint'),
	},
}

L = {
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
}

return L
