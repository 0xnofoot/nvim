M = {
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
                    vertical   = 'down:45%', -- up|down:size
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
                    syntax         = true, -- preview syntax highlight?
                    syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
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

return M
