L = {
	-- 该配置不由 lsp-config 持有，返回给给 fluuter-tools 插件管理
	config = {
		autostart = true,
		on_attach = function()
			vim.cmd('highlight! link FlutterWidgetGuides Comment')
		end,
		capabilities = require("lsp-zero").build_options("dartls", {}).capabilities,
		settings = {
			enableSnippets = false,
			showTodos = true,
			completeFunctionCalls = true,
			analysisExcludedFolders = {
				vim.fn.expand '$HOME/.pub-cache',
				vim.fn.expand '$HOME/fvm',
			},
			lineLength = 100,
		},
	}
}

return L
