-- please read through this file and change what you need to change

-- make it
vim.g.python = 'python'
-- for Ultisnips
vim.g.python3_host_prog = '/usr/bin/python3'

vim.g.mason_package_path = os.getenv('HOME') .. '/.local/share/nvim/mason/packages'

vim.g.efm_config_path = os.getenv('HOME') .. '/.config/nvim/tool/efm/config.yaml'

vim.g.snips_author = 'Toofon Wang'

vim.g.sourcekit_path = "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp"
