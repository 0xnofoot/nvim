vim.api.nvim_create_autocmd("FileType", {
	pattern = { "dart" },

	callback = function()
		vim.opt.tabstop = 2
		vim.opt.shiftwidth = 2
		vim.opt.softtabstop = 2
	end
})

L = {

	plugins = {},

	run_action = function()
		vim.cmd('set splitbelow')
		vim.cmd('sp')
		vim.cmd('res -5')
		vim.cmd('term dart %')
	end,

	dap = {
		setup = function(dap)
			dap.configurations.dart = {
				{
					-- flutter
					type = "dart",
					request = "launch",
					name = "Launch Flutter Program",
					-- The nvim-dap plugin populates this variable with the filename of the current buffer
					program = "lib/main.dart",
					-- program = "${file}",
					-- The nvim-dap plugin populates this variable with the editor's current working directory
					cwd = "${workspaceFolder}",
					-- This gets forwarded to the Flutter CLI tool, substitute `linux` for whatever device you wish to launch
					toolArgs = { "-d", "macos" }
				}
			}

			dap.adapters.dart = {
				type = "executable",
				command = "flutter",
				args = { "debug_adapter" }
			}

			require("dap.ext.vscode").load_launchjs()
		end,
	},
}

return L
