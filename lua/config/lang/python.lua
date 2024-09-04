L = {
    run_action = function()
        vim.cmd('set splitbelow')
        vim.cmd('sp')
        vim.cmd('res -5')
        vim.cmd('term python3 %')
    end,

    dap = {
        setup = function(dap)
            dap.configurations.python = {
                {
                    type = 'python',
                    request = 'launch',
                    name = 'Launch file',
                    program = '${file}',
                    pythonPath = vim.g.python,
                },
            }

            dap.adapters.python = {
                type = 'executable',
                command = vim.g.python,
                args = { '-m', 'debugpy.adapter' },
            }
        end,
    },
}

return L
