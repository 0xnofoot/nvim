M = {
	plugins = {
		'akinsho/flutter-tools.nvim',
		lazy = false,
		dependencies = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim', -- optional for vim.ui.select
		},
		config = function()
			require("telescope").load_extension("flutter")

			require("flutter-tools").setup({
				fvm = true,

				widget_guides = {
					enabled = true,
				},

				ui = {
					border = "rounded",
					notification_style = 'nvim-notify'
				},

				lsp = require("config.lsp.dartls").config,

				dev_log = {
					enabled = true,
					notify_errors = true, -- if there is an error whilst running then notify the user
					open_cmd = "botright 40vnew",
				},

				debugger = {
					enabled = true,
					run_via_dap = false,
					-- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
					-- see |:help dap.set_exception_breakpoints()| for more info
					exception_breakpoints = {
						{
							filter = 'raised',
							label = 'Exceptions',
							condition =
							"!(url:startsWith('package:flutter/') || url:startsWith('package:flutter_test/') || url:startsWith('package:dartpad_sample/') || url:startsWith('package:flutter_localizations/'))"
						}
					},
				},
				vim.api.nvim_create_autocmd("FileType", {
					pattern = { "dart" },

					callback = function()
						vim.keymap.set("n", "<leader>xc", "<cmd>Telescope flutter commands<cr><esc>")
						vim.keymap.set("n", "<leader>xr", "<cmd>FlutterRun<cr><esc>")
						vim.keymap.set("n", "<leader>xs", "<cmd>FlutterDevices<cr><esc>")
						vim.keymap.set("n", "<leader>xq", "<cmd>FlutterQuit<cr><esc>")
						vim.keymap.set("n", "<leader>xR", "<cmd>FlutterRestart<cr><esc>")
						vim.keymap.set("n", "<leader>xo", "<cmd>FlutterOutlineToggle<cr><esc>")

						vim.keymap.set("n", "<leader>xS", "<cmd>Telescope simulators run<cr><esc>",
							{ desc = "Open The Simulators" })
					end
				})
			})
		end
	}
}

return M
