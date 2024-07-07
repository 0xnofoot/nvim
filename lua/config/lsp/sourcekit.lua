L = {
	setup = function(lspconfig)
		lspconfig.sourcekit.setup({
			init_options = {
				documentFormatting = true,
				documentRangeFormatting = true,
				hover = true,
				documentSymbol = true,
				codeAction = true,
				completion = true
			},

			cmd = {
				-- sourcekit path
				"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
			},

			filetypes = { "swift", "objective-c", "objc" },

			root_dir = function(filename, _)
				local util = require("lspconfig.util")
				return util.root_pattern("buildServer.json")(filename)
					or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
					or util.find_git_ancestor(filename)
					or util.root_pattern("Package.swift")(filename)
					or vim.fn.getcwd()
			end,
			completions = {
				completeFunctionCalls = true,
			},
		})
	end,
}

return L
