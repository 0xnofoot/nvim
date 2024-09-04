L = {
    run_action = function()
        vim.cmd('set splitbelow')
        vim.cmd('sp')
        vim.cmd('res -5')
        vim.cmd('term sh %')
    end,
}

return L
