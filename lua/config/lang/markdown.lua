L = {

    plugins = {
        -- install without yarn or npm
        {
            "iamcco/markdown-preview.nvim",
            cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
            ft = { "markdown" },
            build = function() vim.fn["mkdp#util#install"]() end,
        },
    },

    run_action = function()
        vim.cmd('MarkdownPreview')
    end,
}

return L
