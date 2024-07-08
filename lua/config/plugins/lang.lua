local compileRun = function()
	vim.cmd('w')
	-- check file type
	local ft = vim.bo.filetype
	if ft == 'sh' then
		require('config.lang.sh').run_action()
	elseif ft == 'lua' then
		require('config.lang.lua').run_action()
	elseif ft == 'python' then
		require('config.lang.python').run_action()
	elseif ft == 'c' then
		require('config.lang.c').run_action()
	elseif ft == 'swift' then
		require('config.lang.swift').run_action()
	elseif ft == 'objc' then
		require('config.lang.objc').run_action()
	elseif ft == 'rust' then
		require('config.lang.rust').run_action()
	elseif ft == 'markdown' then
		require('config.lang.markdown').run_action()
	end
end

vim.keymap.set('n', '<c-r>', compileRun, { silent = true })

M = {
	require('config.lang.rust').plugins,

	require('config.lang.markdown').plugins,
}

return M
