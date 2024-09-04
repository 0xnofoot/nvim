local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 自定义插件配置
require("lazy").setup({

    -- 主题样式配置
    require("config.plugins.style"),

    -- 编辑优化
    -- 一系列编辑优化插件
    require("config.plugins.editor"),

    -- 查找
    -- 根据文件内容查找文件, fzf 相比于 telescope 更准确
    require("config.plugins.fzf"),
    -- telescope
    require("config.plugins.telescope"),
    -- 在 nvim 中打开joshuto
    require("config.plugins.joshuto"),

    -- lsp 配置
    -- lsp 主配置
    require("config.plugins.lspconfig"),
    -- lsp 自动补全
    require("config.plugins.autocomplete"),
    -- treesitter 文本分析
    require("config.plugins.treesitter"),
    -- 提供 range format 能力，不依赖 lsp 需要单独配置
    require("config.plugins.conform"),

    -- 运行和调试
    require("config.plugins.lang"),
    require("config.plugins.debugger"),

    -- 其他特定框架和环境所需要的插件
    require("config.plugins.framework"),
})
