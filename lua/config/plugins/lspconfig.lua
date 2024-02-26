local F = {
	signature_opt = {
		bind = true,
		floating_window = true,
		hint_prefix = '🐰 ',
		hint_scheme = 'luna',
		hint_inline = function() return false end,
		handler_opts = {
			border = 'rounded'
		},
		always_trigger = true,
		hi_parameter = 'IncSearch',
		toggle_key = '<c-a>',
		toggle_key_flip_floatwin_setting = true,
	},
}

M = {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v3.x',

	dependencies = {
		{
			-- Mason 管理插件
			'williamboman/mason.nvim',
		},

		{
			-- Mason lsp管理插件
			'williamboman/mason-lspconfig.nvim',
		},

		{
			-- 一个第三方的 mason 管理插件，因为 mason-lspconfig 只能管理lsp
			-- 这个插件可以管理 dap，format，linter
			-- 当然也可以管理 lsp，但是 lsp 交给 mason-lspcofig 管理了
			'WhoIsSethDaniel/mason-tool-installer.nvim',
		},

		{
			-- nvim 提供的 lsp 配置插件
			'neovim/nvim-lspconfig'
		},

		{
			-- 方法签名预览
			'ray-x/lsp_signature.nvim',
			event = 'VeryLazy',
			config = function()
				require('lsp_signature').setup(F.signature_opt)

				vim.keymap.set({ 'n' }, '<C-a>', function()
					require('lsp_signature').toggle_float_win()
				end, { silent = true, noremap = true, desc = 'toggle signature' })
			end
		},

		{
			-- 代码问题检查
			'folke/trouble.nvim',
			dependencies = {
				'nvim-tree/nvim-web-devicons'
			},
			opts = {
				use_diagnostic_signs = true,
				cycle_results = false,
				action_keys = {
					close = 'q',
					cancle = '<esc>',
					jump = { "<cr>", "<tab>", "<2-leftmouse>" },
					open_split = { "<c-j>" },
					open_vsplit = { "<c-l>" },
					open_tab = { "<c-t>" },
					jump_close = { "o" },
				},
			},
		},
		{
			-- efm 的扩展配置，用于快速调用 formatter 和 linter
			'creativenull/efmls-configs-nvim',
			version = 'v1.x.x', -- version is optional, but recommended
		},

		{
			-- 提供 vim.lua 的 lsp
			'folke/neodev.nvim',
		},

		{
			-- 提供 lsp 加载进度的 UI 提示
			'j-hui/fidget.nvim',
			config = function()
				require('fidget').setup({})
			end,
		},
	},

	config = function()
		local lsp_zero = require('lsp-zero')
		local lspconfig = require('lspconfig')

		lsp_zero.on_attach(function(client, bufnr)
			require('lsp_signature').on_attach(F.signature_opt, bufnr)

			-- for barbecue winbar
			if client.server_capabilities["documentSymbolProvider"] then
				require("nvim-navic").attach(client, bufnr)
			end

			lsp_zero.default_keymaps({ buffer = bufnr })
		end)

		vim.api.nvim_create_autocmd('LspAttach', {
			desc = 'LSP actions',
			callback = function(event)
				local opts = { buffer = event.buf, noremap = true, nowait = true }

				vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
				vim.keymap.set('n', 'gD', ':tab sp<CR><cmd>lua vim.lsp.buf.definition()<cr>', opts)
				vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
				vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
				vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
				vim.keymap.set('n', '<leader>gr', vim.lsp.buf.rename, opts)
				vim.keymap.set('n', '<leader>ga', vim.lsp.buf.code_action, opts)
				vim.keymap.set('n', '<leader>gt', ':Trouble<cr>', opts)
				vim.keymap.set({ 'n', 'x' }, '<leader>gf', function() vim.lsp.buf.format({ async = true }) end, opts)
				vim.keymap.set('n', '<leader>-', vim.diagnostic.goto_prev, opts)
				vim.keymap.set('n', '<leader>=', vim.diagnostic.goto_next, opts)
			end
		})

		require('mason').setup({})

		require('mason-lspconfig').setup({
			ensure_installed = {
				'lua_ls',
				'pylsp',
				-- 'bashls',
				'efm',
			},
			auto_update = false,
			handlers = {
				lsp_zero.default_setup,

				-- lsp 个性化配置, 对每个语言都单独使用一份 .lua 文件
				-- 保存在 config/lang/*.lua 中, 变量名称必须与 lsp 的名称相同
				-- 在 .lua 文件中 调用 .lsp.setup(lspconfig) 来进行配置
				lua_ls = require('config.lang.lua').lsp.setup(lspconfig),
				pylsp = require('config.lang.python').lsp.setup(lspconfig),
				bashls = require('config.lang.sh').lsp.setup(lspconfig),
				-- efm （extension format module 可以配置文件类型对应的 formatter , linter
				efm = require('config.lang.efm').lsp.setup(lspconfig),
			}
		})

		require('mason-tool-installer').setup({
			ensure_installed = {
				'beautysh',
			},
			auto_update = false,
			run_on_start = true, -- Use MasonToolsUpdate to run this
		})

		vim.diagnostic.config({
			severity_sort = true,
			underline = true,
			signs = true,
			virtual_text = true,
			update_in_insert = false,
			float = true,
		})

		vim.fn.sign_define("DiagnosticSignError",
			{ text = " ", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn",
			{ text = " ", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo",
			{ text = " ", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint",
			{ text = "󰌵", texthl = "DiagnosticSignHint" })

		lsp_zero.set_sign_icons({
			error = ' ',
			warn = ' ',
			info = ' ',
			hint = '󰌵',
		})

		lsp_zero.format_on_save({
			format_opts = {
				async = false,
				timeout_ms = 10000,
			},
		})
	end
}

return M
