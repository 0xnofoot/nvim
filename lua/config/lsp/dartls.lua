L = {
	setup = function(lspconfig)
		lspconfig.dartls.setup({
			init_options = {
				documentFormatting = true,
				documentRangeFormatting = true,
				hover = true,
				documentSymbol = true,
				codeAction = true,
				completion = true,

				onlyAnalyzeProjectsWithOpenFiles = true,
				suggestFromUnimportedLibraries = true,
				closingLabels = true,
				outline = true,
				flutterOutline = true,
			},

			cmd = { "dart", "language-server", "--protocol=lsp" },

			filetypes = { "dart" },

			settings = {
				dart = {
					completeFunctionCalls = true,
					showTodos = true,
				},
			},

			root_dir = function(filename, _)
				local util = require("lspconfig.util")
				return util.root_pattern("pubspec.yaml")(filename)
					or util.find_git_ancestor(filename)
					or vim.fn.getcwd()
			end,
			completions = {
				completeFunctionCalls = true,
			},
		})
	end,
}

return L
