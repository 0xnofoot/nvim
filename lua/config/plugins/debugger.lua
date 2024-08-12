M = {
	'mfussenegger/nvim-dap',

	dependencies = {
		{ 'theHamsta/nvim-dap-virtual-text' },
		{ 'rcarriga/nvim-dap-ui' },
		{ 'nvim-dap-virtual-text' },
		{ 'nvim-telescope/telescope-dap.nvim' },
		{ 'nvim-neotest/nvim-nio' },
	},

	config = function()
		local dap = require('dap')
		local dapui = require('dapui')

		dap.defaults.fallback.switchbuf = 'usetab,uselast'

		require('nvim-dap-virtual-text').setup({})
		require('dapui').setup(
			{
				layouts = {
					{
						elements = {
							{
								id = "breakpoints",
								size = 0.23
							},
							{
								id = "scopes",
								size = 0.27
							},
							{
								id = "watches",
								size = 0.5
							},
						},
						position = "left",
						size = 30
					},
					{
						elements = {
							{
								id = "repl",
								size = 1
							},
						},
						position = "bottom",
						size = 10
					}
				},
				mappings = {
					edit = "e",
					expand = { "<CR>", "<2-LeftMouse>" },
					open = { "o", "<MiddleMouse>" },
					remove = "d",
					repl = "r",
					toggle = "t"
				},
			}
		)

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open

		vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '', bg = '#432831' })
		vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#43353f' })
		vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#ffffff', bg = '#C00000' })

		vim.fn.sign_define('DapBreakpoint',
			{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
		vim.fn.sign_define('DapBreakpointCondition',
			{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
		vim.fn.sign_define('DapBreakpointRejected',
			{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
		vim.fn.sign_define('DapLogPoint', {
			text = '',
			texthl = 'DapLogPoint',
			linehl = 'DapLogPoint',
			numhl = 'DapLogPoint'
		})
		vim.fn.sign_define('DapStopped',
			{ text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
		vim.keymap.set("n", "<c-b>", dap.toggle_breakpoint)
		vim.keymap.set("n", "<leader>dl", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end)
		vim.keymap.set("n", "<leader>dc", dap.continue)
		vim.keymap.set("n", "<leader>ds", dap.step_over)
		vim.keymap.set("n", "<leader>di", dap.step_into)
		vim.keymap.set("n", "<leader>do", dap.step_out)
		vim.keymap.set('n', '<Leader>dr', dap.restart)
		vim.keymap.set('n', '<Leader>dx', dap.terminate)
		vim.keymap.set('n', '<Leader>dd', function()
			dapui.toggle({ reset = true })
		end)

		vim.keymap.set("n", "<leader>dq", function()
			dap.terminate()
			dapui.close()
		end)

		require('telescope').load_extension('telescope-tabs')

		local tsdap = require('telescope').extensions.dap
		local m = { noremap = true, nowait = true }

		vim.keymap.set('n', "<leader>'v", tsdap.variables, m)
		vim.keymap.set('n', "<leader>'c", tsdap.commands, m)
		vim.keymap.set('n', "<leader>'b", tsdap.list_breakpoints, m)
		vim.keymap.set('n', "<leader>'f", tsdap.frames, m)

		-- for python
		require('config.lang.python').dap.setup(dap)

		-- for dart flutter
		require('config.lang.dart').dap.setup(dap)

		-- xcode project 的调试被 xcodebuild 插件集成了
		-- rust dap 交由 rustaceanvim 管理
	end,
}

return M
