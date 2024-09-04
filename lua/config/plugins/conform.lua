M = {
    {
        -- 提供 range format 能力，不依靠 lsp
        'stevearc/conform.nvim',
        branch = "nvim-0.9",
        opts = {},
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    c = { "clang-format" },
                    cpp = { "clang-format" },
                    objc = { "clang-format" },
                    objcpp = { "clang-format" },
                    swift = { "swiftformat" }
                },

                default_format_opts = {
                    lsp_format = "never",
                },

                formatters = {
                    ["clang-format"] = {
                        command = "clang-format",
                        -- args = {},
                        inherit = true,
                        prepend_args = { "--style", "file:" .. vim.g.tool_config_path .. "/clang-format/clang-format.config" },
                        -- append_args = {},
                    },

                    swiftformat = {
                        command = "swiftformat",
                        -- args = {},
                        inherit = true,
                        -- prepend_args = {},
                        append_args = { "--baseconfig", vim.g.tool_config_path .. "/swiftformat/swiftformat.config" },
                    },
                },

            })

            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "*",
                callback = function(event)
                    local opts = { buffer = event.buf, noremap = true, nowait = true }
                    vim.keymap.set({ 'v' }, 'gf', require("conform").format, opts)

                    vim.keymap.set({ 'n' }, 'gf', function()
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('V', true, false, true), 'n', false)
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('gf', true, false, true), 'v', false)
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
                    end, opts)
                end,
            })
        end,
    },
}

return M
