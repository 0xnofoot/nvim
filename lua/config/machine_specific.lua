-- please read through this file and change what you need to change

vim.g.nvim_config_path = os.getenv("HOME") .. "/.config/nvim"

vim.g.tool_config_path = vim.g.nvim_config_path .. "/tool"

-- make it
vim.g.python = "python"

vim.g.mason_package_path = os.getenv("HOME") .. "/.local/share/nvim/mason/packages"

vim.g.snips_author = "nofoot"
