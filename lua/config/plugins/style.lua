M = {
    {
        -- 基本主题设置
        "theniceboy/nvim-deus",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme deus]])
        end,
    },

    {
        -- 上方代码块指示栏
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },

        config = function()
            vim.opt.updatetime = 200
            vim.api.nvim_create_autocmd(
                {
                    "WinResized",
                    "BufWinEnter",
                    "CursorHold",
                    "InsertLeave",
                    -- include this if you have set `show_modified` to `true`
                    "BufModifiedSet",
                },

                {
                    group = vim.api.nvim_create_augroup("barbecue.updater", {}),
                    callback = function()
                        require("barbecue.ui").update()
                    end,
                }
            )

            require("barbecue").setup({
                create_autocmd = false, -- prevent barbecue from updating itself automatically
                attach_navic = false,   -- prevent barbecue from automatically attaching nvim-navic
                show_modified = true,

                theme = {
                    normal = { fg = "#F5691E", bg = "#3C424B", bold = false },

                    ellipsis = { fg = "#CFCFCF" },
                    separator = { fg = "#87CEFF", bold = true },
                    modified = { fg = "#FFD700" },

                    dirname = { fg = "#FFAB00", bold = true },
                    basename = { bold = false },
                    context = {},

                    -- these highlights are used for context/navic icons
                    context_file = { fg = "#FF69B4" },
                    context_module = { fg = "#FF69B4" },
                    context_namespace = { fg = "#FF69B4" },
                    context_package = { fg = "#FF69B4" },
                    context_class = { fg = "#FF69B4" },
                    context_method = { fg = "#FF69B4" },
                    context_property = { fg = "#FF69B4" },
                    context_field = { fg = "#FF69B4" },
                    context_constructor = { fg = "#FF69B4" },
                    context_enum = { fg = "#FF69B4" },
                    context_interface = { fg = "#FF69B4" },
                    context_function = { fg = "#FF69B4" },
                    context_variable = { fg = "#FF69B4" },
                    context_constant = { fg = "#FF69B4" },
                    context_string = { fg = "#FF69B4" },
                    context_number = { fg = "#FF69B4" },
                    context_boolean = { fg = "#FF69B4" },
                    context_array = { fg = "#FF69B4" },
                    context_object = { fg = "#FF69B4" },
                    context_key = { fg = "#FF69B4" },
                    context_null = { fg = "#FF69B4" },
                    context_enum_member = { fg = "#FF69B4" },
                    context_struct = { fg = "#FF69B4" },
                    context_event = { fg = "#FF69B4" },
                    context_operator = { fg = "#FF69B4" },
                    context_type_parameter = { fg = "#FF69B4" },
                },
            })
        end
    },

    {
        -- 上方选项卡
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            options = {
                mode = "buffers",
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, _, _)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end,
                indicator = {
                    icon = "▎", -- this should be omitted if indicator style is not "icon"
                    -- style = "icon" | "underline" | "none",
                    style = "icon",
                },
                show_buffer_close_icons = false,
                show_close_icon = false,
                enforce_regular_tabs = true,
                show_duplicate_prefix = false,
                tab_size = 16,
                padding = 0,
                separator_style = "thick",
            }
        },
    },

    {
        -- 下方状态栏
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'auto',
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = true,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    }
                },
                sections = {
                    lualine_a = { 'filename' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = { 'filesize', 'encoding', 'filetype' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
            }
        end
    },

    {
        -- git 符号设置
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                signs                        = {
                    add          = { text = '▎' },
                    change       = { text = '░' },
                    delete       = { text = '_' },
                    topdelete    = { text = '▔' },
                    changedelete = { text = '▒' },
                    untracked    = { text = '┆' },
                },
                signs_staged                 = {
                    add          = { text = '▎' },
                    change       = { text = '░' },
                    delete       = { text = '_' },
                    topdelete    = { text = '▔' },
                    changedelete = { text = '▒' },
                    untracked    = { text = '┆' },
                },
                signs_staged_enable          = true,
                signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
                numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
                linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir                 = {
                    follow_files = true
                },
                auto_attach                  = true,
                attach_to_untracked          = false,
                current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts      = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                },
                current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
                sign_priority                = 6,
                update_debounce              = 100,
                status_formatter             = nil,   -- Use default
                max_file_length              = 40000, -- Disable if file is longer than this (in lines)
                preview_config               = {
                    -- Options passed to nvim_open_win
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
            }
        end
    },

    {
        -- 右侧滑动条
        'petertriho/nvim-scrollbar',
        dependencies = {
            -- {
            -- 	-- 查找高亮
            -- 	'kevinhwang91/nvim-hlslens',
            -- 	config = function()
            -- 	end
            -- },
        },
        config = function()
            -- 暂时放在这，因为查找高亮用起来有bug，找到合适插件再说
            vim.api.nvim_set_keymap('n', '<Leader><CR>', '<Cmd>noh<CR>', { noremap = true, silent = true })
            --

            local group = vim.api.nvim_create_augroup('scrollbar_set_git_colors', {})
            vim.api.nvim_create_autocmd('BufEnter', {
                pattern = '*',
                callback = function()
                    vim.cmd([[
						hi! ScrollbarGitAdd guifg=#8CC85F
						hi! ScrollbarGitAddHandle guifg=#A0CF5D
						hi! ScrollbarGitChange guifg=#E6B450
						hi! ScrollbarGitChangeHandle guifg=#F0C454
						hi! ScrollbarGitDelete guifg=#F87070
						hi! ScrollbarGitDeleteHandle guifg=#FF7B7B
					]])
                end,
                group = group,
            })
            -- require('scrollbar.handlers.search').setup({})
            require('scrollbar.handlers.gitsigns').setup()
            require('scrollbar').setup({
                show = true,
                handle = {
                    text = ' ',
                    color = '#788374',
                    hide_if_all_visible = true,
                },
                marks = {
                    -- Search = { color = 'yellow' },
                    Misc = { color = 'purple' },
                },
                handlers = {
                    cursor = false,
                    diagnostic = true,
                    gitsigns = true,
                    handle = true,
                    -- search = true,
                    search = false,
                },
            })
        end,
    },

    {
        -- 缩进块和代码块线条
        'shellRaining/hlchunk.nvim',
        init = function()
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { pattern = '*', command = 'EnableHL', })
            require('hlchunk').setup({
                chunk = {
                    enable = true,
                    use_treesitter = true,
                    style = {
                        { fg = '#806d9c' },
                    },
                },
                indent = {
                    chars = { '│', '¦', '┆', '┊', },
                    use_treesitter = false,
                },
                blank = {
                    enable = false,
                },
                line_num = {
                    use_treesitter = true,
                },
            })
        end,
    },

    {
        -- 命令栏优化
        'gelguy/wilder.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            local wilder = require('wilder')
            wilder.setup {
                modes = { ':' },
                next_key = '<Tab>',
                previous_key = '<S-Tab>',
            }
            wilder.set_option('renderer', wilder.popupmenu_renderer(
                wilder.popupmenu_palette_theme({
                    highlights = {
                        border = 'Normal', -- highlight to use for the border
                    },
                    left = { ' ', wilder.popupmenu_devicons() },
                    right = { ' ', wilder.popupmenu_scrollbar() },
                    border = 'rounded',
                    max_height = '75%',      -- max height of the palette
                    min_height = 0,          -- set to the same as 'max_height' for a fixed height window
                    prompt_position = 'top', -- 'top' or 'bottom' to set the location of the prompt
                    reverse = 0,             -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
                })
            ))
            wilder.set_option('pipeline', {
                wilder.branch(
                    wilder.cmdline_pipeline({
                        language = 'vim',
                        fuzzy = 1,
                    }), wilder.search_pipeline()
                ),
            })
        end
    },

    {
        -- 窗口分割美化
        'nvim-zh/colorful-winsep.nvim',
        config = true,
        event = { 'WinNew' },
    },

    {
        -- 彩虹分隔符
        'hiphish/rainbow-delimiters.nvim',
        config = function()
            local rainbow_delimiters = require 'rainbow-delimiters'

            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = rainbow_delimiters.strategy['global'],
                    vim = rainbow_delimiters.strategy['local'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                },
                priority = {
                    [''] = 110,
                    lua = 210,
                },
                highlight = {
                    'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
            }
        end
    },
}

return M
