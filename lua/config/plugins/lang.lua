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
	elseif ft == 'c' then
		require('config.lang.c').compile_run.run_action()
	elseif ft == 'swift' then
		require('config.lang.swift').compile_run.run_action()
	elseif ft == 'objc' then
		require('config.lang.objc').compile_run.run_action()
	elseif ft == 'rust' then
		require('config.lang.rust').compile_run.run_action()
	end
end

vim.keymap.set('n', '<c-r>', compileRun, { silent = true })

M = {
	require('config.lang.rust').plugins,
}

return M
