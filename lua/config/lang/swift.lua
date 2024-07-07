L = {
	plugins = {

	},

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

				filetypes = { "swift" },

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

	-- for efm
	format = {
		setup = function()
			local f = {
				formatCommand = 'swiftformat stdin --output stdout --quiet --stdinpath "${INPUT}"',
				formatStdin = true,
			}

			return f
		end,
	},

	-- for efm
	lint = {
		setup = function()
			local l = {
				lintCommand = 'swiftlint lint --use-stdin --quiet',
				lintStdin = true,
				lintIgnoreExitCode = true,
				lintFormats = {
					'%.%#:%l:%c: %trror: %m',
					'%.%#:%l:%c: %tarning: %m',
				},
				rootMarkers = {
					'buildServer.json',
					'*.xcodeproj',
					'*.xcworkspace',
					'.git',
				},
			}

			return l
		end,
	},

	compile_run = {
		setup = function()
		end,

		run_action = function()
			vim.cmd('set splitbelow')
			vim.cmd('sp')
			vim.cmd('res -5')
			vim.cmd('term swift %')
		end,
	},

	dap = {
		setup = function()
		end
	},
}


return L
