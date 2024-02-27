L = {
	lsp = {
		setup = function(client, bufnr)
			-- remap some key
			vim.keymap.set('n', '<leader>dc',
				function()
					vim.cmd.RustLsp('debuggables')
				end,
				{ silent = true, buffer = bufnr }
			)
		end,

		rust_analyzer_config = {

		},
	},

	format = {
		setup = function()
		end,
	},

	lint = {
		setup = function()
		end,
	},

	dap = {
		setup = function()
			local codelldb_path = vim.g.mason_package_path .. '/codelldb/extension/adapter/codelldb'
			local liblldb_path = vim.g.mason_package_path .. '/codelldb/extension/lldb/lib/liblldb.dylib'
			local cfg = require('rustaceanvim.config')

			return {
				adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
			}
		end,
	},

	compile_run = {
		setup = function()
		end,

		run_action = function()
			vim.cmd.RustLsp('runnables')
		end,
	}

}

return L
