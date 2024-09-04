M = {
    {
        'stevearc/conform.nvim',
        branch = "nvim-0.9",
        opts = {},
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    objc = { "clang-format" },
                    swift = { "swiftformat" },
                },
            })
        end,
    },
}

return M
