L = {
	setup = function(lspconfig)
		lspconfig.sourcekit.setup({
			init_options    = {
				documentFormatting = true,
				documentRangeFormatting = true,
				hover = true,
				documentSymbol = true,
				codeAction = true,
				completion = true
			},

			cmd             = {
				vim.g.sourcekit_path,
			},

			filetypes       = { "swift", "objective-c", "objc", "objcpp", "c", "c++", "cpp" },

			get_language_id = function(_, ftype)
				if ftype == "objc" then
					return "objective-c"
				end
				return ftype
			end,

			root_dir        = function(filename, _)
				local util = require("lspconfig.util")
				return util.root_pattern("buildServer.json")(filename)
					or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
					or util.find_git_ancestor(filename)
					or util.root_pattern("Package.swift")(filename)
					or vim.fn.getcwd()
			end,
			completions     = {
				completeFunctionCalls = true,
			},
		})
	end,
}

return L
