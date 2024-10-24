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
                fvm           = true,

                widget_guides = {
                    enabled = true,
                },
                closing_tags  = {
                    enabled = true,
                    highlight = nil,
                    prefix = "  >",
                    priority = 10
                },

                ui            = {
                    border = "rounded",
                    notification_style = 'nvim-notify'
                },

                lsp           = require("config.lsp.dartls").config,

                root_patterns = { ".git", "pubspec.yaml" }, -- patterns to find the root of your flutter project

                dev_tools     = {
                    autostart = true,         -- autostart devtools server if not detected
                    auto_open_browser = true, -- Automatically opens devtools in the browser
                },

                dev_log       = {
                    enabled = false,
                    notify_errors = true, -- if there is an error whilst running then notify the user
                    open_cmd = "botright split",
                },

                debugger      = {
                    enabled = true,
                    exception_breakpoints = {
                        {
                            filter = 'raised',
                            label = 'Exceptions',
                            condition =
                            "!(url:startsWith('package:flutter/') || url:startsWith('package:flutter_test/') || url:startsWith('package:dartpad_sample/') || url:startsWith('package:flutter_localizations/'))"
                        }
                    },
                    register_configurations = function(_)
                        require("dap.ext.vscode").load_launchjs()
                    end,
                },
            })

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
        end
    }
}

return M
