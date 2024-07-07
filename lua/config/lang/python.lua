L = {
	run_action = function()
		vim.cmd('set splitbelow')
		vim.cmd('sp')
		vim.cmd('res -5')
		vim.cmd('term python3 %')
	end,

	dap = {
		setup = function(dap)
			dap.configurations.python = {
				{
					type = 'python',
					request = 'launch',
					name = 'Launch file',
					program = '${file}',
					pythonPath = function()
						return vim.g.python3_host_prog
					end,
				},
			}

			dap.adapters.python = {
				type = 'executable',
				command = os.getenv('HOME') .. '/.virtualenvs/debugpy/bin/python',
				args = { '-m', 'debugpy.adapter' },
			}
		end,
	},
}

return L
