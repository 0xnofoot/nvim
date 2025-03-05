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
            -- efm 的扩展配置，用于快速调用 formatter 和 linter
            -- fork了原始代码，只保留了目前使用的文件，自定义了一些东西
            '0xnofoot/efmls-configs-nvim',
            branch = "nofoot",
        },

        {
            -- 提供 vim.lua 的 lsp
            'folke/neodev.nvim',
        },

    },

    config = function()
        local lsp_zero = require('lsp-zero')
        local lspconfig = require('lspconfig')

        lsp_zero.on_attach(function(client, bufnr)
            -- for winbar
            if client.server_capabilities["documentSymbolProvider"] then
                require("nvim-navic").attach(client, bufnr)
            end

            lsp_zero.default_keymaps({ buffer = bufnr })
        end)

        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
                local opts = { buffer = event.buf, noremap = true, nowait = true }

                vim.keymap.set('n', 'gj', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
                vim.keymap.set('n', 'gR', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', 'gt', vim.diagnostic.open_float, opts)
                vim.keymap.set({ 'n', 'v', 'x' }, '<leader>gf', function() vim.lsp.buf.format({ async = true }) end,
                    opts)
            end
        })

        require('mason').setup({})

        require('mason-lspconfig').setup({
            ensure_installed = {
                'lua_ls',
                'efm',
            },
            auto_update = true,
            handlers = {

                -- lsp 个性化配置, 对每个 lsp 都单独使用一份 .lua 文件
                -- 保存在 config/lang/*.lua 中, 变量名称必须与 lsp 的名称相同
                -- 在 .lua 文件中 调用 .lsp.setup(lspconfig) 来进行配置
                lua_ls = require('config.lsp.lua_ls').setup(lspconfig),
                -- efm （extension format module 可以配置文件类型对应的 formatter , linter)
                efm = require('config.lsp.efm').setup(lspconfig),
            }
        })

        require('mason-tool-installer').setup({
            ensure_installed = {
                'shfmt',
                'shellcheck',
                'clang-format',
            },
            auto_update = true,
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
    end
}

return M
