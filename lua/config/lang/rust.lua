L = {
	plugins = {
		{
			-- rust
			-- rust 的配置管理插件
			-- 所有的 rust 配置统一由该插件管理
			'mrcjkb/rustaceanvim',
			version = '^4',
			ft = { 'rust' },
			config = function()
				vim.g.rustaceanvim = {
					tools = {
					},
					server = {
						on_attach = function(client, bufnr)
							require('config.lang.rust').lsp.setup(client, bufnr)
						end,
						default_settings = {
							['rust-analyzer'] = {
								require('config.lang.rust').rust_analyzer_config,
							},
						},
					},
					dap = require('config.lang.rust').dap.setup(),
				}
			end
		},
	},

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
	compile_run = {
		setup = function()
		end,

		run_action = function()
			vim.cmd.RustLsp('runnables')
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
}

return L
