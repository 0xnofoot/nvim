L = {
    -- 该配置不由 lsp-config 持有，返回给给 flutter-tools 插件管理
    config = {
        color        = {
            enabled = true,
            background = false,
            background_color = nil,
            foreground = false,
            virtual_text = false,
            virtual_text_str = "■",
        },
        autostart    = true,
        on_attach    = function(client, bufnr)
            vim.cmd("highlight! link FlutterWidgetGuides Comment")
            client.server_capabilities.semanticTokensProvider = nil
        end,
        capabilities = require("lsp-zero").build_options("dartls", {}).capabilities,
        settings     = {
            lineLength              = 100,
            showTodos               = true,
            completeFunctionCalls   = true,
            analysisExcludedFolders = {
                vim.fn.expand "$HOME/.pub-cache",
                vim.fn.expand(vim.g.flutter_sdk_path),
            },
            renameFilesWithClasses  = "prompt", -- "always"
            enableSnippets          = true,
            updateImportsOnRename   = true,     --
        },
    }
}

return L
