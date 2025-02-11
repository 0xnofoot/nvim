L = {
    setup = function(lspconfig)
        lspconfig.sourcekit.setup({
            -- cmd             = {
            --     vim.g.sourcekit_path,
            -- },

            filetypes       = { "swift", "objective-c", "objc", "objective-cpp", "objcpp", "c", "cpp" },

            get_language_id = function(_, ftype)
                if ftype == "objc" then
                    return "objective-c"
                end

                if ftype == "objcpp" then
                    return "objective-cpp"
                end
                return ftype
            end,

            capabilities    = {
                workspace = {
                    didChangeWatchedFiles = {
                        dynamicRegistration = true,
                    },
                },
            },

            root_dir        = function(filename, _)
                local util = require("lspconfig.util")
                return util.root_pattern("buildServer.json")(filename)
                    or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
                    or util.find_git_ancestor(filename)
                    or util.root_pattern("Pods", "Podfile")(filename)
                    or util.root_pattern("Package.swift")(filename)
                    or vim.fn.getcwd()
            end,
        })
    end,
}


return L
