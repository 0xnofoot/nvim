local ls = {
	sh = {
		require('efmls-configs.formatters.shfmt'),
		require('efmls-configs.linters.shellcheck'),
	},

	zsh = {
		require('efmls-configs.formatters.shfmt'),
		require('efmls-configs.linters.shellcheck'),
	},

	c = {
		require('efmls-configs.formatters.clang_format'),
	},

	cpp = {
		require('efmls-configs.formatters.clang_format'),
	},

	objc = {
		require('efmls-configs.formatters.clang_format'),
	},

	objcpp = {
		require('efmls-configs.formatters.clang_format'),
	},

	swift = {
		require('efmls-configs.formatters.swiftformat'),
		require('efmls-configs.linters.swiftlint'),
	},
}

L = {
	setup = function(lspconfig)
		lspconfig.efm.setup({

			command = "efm-langserver",
			args = {
				'-c',
				vim.g.tool_config_path .. "/efm/config.yaml"
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
