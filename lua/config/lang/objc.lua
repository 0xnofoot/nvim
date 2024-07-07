L = {
	lsp = {
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

				filetypes = { "objective-c", "objc" },

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
	},

	format = {
		setup = function()
		end,
	},

	lint = {
		setup = function()
		end,
	},

	compile_run = {
		setup = function()
		end,

		run_action = function()
			vim.cmd('set splitbelow')
			vim.cmd('sp')
			vim.cmd('res -5')
			vim.cmd('term clang -framework Foundation % -o %< && ./%< && rm %<')
		end,
	},

	dap = {
		setup = function(dap)
		end,
	},
}

return L
