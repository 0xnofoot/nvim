M = {
    'theniceboy/joshuto.nvim',
    event = 'VeryLazy',
    cmd = 'Joshuto',
    config = function()
        vim.g.joshuto_floating_window_scaling_factor = 0.9
        vim.g.joshuto_use_neovim_remote = 1
        vim.g.joshuto_floating_window_winblend = 0

        vim.keymap.set('n', '<leader>ej', ':Joshuto<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>eJ', ':tab sp<CR>:Joshuto<CR>', { noremap = true, silent = true })
    end
}

return M
