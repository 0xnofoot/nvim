L = {
    setup = function(lspconfig)
        lspconfig.yamlls.setup({
            on_attach = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = true
            end,
        })
    end,
}

return L
