local m = { noremap = true, nowait = true }

M = {
    {
        'nvim-telescope/telescope.nvim',
        keys = '<leader>ef',
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
    },

    {
        'ibhagwan/fzf-lua',
        keys = { '<c-f>' },
        config = function()
            local fzf = require('fzf-lua')
            vim.keymap.set('n', '<c-f>', function()
                fzf.grep({ search = '', fzf_opts = { ['--layout'] = 'default' } })
            end, { noremap = true })
            vim.keymap.set('x', '<c-f>', function()
                fzf.grep_visual({ fzf_opts = { ['--layout'] = 'default' } })
            end, { noremap = true })
            fzf.setup({
                global_resume       = true,
                global_resume_query = true,
                winopts             = {
                    height     = 0.9,
                    width      = 0.9,
                    fullscreen = false,

                    preview    = {
                        layout     = 'vertical',
                        scrollbar  = 'float',
                        vertical   = 'down:45%',  -- up|down:size
                        horizontal = 'right:60%', -- right|left:size
                        hidden     = 'nohidden',
                    },
                },
                keymap              = {
                    builtin = {
                        ['<c-p>'] = 'toggle-preview',
                        -- ['ctrl-h']	   = 'preview-page-up',
                        -- ['ctrl-l']     = 'preview-page-down',
                    },
                    fzf = {
                        ['esc']    = 'abort',
                        ['ctrl-i'] = 'beginning-of-line',
                        ['ctrl-a'] = 'end-of-line',
                        ['ctrl-k'] = 'up',
                        ['ctrl-j'] = 'down',
                        -- ['ctrl-h']	   = 'preview-page-up',
                        -- ['ctrl-l']     = 'preview-page-down',
                    },
                },
                previewers          = {
                    head = {
                        cmd  = 'head',
                        args = nil,
                    },
                    git_diff = {
                        cmd_deleted   = 'git diff --color HEAD --',
                        cmd_modified  = 'git diff --color HEAD',
                        cmd_untracked = 'git diff --color --no-index /dev/null',
                    },
                    man = {
                        cmd = 'man -c %s | col -bx',
                    },
                    builtin = {
                        syntax         = true,        -- preview syntax highlight?
                        syntax_limit_l = 0,           -- syntax limit (lines), 0=nolimit
                        syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
                    },
                },
                files               = {
                    prompt       = 'Files❯ ',
                    multiprocess = true, -- run command in a separate process
                    git_icons    = true, -- show git icons?
                    file_icons   = true, -- show file icons?
                    color_icons  = true, -- colorize file|git icons
                    find_opts    = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
                    rg_opts      = '--color=never --files --hidden --follow -g \'!.git\'',
                    fd_opts      = '--color=never --type f --hidden --follow --exclude .git',
                },
                buffers             = {
                    prompt        = 'Buffers❯ ',
                    file_icons    = true, -- show file icons?
                    color_icons   = true, -- colorize file|git icons
                    sort_lastused = true, -- sort buffers() by last used
                },
            })
        end

    }
}

return M
