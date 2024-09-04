M = {
    plugins = {
        -- xcode 项目的 构建，运行，测试功能插件
        "wojciech-kulik/xcodebuild.nvim",
        lazy = false,
        dependencies = { 'MunifTanjim/nui.nvim' },
        -- 配置在 lang/swift.lua 中
        config = function()
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
                console_logs = {
                    enabled = true, -- enable console logs in dap-ui
                    format_line = function(line) -- format each line of logs
                        return line
                    end,
                    filter_line = function(line) -- filter each line of logs
                        return true
                    end,
                },
                marks = {
                    show_signs = true, -- show each test result on the side bar
                    success_sign = "✔", -- passed test icon
                    failure_sign = "✖", -- failed test icon
                    show_test_duration = true, -- show each test duration next to its declaration
                    show_diagnostics = true, -- add test failures to diagnostics
                },
                quickfix = {
                    show_errors_on_quickfixlist = true, -- add build/test errors to quickfix list
                    show_warnings_on_quickfixlist = true, -- add build warnings to quickfix list
                },
                test_explorer = {
                    enabled = true, -- enable Test Explorer
                    auto_open = true, -- open Test Explorer when tests are started
                    auto_focus = true, -- focus Test Explorer when opened
                    open_command = "botright 42vsplit Test Explorer", -- command used to open Test Explorer, must create a buffer with "Test Explorer" name
                    open_expanded = true, -- open Test Explorer with expanded classes
                    success_sign = "✔", -- passed test icon
                    failure_sign = "✖", -- failed test icon
                    progress_sign = "…", -- progress icon (only used when animate_status=false)
                    disabled_sign = "⏸", -- disabled test icon
                    partial_execution_sign = "‐", -- icon for a class or target when only some tests were executed
                    not_executed_sign = " ", -- not executed or partially executed test icon
                    show_disabled_tests = false, -- show disabled tests
                    animate_status = true, -- animate status while running tests
                    cursor_follows_tests = true, -- moves cursor to the last test executed
                },
                code_coverage = {
                    enabled = false, -- generate code coverage report and show marks
                    file_pattern = "*.swift", -- coverage will be shown in files matching this pattern
                    -- configuration of line coverage presentation:
                    covered_sign = "",
                    partially_covered_sign = "┃",
                    not_covered_sign = "┃",
                    not_executable_sign = "",
                },
                code_coverage_report = {
                    warning_coverage_level = 60,
                    error_coverage_level = 30,
                    open_expanded = false,
                },
                integrations = {
                    xcode_build_server = {
                        enabled = true, -- run "xcode-build-server config" when scheme changes
                    },
                    nvim_tree = {
                        enabled = true,      -- enable updating Xcode project files when using nvim-tree
                        guess_target = true, -- guess target for the new file based on the file path
                        should_update_project = function(path) -- path can lead to directory or file
                            -- it could be useful if you mix Xcode project with SPM for example
                            return true
                        end,
                    },
                    quick = { -- integration with Swift test framework: github.com/Quick/Quick
                        enabled = true, -- enable Quick tests support (requires Swift parser for nvim-treesitter)
                    },
                },
                highlights = {
                    -- you can override here any highlight group used by this plugin
                    -- simple color: XcodebuildCoverageReportOk = "#00ff00",
                    -- link highlights: XcodebuildCoverageReportOk = "DiagnosticOk",
                    -- full customization: XcodebuildCoverageReportOk = { fg = "#00ff00", bold = true },
                },
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "swift", "objc", "objective-c", "objcpp", "objective-cpp" },

                callback = function()
                    vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildPicker<cr>",
                        { desc = "Show All Xcodebuild Actions" })
                    vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })
                    vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
                    vim.keymap.set("n", "<leader>xs", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
                    vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>",
                        { desc = "Toggle Xcodebuild Logs" })

                    -- vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
                    -- vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })
                    -- vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
                    -- vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>",
                    -- 	{ desc = "Toggle Code Coverage" })
                    -- vim.keymap.set("n", "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>",
                    -- 	{ desc = "Show Code Coverage Report" })
                end,
            })

            require('telescope').load_extension('simulators')
            require('simulators').setup({
                apple_simulator = true,
                android_emulator = false,
            })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "swift", "objc", "objective-c", "objcpp", "objective-cpp" },

                callback = function()
                    vim.keymap.set("n", "<leader>xS", "<cmd>Telescope simulators run<cr><esc>",
                        { desc = "Open The Simulators" })
                end
            })

            -- for dap
            local xcodebuild_dap = require("xcodebuild.integrations.dap")
            local codelldbPath = vim.g.mason_package_path .. '/codelldb/extension/adapter/codelldb'
            xcodebuild_dap.setup(codelldbPath)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "swift", "objc", "objective-c", "objcpp", "objective-cpp" },

                callback = function()
                    -- 重定向 运行 快捷键
                    vim.keymap.set("n", "<leader>dr", function()
                        xcodebuild_dap.build_and_debug()
                        require('dapui').open()
                    end)
                    -- 重定向 重新运行 快捷键到 不编译调试
                    vim.keymap.set("n", "<leader>dR", function()
                        xcodebuild_dap.debug_without_build()
                        require('dapui').open()
                    end)
                    -- 重定向 关闭 dap 和 dapui 快捷键
                    vim.keymap.set("n", "<Leader>dq", function()
                        require('dap').terminate()
                        require('dapui').close()
                        require("xcodebuild.actions").cancel()
                    end)
                    -- 重定向 关闭 dap 快捷键
                    vim.keymap.set("n", "<Leader>dQ", function()
                        require('dap').terminate()
                        require("xcodebuild.actions").cancel()
                    end)
                end
            })
        end
    },
}

return M
