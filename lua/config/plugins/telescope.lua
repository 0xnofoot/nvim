local m = { noremap = true, nowait = true }

M = {
    'nvim-telescope/telescope.nvim',
    keys = '<leader>ef',
    tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'LukasPietzschmann/telescope-tabs',
            config = function()
                local tstabs = require('telescope-tabs')
                tstabs.setup({
                })
                vim.keymap.set('n', '<leader>et', tstabs.list_tabs, {})
            end
        },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'dimaportenko/telescope-simulators.nvim',
    },
    config = function()
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>ef', builtin.find_files, m)
        vim.keymap.set('n', '<leader>eg', builtin.live_grep, m)
        vim.keymap.set('n', '<leader>er', builtin.resume, m)
        vim.keymap.set('n', '<leader>es', builtin.spell_suggest, m)
        vim.keymap.set('n', '<leader>eb', builtin.buffers, m)
        vim.keymap.set('n', '<leader>eo', builtin.oldfiles, m)
        vim.keymap.set('n', '<leader>ep', builtin.registers, m)
        vim.keymap.set('n', '<leader>ed', function()
            builtin.diagnostics({
                severity_sort = true,
            })
        end, m)

        local ts = require('telescope')

        ts.setup({
            defaults = {
                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--fixed-strings',
                    '--smart-case',
                    '--trim',
                },
                layout_config = {
                    width = 0.9,
                    height = 0.9,
                },
                mappings = {
                    i = {
                        ['<C-w>'] = 'which_key',
                        ['<C-j>'] = 'preview_scrolling_down',
                        ['<C-k>'] = 'preview_scrolling_up',
                        ['<C-n>'] = require('telescope.actions').cycle_history_next,
                        ['<C-p>'] = require('telescope.actions').cycle_history_prev,
                        ['<S-Tab>'] = require('telescope.actions').move_selection_next,
                        ['<Tab>'] = require('telescope.actions').move_selection_previous,
                    },
                    n = {
                        ['<C-j>'] = 'preview_scrolling_down',
                        ['<C-k>'] = 'preview_scrolling_up',
                        ['<S-Tab>'] = require('telescope.actions').move_selection_next,
                        ['<Tab>'] = require('telescope.actions').move_selection_previous,
                    },
                },
                color_devicons = true,
                prompt_prefix = '󰱽  ',
                selection_caret = ' ',
                path_display = { 'truncate' },
                file_previewer = require('telescope.previewers').vim_buffer_cat.new,
                grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
            },
            pickers = {
                buffers = {
                    show_all_buffers = true,
                    sort_lastused = true,
                    mappings = {
                        i = {
                            ['<c-d>'] = require('telescope.actions').delete_buffer,
                        },
                        n = {
                            ['<c-d>'] = require('telescope.actions').delete_buffer,
                        },
                    },
                },
            },

            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = 'smart_case',
                },
            },

        })

        ts.load_extension('telescope-tabs')
        ts.load_extension('fzf')
    end
}


return M
