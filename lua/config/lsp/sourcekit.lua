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

			filetypes       = { "swift", "objective-c", "objc", "objective-cpp", "objcpp", "c", "cpp" },

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
					or util.root_pattern("Pods", "Podfile")(filename)
					or util.root_pattern("Package.swift")(filename)
					or vim.fn.getcwd()
			end,
			completions     = {
				completeFunctionCalls = true,
			},
		})

		-- 将 mm 和 h 文件类型更改为 objc
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = { "*.mm", "*.h" },
			callback = function()
				local cwd = vim.fn.getcwd()
				local patterns = {
					"buildServer.json",
					"*.xcodeproj",
					"*.xcworkspace",
					"Pods",
					"Podfile",
					"Package.swift"
				}

				for _, pattern in ipairs(patterns) do
					local matches = vim.fn.glob(cwd .. "/" .. pattern)
					if matches ~= "" then
						vim.cmd [[ set filetype=objc ]]
						vim.cmd [[ LspStart efm ]]
					end
				end
			end,
		})
	end,
}


return L
