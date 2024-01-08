L = {
	-- for lspconfig
	lsp = {
		setup = function(lspconfig)
			lspconfig.sourcekit.setup({
				init_options = {
					documentFormatting = true,
					documentRangeFormatting = true,
					hover = true,
					documentSymbol = true,
					codeAction = true,
					completion = true
				},

				cmd = {
					-- "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
					vim.g.sourcekit_path,
				},

				root_dir = function(filename, _)
					local util = require("lspconfig.util")
					return util.root_pattern("buildServer.json")(filename)
						or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
						or util.find_git_ancestor(filename)
						or util.root_pattern("Package.swift")(filename)
						or vim.fn.getcwd()
				end,
				completions = {
					completeFunctionCalls = true,
				},
			})

			-- 将 swiftinterface 文件当成 swift 文件 解析
			-- 这样子可以正确解析，但会出现一些麻烦，比如 诊断时会将 swiftinterface 文件也加入诊断
			-- LsoLog 中 sourcekit 的一个报错好像也与这个有关（存疑）
			-- todo 只是想 swiftinterface 文件有个高亮好辨识一点
			-- vim.cmd([[
			-- 	augroup SwiftInterface
			-- 	  autocmd!
			-- 	  autocmd BufNewFile,BufRead *.swiftinterface set filetype=swift
			-- 	augroup END
			-- ]])
		end,
	},

	-- for efm
	format = {
		setup = function()
			local f = {
				formatCommand = 'swiftformat stdin --output stdout --quiet --stdinpath "${INPUT}"',
				formatStdin = true,
			}

			return f
		end,
	},

	-- for efm
	lint = {
		setup = function()
			local l = {
				lintCommand = 'swiftlint lint --use-stdin --quiet',
				lintStdin = true,
				lintIgnoreExitCode = true,
				lintFormats = {
					'%.%#:%l:%c: %trror: %m',
					'%.%#:%l:%c: %tarning: %m',
				},
				rootMarkers = {
					'buildServer.json',
					'*.xcodeproj',
					'*.xcworkspace',
					'.git',
				},
			}

			return l
		end,
	},

	dap = {
		setup = function(dap)
			local xcodebuild = require("xcodebuild.dap")

			vim.keymap.set("n", "<leader>xdd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
			vim.keymap.set("n", "<leader>xdw", xcodebuild.debug_without_build, { desc = "Debug Without Building" })
			vim.keymap.set("n", "<Leader>xdx", function()
				dap.terminate()
				require("xcodebuild.actions").cancel()

				local success, dapui = pcall(require, "dapui")
				if success then
					dapui.close()
				end
			end)

			dap.configurations.swift = {
				{
					name = "iOS App Debugger",
					type = "codelldb",
					request = "attach",
					program = xcodebuild.get_program_path,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					waitFor = true,
				},
			}

			dap.adapters.codelldb = {
				type = "server",
				port = "23000",
				executable = {
					command = vim.g.codelldb_path,
					args = {
						'--port',
						'23000',
						'--liblldb',
						vim.g.liblldb_path,
						-- 调试时 codelldb 会报错 但并不影响使用
						-- todo
						-- 'SWIFT_LOG',
						-- 'error',
					},
				},
			}
		end,
	},

	compile_run = {
		setup = function()
			require("xcodebuild").setup({
				restore_on_start = true,   -- logs, diagnostics, and marks will be loaded on VimEnter (may affect performance)
				auto_save = true,          -- save all buffers before running build or tests (command: silent wa!)
				show_build_progress_bar = true, -- shows [ ...    ] progress bar during build, based on the last duration
				prepare_snapshot_test_previews = true, -- prepares a list with failing snapshot tests
				test_search = {
					file_matching = "filename_lsp", -- one of: filename, lsp, lsp_filename, filename_lsp. Check out README for details
					target_matching = true, -- checks if the test file target matches the one from logs. Try disabling it in case of not showing test results
					lsp_client = "sourcekit", -- name of your LSP for Swift files
					lsp_timeout = 200,     -- LSP timeout in milliseconds
				},
				commands = {
					cache_devices = true,      -- cache recently loaded devices. Restart Neovim to clean cache.
					extra_build_args = "-parallelizeTargets", -- extra arguments for `xcodebuild build`
					extra_test_args = "-parallelizeTargets", -- extra arguments for `xcodebuild test`
					project_search_max_depth = 3, -- maxdepth of xcodeproj/xcworkspace search while using configuration wizard
				},
				logs = {
					auto_open_on_success_tests = true,       -- open logs when tests succeeded
					auto_open_on_failed_tests = true,        -- open logs when tests failed
					auto_open_on_success_build = false,      -- open logs when build succeeded
					auto_open_on_failed_build = true,        -- open logs when build failed
					auto_close_on_app_launch = false,        -- close logs when app is launched
					auto_close_on_success_build = false,     -- close logs when build succeeded (only if auto_open_on_success_build=false)
					auto_focus = true,                       -- focus logs buffer when opened
					filetype = "objc",                       -- file type set for buffer with logs
					open_command = "silent bo split {path} | resize 10", -- command used to open logs panel. You must use {path} variable to load the log file
					logs_formatter = "xcbeautify --disable-colored-output", -- command used to format logs, you can use "" to skip formatting
					only_summary = false,                    -- if true logs won't be displayed, just xcodebuild.nvim summary
					show_warnings = true,                    -- show warnings in logs summary
					notify = function(message, severity)     -- function to show notifications from this module (like "Build Failed")
						vim.notify(message, severity)
					end,
					notify_progress = function(message) -- function to show live progress (like during tests)
						vim.cmd("echo '" .. message .. "'")
					end,
				},
				marks = {
					show_signs = true, -- show each test result on the side bar
					success_sign = "✔", -- passed test icon
					failure_sign = "✖", -- failed test icon
					success_sign_hl = "DiagnosticSignOk", -- highlight for success_sign
					failure_sign_hl = "DiagnosticSignError", -- highlight for failure_sign
					show_test_duration = true, -- show each test duration next to its declaration
					success_test_duration_hl = "DiagnosticWarn", -- test duration highlight when test passed
					failure_test_duration_hl = "DiagnosticError", -- test duration highlight when test failed
					show_diagnostics = true, -- add test failures to diagnostics
					file_pattern = "*Tests.swift", -- test diagnostics will be loaded in files matching this pattern (if available)
				},
				quickfix = {
					show_errors_on_quickfixlist = true, -- add build/test errors to quickfix list
					show_warnings_on_quickfixlist = true, -- add build warnings to quickfix list
				},
				code_coverage = {
					enabled = false, -- generate code coverage report and show marks
					file_pattern = "*.swift", -- coverage will be shown in files matching this pattern
					-- configuration of line coverage presentation:
					covered = {
						sign_text = "",
						sign_hl_group = "XcodebuildCoverageFull",
						number_hl_group = nil,
						line_hl_group = nil,
					},
					partially_covered = {
						sign_text = "┃",
						sign_hl_group = "XcodebuildCoveragePartial",
						number_hl_group = nil,
						line_hl_group = nil,
					},
					not_covered = {
						sign_text = "┃",
						sign_hl_group = "XcodebuildCoverageNone",
						number_hl_group = nil,
						line_hl_group = nil,
					},
					not_executable = {
						sign_text = "",
						sign_hl_group = "XcodebuildCoverageNotExecutable",
						number_hl_group = nil,
						line_hl_group = nil,
					},
				},
				code_coverage_report = {
					warning_coverage_level = 60,
					warning_level_hl_group = "DiagnosticWarn",
					error_coverage_level = 30,
					error_level_hl_group = "DiagnosticError",
					ok_level_hl_group = "DiagnosticOk",
					open_expanded = false,
				},
			})

			vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
			vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })
			vim.keymap.set("n", "<leader>xx", "<cmd>XcodebuildPicker<cr>", { desc = "Show All Xcodebuild Actions" })
			vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
			-- vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
			-- vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })
			-- vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
			-- vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
			-- vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>",
			-- 	{ desc = "Toggle Code Coverage" })
			-- vim.keymap.set("n", "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>",
			-- 	{ desc = "Show Code Coverage Report" })
			-- ts.load_extension('simulators')

			require('telescope').load_extension('simulators')
			require('simulators').setup({
				apple_simulator = true,
				android_emulator = false,
			})
			vim.keymap.set("n", "<leader>xs", "<cmd>Telescope simulators run<cr><esc>", { desc = "Open The Simulators" })
		end,

		run_action = function()
			vim.cmd('set splitbelow')
			vim.cmd('sp')
			vim.cmd('res -5')
			vim.cmd('term swift %')
		end,

	}

}


return L
