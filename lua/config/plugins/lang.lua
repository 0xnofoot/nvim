local compileRun = function()
	vim.cmd('w')
	-- check file type
	local ft = vim.bo.filetype
	if ft == 'sh' then
		require('config.lang.sh').compile_run.run_action()
	elseif ft == 'lua' then
		require('config.lang.lua').compile_run.run_action()
	elseif ft == 'python' then
		require('config.lang.python').compile_run.run_action()
	elseif ft == 'swift' then
		require('config.lang.swift').compile_run.run_action()
	elseif ft == 'rust' then
		require('config.lang.rust').compile_run.run_action()
	end
end

vim.keymap.set('n', '<c-r>', compileRun, { silent = true })

M = {
	{
		-- swift
		-- xcode 项目的 构建，运行，测试功能插件
		"wojciech-kulik/xcodebuild.nvim",
		dependencies = { 'MunifTanjim/nui.nvim' },
		-- 配置在 lang/swift.lua 中
		config = require('config.lang.swift').compile_run.setup
	},

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
}

return M
