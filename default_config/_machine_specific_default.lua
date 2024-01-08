-- please read through this file and change what you need to change

vim.g.python3_host_prog = '/usr/bin/python3'

vim.g.efm_config_path = os.getenv("HOME") .. '/.config/nvim/tool/efm/config.ymal'

vim.g.sourcekit_path =
'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp'

vim.g.codelldb_path = os.getenv("HOME") .. "/.config/nvim/tool/swift/codelldb/extension/adapter/codelldb"

vim.g.liblldb_path = '/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB'
