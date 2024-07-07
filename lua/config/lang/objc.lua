L = {
	lsp = {
		setup = function(lspconfig)
		end,
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
		setup = function(dap)
		end,
	},

	compile_run = {
		setup = function()
		end,

		run_action = function()
			vim.cmd('set splitbelow')
			vim.cmd('sp')
			vim.cmd('res -5')
			vim.cmd('term clang -I /usr/lib/gcc/x86_64-linux-gnu/11/include -I /usr/include/GNUstep `gnustep-config --objc-flags` -L /usr/local/lib `gnustep-config --base-libs` -o %< % && ./%< && rm %< && rm %<.d')
		end,
	}
}

return L
