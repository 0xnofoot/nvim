M = {
    'nvim-treesitter/nvim-treesitter',

    lazy = false,
    priority = 1000,
    build = ":TSUpdate",

    config = function()
        vim.opt.smartindent = false

        require('nvim-treesitter.configs').setup({
            sync_install = false,
            auto_install = true,

            modules = {
            },

            ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'python', 'bash', 'swift', 'objc', 'rust', 'dart' },

            indent = {
                enable = true
            },

            ignore_install = {
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<CR>',
                    node_incremental = '<CR>',
                    node_decremental = '<BS>',
                    scope_incremental = '<TAB>',
                }
            },

            highlight = {
                enable = true,

                disable = function(_, buf)
                    local full_filename = vim.api.nvim_buf_get_name(buf)
                    local ok, stats = pcall(vim.loop.fs_stat, full_filename)

                    if ok and stats then
                        -- 文件大小限制
                        local max_filesize = 100 * 1024 -- 100 KB
                        if stats.size > max_filesize then
                            return true
                        end

                        -- 日志文件限制
                        if string.match(string.lower(full_filename), "%.log$") ~= nil then
                            return true
                        end
                    end

                    return false
                end,

                additional_vim_regex_highlighting = false,
            },

            rainbow = {
                enable = false,
                disable = {},
                extended_mode = false,
                max_file_lines = nil,
            }
        })
    end,

    vim.treesitter.language.register('objc', 'objcpp')
}


return M
