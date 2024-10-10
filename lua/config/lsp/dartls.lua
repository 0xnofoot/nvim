L = {
    -- 该配置不由 lsp-config 持有，返回给给 fluuter-tools 插件管理
    config = {
        color = {
            enabled = true,
            background = false,
            background_color = nil,
            foreground = false,
            virtual_text = false,
            virtual_text_str = "■",
        },
        autostart = true,
        on_attach = function(client, bufnr)
            vim.cmd('highlight! link FlutterWidgetGuides Comment')
            client.server_capabilities.semanticTokensProvider = nil
        end,
        capabilities = require("lsp-zero").build_options("dartls", {}).capabilities,
        settings = {
            enableSnippets = false,
            showTodos = true,
            completeFunctionCalls = true,
            analysisExcludedFolders = {
                vim.fn.expand '$HOME/.pub-cache',
                vim.fn.expand '$HOME/fvm',
            },
            lineLength = 100,
        },
    }
}

return L
