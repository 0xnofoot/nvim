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
	end
end

vim.keymap.set('n', '<c-r>', compileRun, { silent = true })
-- vim.keymap.set('i', '<c-r>', compileRun, { silent = true })

M = {
	{
		-- xcode 项目的 构建，运行，测试功能插件
		"wojciech-kulik/xcodebuild.nvim",
		dependencies = { 'MunifTanjim/nui.nvim' },
		-- 配置在 lang/swift.lua 中
		config = require('config.lang.swift').compile_run.setup
	},
}

return M
