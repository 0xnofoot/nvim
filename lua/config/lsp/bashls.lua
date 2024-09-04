L = {
    setup = function(lspconfig)
        lspconfig.bashls.setup({

            filetypes = { "sh", "zsh" },

        })
    end,
}

return L
