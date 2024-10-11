-- please read through this file and change what you need to change

vim.g.nvim_config_path = os.getenv("HOME") .. "/.config/nvim"

vim.g.tool_config_path = vim.g.nvim_config_path .. "/tool"

-- make it
vim.g.python = "python"
-- for Ultisnips
vim.g.python3_host_prog = "/usr/bin/python3"

vim.g.mason_package_path = os.getenv("HOME") .. "/.local/share/nvim/mason/packages"

vim.g.snips_author = "ToofonWang"

vim.g.sourcekit_path =
"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp"

vim.g.flutter_sdk_path = "$HOME/.local/development/flutter"
